%% ��ȡ�������������Ͳ�����������������
M_DST=sina_future_hist_data_get('M0'); % ��ȡ������������
RM_DST=sina_future_hist_data_get('RM0'); % ��ȡ������������
DATA=sortrows(join(M_DST,RM_DST,'keys','DATE','mergekeys',true,'type','inner'),'DATE');
%% Э����ϵ����
egcitest([tick2ret(DATA.M0_CLOSE_PRICE),tick2ret(DATA.RM0_CLOSE_PRICE)])
%% �鿴���ߵ��������������ϵ��
corr(tick2ret(DATA.M0_CLOSE_PRICE),tick2ret(DATA.RM0_CLOSE_PRICE))
%% �ȼ۷���
Rseq_raw=DATA.M0_CLOSE_PRICE./DATA.RM0_CLOSE_PRICE;
MEAN=mean(Rseq_raw);
plot(DATA.DATE,Rseq_raw,'b-')
hold on
plot(DATA.DATE(1:50:end),MEAN*ones(size(DATA.DATE(1:50:end))),'k+')
plot(DATA.DATE(1:50:end),MEAN+2*std(Rseq_raw)*ones(size(DATA.DATE(1:50:end))),'ro')
plot(DATA.DATE(1:50:end),MEAN-2*std(Rseq_raw)*ones(size(DATA.DATE(1:50:end))),'ro')
plot(DATA.DATE(1:50:end),MEAN+std(Rseq_raw)*ones(size(DATA.DATE(1:50:end))),'bx')
plot(DATA.DATE(1:50:end),MEAN-std(Rseq_raw)*ones(size(DATA.DATE(1:50:end))),'bx')
legend('���̼�','��ֵ','+2������','-2������','+1������','-1������')
title(strcat('���������۸�/���������۸�,��ֵ=',num2str(MEAN)))
axis tight
datetick('x','yyyy-mm-dd','keepticks')
ax=gca;
ax.XTickLabelRotation = 20;
%% %%%%%%%%%%%%%%%%%%%%% ����������%%%%%%%%%%%%%%%%%%%%%% %%
%% ���㷽��
Rseq=Rseq_raw-MEAN;
L1=-0.5*std(Rseq);
L2=-1*std(Rseq);
L3=-1.5*std(Rseq);
L4=-2*std(Rseq);
%% ����������������
weight_seq_long=gather(weight_gen(gpuArray(Rseq),L1,L2,L3,L4));
%% ����������������
weight_seq_short=gather(weight_gen(gpuArray(-Rseq),L1,L2,L3,L4));
%% ����һ�������Եļ۲�
R_diff=DATA.M0_CLOSE_PRICE-1.2286*DATA.RM0_CLOSE_PRICE;
%% ���������Եĺ�Լ��ֵ�������4�������Լ��㣩
value=4*(DATA.M0_CLOSE_PRICE(2:end)+1.2286*DATA.RM0_CLOSE_PRICE(2:end))*10;
%% �ֱ������������յ���������
Long_gain=cumsum(weight_seq_long(1:end-1).*diff(R_diff))*10;
short_gain=cumsum(weight_seq_short(1:end-1).*diff(-R_diff))*10;
%% ��������Ͷ��ı�֤����4�������Ե���ʷ����ֵ��30%���㣬�����������ߣ���ͼ 13 2��
figure
h(1)=subplot(3,1,1);
Long_npv=Long_gain./max(value)/0.3+1;
plot(DATA.DATE(2:end),Long_npv-1)
datetick('x','yyyy-mm-dd','keepticks')
title(sprintf('������������,�껯������=%.4f%%',...
	(exp(log(Long_npv(end)/Long_npv(1))/(length(Long_npv)/250))-1)*100))
ax=gca;
ax.XTickLabelRotation = 20;
h(2)=subplot(3,1,2);
short_npv=short_gain./max(value)/0.3+1;
plot(DATA.DATE(2:end),short_npv)
datetick('x','yyyy-mm-dd','keepticks')
title(sprintf('������������,�껯������=%.4f%%',...
	(exp(log(short_npv(end)/short_npv(1))/(length(short_npv)/250))-1)*100))
ax=gca;
ax.XTickLabelRotation = 20;
h(3)=subplot(3,1,3);
T_npv=Long_npv+short_npv-1;
plot(DATA.DATE(2:end),T_npv-1)
datetick('x','yyyy-mm-dd','keepticks')
title(sprintf('�������������,�껯������=%.4f%%',...
	(exp(log(T_npv(end)/T_npv(1))/(length(T_npv)/250))-1)*100))
ax=gca;
ax.XTickLabelRotation = 20;
linkaxes(h,'x')
axis tight
