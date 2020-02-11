function [VB,VALUE,BAIL,summary]=turtle_trading_main_contract
%% 中金所
% IF 1点300元 保证金15%
init_money=10000000;
summary={'代码','开始时间','结束时间','年化收益率%',...
    '法则一交易次数','开仓间隔天数','胜率%',...
    '法则二交易次数','开仓间隔天数','胜率%'};
[Value_add,summary_add,positions]=turtle_trading('IF0',init_money,300,15);
summary=[summary;summary_add];
VALUE=mat2dataset(Value_add(:,1:2),'VarNames',{'date','IF0'});
BAIL=dataset(Value_add(:,1),Value_add(:,3),'VarNames',{'date','IF0'});
POSITION=dataset(Value_add(:,1),positions,'VarNames',{'date','IF0'});
% IH 1点300元 保证金15%
[Value_add,summary_add,positions]=turtle_trading('IH0',init_money,300,15);
summary=[summary;summary_add];
VALUE=join(VALUE,mat2dataset(Value_add(:,1:2),'VarNames',{'date','IH0'}),...
    'keys','date','mergekeys',true,'type','outer');
BAIL=join(BAIL,dataset(Value_add(:,1),Value_add(:,3),'VarNames',...
    {'date','IH0'}),'keys','date','mergekeys',true,'type','outer');
POSITION=join(POSITION,dataset(Value_add(:,1),positions,'VarNames',...
    {'date','IH0'}), 'keys','date','mergekeys',true,'type','outer'); ijm  
% IC 1点200元 保证金15%
[Value_add,summary_add,positions]=turtle_trading('IC0',init_money,200,15);
summary=[summary;summary_add];
VALUE=join(VALUE,mat2dataset(Value_add(:,1:2),'VarNames',{'date','IC0'}),...
    'keys','date','mergekeys',true,'type','outer');
BAIL=join(BAIL,dataset(Value_add(:,1),Value_add(:,3),'VarNames',...
    {'date','IC0'}),'keys','date','mergekeys',true,'type','outer');
POSITION=join(POSITION,dataset(Value_add(:,1),positions,'VarNames',...
    {'date','IC0'}), 'keys','date','mergekeys',true,'type','outer');   
%% 大连交易所 将上面的品种增加过程封装到 INFORMATION_ADDER 函数
% 铁矿 代码I0 1手100吨 保证金15%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'I0',init_money,100,15);
% 玉米 代码C0 1手10吨 保证金10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'C0',init_money,10,10);
% 豆粕 代码M0 1手10吨 保证金10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'M0',init_money,10,10);
% 焦煤 代码JM0 1手100吨 保证金15%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'JM0',init_money,100,15);
% 豆油 代码Y0 1手10吨 保证金10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'Y0',init_money,10,10);
% 焦炭 代码J0 1手60吨 保证金15%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'J0',init_money,60,15);
%% 郑州交易所
% 郑醇 代码MA0 1手10吨 保证金10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'MA0',init_money,10,10);
% PTA 代码TA0 1手5吨 保证金10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'TA0',init_money,5,10);
% 郑煤 代码ZC0 1手100吨 保证金15%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'ZC0',init_money,100,15);
% 白糖 代码SR0 1手10吨 保证金10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'CF0',init_money,10,10);
% 郑棉 代码CF0 1手5吨 保证金10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'SR0',init_money,5,10);
% 菜粕 代码RM0 1手10吨 保证金10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'RM0',init_money,10,10);
%% 上海交易所
% 螺纹 代码RB0 1手10吨 保证金15%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'RB0',init_money,10,15);
% 沪镍 代码NI0 1手1吨 保证金10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'NI0',init_money,1,10);
% 银 代码AG0 1手15千克吨 保证金10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'AG0',init_money,15,10);
% 沥青 代码BU0 1手10吨 保证金10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'BU0',init_money,10,10);
% 铜 代码CU0 1手5吨 保证金10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'CU0',init_money,5,10);
% 橡胶 代码RU0 1手10吨 保证金10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'RU0',init_money,10,10);
%% NaN数据处理
for col=2:size(VALUE,2)
    if isnan(double(VALUE(1,col)))
        VALUE{1,col}=0;
        BAIL{1,col}=0;
    end
    for daynumber=2:size(VALUE,1)
        if isnan(double(VALUE(daynumber,col)))
            VALUE(daynumber,col)=VALUE(daynumber-1,col);
            BAIL(daynumber,col)=BAIL(daynumber-1,col);
        end
    end
end
%% 分散化投资组合一
V_r=mat2dataset([VALUE.date,sum(double(VALUE(:,2:end)),2)],'VarNames',{'date','value'});
B_r=mat2dataset([BAIL.date,sum(double(BAIL(:,2:end)),2)],'VarNames',{'date','bail'});
P_r=mat2dataset([POSITION.date,nansum(double(POSITION(:,2:end)),2)],'VarNames',{'date','position'});
% 调整一：品种法则触发数按上限调整，总触发不超过10个
thres=10;
V=V_r;
V.value=zeros(size(V.value));
B=B_r;
B.bail=zeros(size(B.bail));
P=P_r;
P.position=zeros(size(P.position));
for daynumber=1:size(V_r,1)-1
    P.position(daynumber)=min(thres,P_r.position(daynumber));
    if P_r.position(daynumber)>0
        V.value(daynumber+1)=V.value(daynumber)+...
            (V_r.value(daynumber+1)-V_r.value(daynumber))...
            *P.position(daynumber)/P_r.position(daynumber);
        B.bail(daynumber)=B_r.bail(daynumber)...
            *P.position(daynumber)/P_r.position(daynumber);
    else
        V.value(daynumber+1)=V.value(daynumber);
         B.bail(daynumber)=B_r.bail(daynumber);         
    end
