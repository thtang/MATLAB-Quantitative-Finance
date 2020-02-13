%% 获取豆粕主力连续和菜粕主力连续的数据
M_DST=sina_future_hist_data_get('M0'); % 获取豆粕主连数据
RM_DST=sina_future_hist_data_get('RM0'); % 获取菜粕主连数据
DATA=sortrows(join(M_DST,RM_DST,'keys','DATE','mergekeys',true,'type','inner'),'DATE');
%% 协整关系检验
egcitest([tick2ret(DATA.M0_CLOSE_PRICE),tick2ret(DATA.RM0_CLOSE_PRICE)])
%% 查看二者的收益率序列相关系数
corr(tick2ret(DATA.M0_CLOSE_PRICE),tick2ret(DATA.RM0_CLOSE_PRICE))
%% 比价分析
Rseq_raw=DATA.M0_CLOSE_PRICE./DATA.RM0_CLOSE_PRICE;
MEAN=mean(Rseq_raw);
plot(DATA.DATE,Rseq_raw,'b-')
hold on
plot(DATA.DATE(1:50:end),MEAN*ones(size(DATA.DATE(1:50:end))),'k+')
plot(DATA.DATE(1:50:end),MEAN+2*std(Rseq_raw)*ones(size(DATA.DATE(1:50:end))),'ro')
plot(DATA.DATE(1:50:end),MEAN-2*std(Rseq_raw)*ones(size(DATA.DATE(1:50:end))),'ro')
plot(DATA.DATE(1:50:end),MEAN+std(Rseq_raw)*ones(size(DATA.DATE(1:50:end))),'bx')
plot(DATA.DATE(1:50:end),MEAN-std(Rseq_raw)*ones(size(DATA.DATE(1:50:end))),'bx')
legend('收盘价','均值','+2倍方差','-2倍方差','+1倍方差','-1倍方差')
title(strcat('豆粕主连价格/菜粕主连价格,均值=',num2str(MEAN)))
axis tight
datetick('x','yyyy-mm-dd','keepticks')
ax=gca;
ax.XTickLabelRotation = 20;
%% %%%%%%%%%%%%%%%%%%%%% 策略主程序　%%%%%%%%%%%%%%%%%%%%%% %%
%% 计算方差
Rseq=Rseq_raw-MEAN;
L1=-0.5*std(Rseq);
L2=-1*std(Rseq);
L3=-1.5*std(Rseq);
L4=-2*std(Rseq);
%% 计算做多套利对数
weight_seq_long=gather(weight_gen(gpuArray(Rseq),L1,L2,L3,L4));
%% 计算做空套利对数
weight_seq_short=gather(weight_gen(gpuArray(-Rseq),L1,L2,L3,L4));
%% 计算一个套利对的价差
R_diff=DATA.M0_CLOSE_PRICE-1.2286*DATA.RM0_CLOSE_PRICE;
%% 计算套利对的合约价值（按最大4个套利对计算）
value=4*(DATA.M0_CLOSE_PRICE(2:end)+1.2286*DATA.RM0_CLOSE_PRICE(2:end))*10;
%% 分别计算做多和做空的收益曲线
Long_gain=cumsum(weight_seq_long(1:end-1).*diff(R_diff))*10;
short_gain=cumsum(weight_seq_short(1:end-1).*diff(-R_diff))*10;
%% 假设我们投入的保证金按照4个套利对的历史最大价值的30%计算，绘制收益曲线，见图 13 2，
figure
h(1)=subplot(3,1,1);
Long_npv=Long_gain./max(value)/0.3+1;
plot(DATA.DATE(2:end),Long_npv-1)
datetick('x','yyyy-mm-dd','keepticks')
title(sprintf('做多收益曲线,年化收益率=%.4f%%',...
	(exp(log(Long_npv(end)/Long_npv(1))/(length(Long_npv)/250))-1)*100))
ax=gca;
ax.XTickLabelRotation = 20;
h(2)=subplot(3,1,2);
short_npv=short_gain./max(value)/0.3+1;
plot(DATA.DATE(2:end),short_npv)
datetick('x','yyyy-mm-dd','keepticks')
title(sprintf('做空收益曲线,年化收益率=%.4f%%',...
	(exp(log(short_npv(end)/short_npv(1))/(length(short_npv)/250))-1)*100))
ax=gca;
ax.XTickLabelRotation = 20;
h(3)=subplot(3,1,3);
T_npv=Long_npv+short_npv-1;
plot(DATA.DATE(2:end),T_npv-1)
datetick('x','yyyy-mm-dd','keepticks')
title(sprintf('多空总收益曲线,年化收益率=%.4f%%',...
	(exp(log(T_npv(end)/T_npv(1))/(length(T_npv)/250))-1)*100))
ax=gca;
ax.XTickLabelRotation = 20;
linkaxes(h,'x')
axis tight