end

% 调整二：按照风险度上限调整
thres_bail=0.3; %保证金占比 30%
VB=join(V,B,'keys','date','mergekeys',true,'type','inner');
%按照实际资金计算的收益
VB.true_value=zeros(size(VB.date));
%按照实际资金计算的保证金
VB.true_bail=zeros(size(VB.date));
for daynumber=1:size(VB,1)-1
    
    VB.true_bail(daynumber)=min(thres_bail*...
        (init_money+VB.true_value(daynumber)),VB.bail(daynumber));
    if VB.bail(daynumber)>0
    VB.true_value(daynumber+1)=VB.true_value(daynumber)+...
        (VB.value(daynumber+1)-VB.value(daynumber))...
        *VB.true_bail(daynumber)/VB.bail(daynumber);
    else
         VB.true_value(daynumber+1)=VB.true_value(daynumber);
    end
end
VB.true_bail(end)=min(thres_bail*(init_money+VB.true_value(end)),...
    VB.bail(end));

%% 分散化投资组合二
VALUE2=VALUE;
BAIL2=BAIL;
VALUE_T=zeros(size(VALUE2.date));
%将所有持仓期货品种在按每日收盘价平均分配资金并计算下一交易日的收益
for row=1:size(VALUE2,1)-1
    VALUE_T(row,1)=sum(double(VALUE2(row,2:end)))+init_money;
    for col=2:size(VALUE2,2)
        VALUE2{row+1,col}=VALUE2{row,col}+...
            (VALUE{row+1,col}-VALUE{row,col})...
            *VALUE_T(row,1)/(VALUE{row,col}+init_money);
        BAIL2{row,col}=BAIL{row,col}*VALUE_T(row,1)/(VALUE{row,col}+init_money);
    end
end
VALUE_T(end,1)=sum(double(VALUE2(end,2:end)))+init_money;

V2_r=mat2dataset([VALUE2.date,sum(double(VALUE2(:,2:end)),2)],'VarNames',{'date','value'});
B2_r=mat2dataset([BAIL2.date,sum(double(BAIL2(:,2:end)),2)],'VarNames',{'date','bail'});
P2_r=mat2dataset([POSITION.date,nansum(double(POSITION(:,2:end)),2)],'VarNames',{'date','position'});
% 调整一：品种法则触发数按上限调整，总触发不超过10个
thres2=10;
V2=V2_r;
V2.value=zeros(size(V2.value));
B2=B2_r;
B2.bail=zeros(size(B2.bail));
P2=P2_r;
P2.position=zeros(size(P2.position));
for daynumber=1:size(V2_r,1)-1
    P2.position(daynumber)=min(thres2,P2_r.position(daynumber));
    if P2_r.position(daynumber)>0
        V2.value(daynumber+1)=V2.value(daynumber)+...
            (V2_r.value(daynumber+1)-V2_r.value(daynumber))...
            *P2.position(daynumber)/P2_r.position(daynumber);
        B2.bail(daynumber)=B2_r.bail(daynumber)...
            *P2.position(daynumber)/P2_r.position(daynumber);
    else
        V2.value(daynumber+1)=V2.value(daynumber);
         B2.bail(daynumber)=B2_r.bail(daynumber);   
    end
end

% 调整二：按照风险度上限调整
thres2_bail=0.3; %保证金占比 30%
VB2=join(V2,B2,'keys','date','mergekeys',true,'type','inner');
%按照实际资金计算的收益
VB2.true_value=zeros(size(VB2.date));
%按照实际资金计算的保证金
VB2.true_bail=zeros(size(VB2.date));

for daynumber=1:size(VB2,1)-1
    %按照实际可投入保证金计算收益
    VB2.true_bail(daynumber)=min(thres2_bail*...
        (init_money+VB2.true_value(daynumber)),VB2.bail(daynumber));
    if VB2.bail(daynumber)>0
    VB2.true_value(daynumber+1)=VB2.true_value(daynumber)+...
        (VB2.value(daynumber+1)-VB2.value(daynumber))...
        *VB2.true_bail(daynumber)/VB2.bail(daynumber);
    else
        VB2.true_value(daynumber+1)=VB2.true_value(daynumber);
    end
end
VB2.true_bail(end)=min(thres2_bail*(init_money+VB2.true_value(end)),...
    VB2.bail(end));
%% 画图
figure;
h(1)=subplot(2,1,1);
npv1=VB.true_value./init_money+1;
plot(VB.date,npv1,'r-')
hold on
npv2=VB2.true_value./init_money+1;
plot(VB2.date(1:10:end),npv2(1:10:end),'k+')
datetick('x','yyyy-mm-dd','keepticks')
ax=gca;
ax.XTickLabelRotation = 20;
axis tight
legend(sprintf('组合一:净值曲线,年化%.2f%%',...
    (exp(log(VB.true_value(end)/init_money+1)/...
    (length(VB.true_value)/250))-1)*100),...
    sprintf('组合二:净值曲线,年化%.2f%%',...
    (exp(log(VB2.true_value(end)/init_money+1)/...
    (length(VB2.true_value)/250))-1)*100),'location','best');
title('净值曲线');
h(2)=subplot(2,1,2);
risk_ratio_1=VB.true_bail./(VB.true_value+10000000)*100;
plot(VB.date,risk_ratio_1,'r-');
hold on
risk_ratio_2=VB2.true_bail./(VB2.true_value+10000000)*100;
plot(VB2.date(1:80:end),risk_ratio_2(1:80:end),'ko');
ax=gca;
ax.XTickLabelRotation = 20;
datetick('x','yyyy-mm-dd','keepticks')
axis tight
legend('组合一','组合二','location','best');
title('风险度%');
