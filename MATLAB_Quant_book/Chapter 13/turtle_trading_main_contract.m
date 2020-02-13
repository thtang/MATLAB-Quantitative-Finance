function [VB,VALUE,BAIL,summary]=turtle_trading_main_contract
%% �н���
% IF 1��300Ԫ ��֤��15%
init_money=10000000;
summary={'����','��ʼʱ��','����ʱ��','�껯������%',...
    '����һ���״���','���ּ������','ʤ��%',...
    '��������״���','���ּ������','ʤ��%'};
[Value_add,summary_add,positions]=turtle_trading('IF0',init_money,300,15);
summary=[summary;summary_add];
VALUE=mat2dataset(Value_add(:,1:2),'VarNames',{'date','IF0'});
BAIL=dataset(Value_add(:,1),Value_add(:,3),'VarNames',{'date','IF0'});
POSITION=dataset(Value_add(:,1),positions,'VarNames',{'date','IF0'});
% IH 1��300Ԫ ��֤��15%
[Value_add,summary_add,positions]=turtle_trading('IH0',init_money,300,15);
summary=[summary;summary_add];
VALUE=join(VALUE,mat2dataset(Value_add(:,1:2),'VarNames',{'date','IH0'}),...
    'keys','date','mergekeys',true,'type','outer');
BAIL=join(BAIL,dataset(Value_add(:,1),Value_add(:,3),'VarNames',...
    {'date','IH0'}),'keys','date','mergekeys',true,'type','outer');
POSITION=join(POSITION,dataset(Value_add(:,1),positions,'VarNames',...
    {'date','IH0'}), 'keys','date','mergekeys',true,'type','outer'); ijm  
% IC 1��200Ԫ ��֤��15%
[Value_add,summary_add,positions]=turtle_trading('IC0',init_money,200,15);
summary=[summary;summary_add];
VALUE=join(VALUE,mat2dataset(Value_add(:,1:2),'VarNames',{'date','IC0'}),...
    'keys','date','mergekeys',true,'type','outer');
BAIL=join(BAIL,dataset(Value_add(:,1),Value_add(:,3),'VarNames',...
    {'date','IC0'}),'keys','date','mergekeys',true,'type','outer');
POSITION=join(POSITION,dataset(Value_add(:,1),positions,'VarNames',...
    {'date','IC0'}), 'keys','date','mergekeys',true,'type','outer');   
%% ���������� �������Ʒ�����ӹ��̷�װ�� INFORMATION_ADDER ����
% ���� ����I0 1��100�� ��֤��15%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'I0',init_money,100,15);
% ���� ����C0 1��10�� ��֤��10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'C0',init_money,10,10);
% ���� ����M0 1��10�� ��֤��10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'M0',init_money,10,10);
% ��ú ����JM0 1��100�� ��֤��15%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'JM0',init_money,100,15);
% ���� ����Y0 1��10�� ��֤��10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'Y0',init_money,10,10);
% ��̿ ����J0 1��60�� ��֤��15%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'J0',init_money,60,15);
%% ֣�ݽ�����
% ֣�� ����MA0 1��10�� ��֤��10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'MA0',init_money,10,10);
% PTA ����TA0 1��5�� ��֤��10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'TA0',init_money,5,10);
% ֣ú ����ZC0 1��100�� ��֤��15%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'ZC0',init_money,100,15);
% ���� ����SR0 1��10�� ��֤��10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'CF0',init_money,10,10);
% ֣�� ����CF0 1��5�� ��֤��10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'SR0',init_money,5,10);
% ���� ����RM0 1��10�� ��֤��10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'RM0',init_money,10,10);
%% �Ϻ�������
% ���� ����RB0 1��10�� ��֤��15%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'RB0',init_money,10,15);
% ���� ����NI0 1��1�� ��֤��10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'NI0',init_money,1,10);
% �� ����AG0 1��15ǧ�˶� ��֤��10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'AG0',init_money,15,10);
% ���� ����BU0 1��10�� ��֤��10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'BU0',init_money,10,10);
% ͭ ����CU0 1��5�� ��֤��10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'CU0',init_money,5,10);
% �� ����RU0 1��10�� ��֤��10%
[VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,POSITION,...
    summary,'RU0',init_money,10,10);
%% NaN���ݴ���
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
%% ��ɢ��Ͷ�����һ
V_r=mat2dataset([VALUE.date,sum(double(VALUE(:,2:end)),2)],'VarNames',{'date','value'});
B_r=mat2dataset([BAIL.date,sum(double(BAIL(:,2:end)),2)],'VarNames',{'date','bail'});
P_r=mat2dataset([POSITION.date,nansum(double(POSITION(:,2:end)),2)],'VarNames',{'date','position'});
% ����һ��Ʒ�ַ��򴥷��������޵������ܴ���������10��
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

% �����������շ��ն����޵���
thres_bail=0.3; %��֤��ռ�� 30%
VB=join(V,B,'keys','date','mergekeys',true,'type','inner');
%����ʵ���ʽ���������
VB.true_value=zeros(size(VB.date));
%����ʵ���ʽ����ı�֤��
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

%% ��ɢ��Ͷ����϶�
VALUE2=VALUE;
BAIL2=BAIL;
VALUE_T=zeros(size(VALUE2.date));
%�����гֲ��ڻ�Ʒ���ڰ�ÿ�����̼�ƽ�������ʽ𲢼�����һ�����յ�����
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
% ����һ��Ʒ�ַ��򴥷��������޵������ܴ���������10��
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

% �����������շ��ն����޵���
thres2_bail=0.3; %��֤��ռ�� 30%
VB2=join(V2,B2,'keys','date','mergekeys',true,'type','inner');
%����ʵ���ʽ���������
VB2.true_value=zeros(size(VB2.date));
%����ʵ���ʽ����ı�֤��
VB2.true_bail=zeros(size(VB2.date));

for daynumber=1:size(VB2,1)-1
    %����ʵ�ʿ�Ͷ�뱣֤���������
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
%% ��ͼ
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
legend(sprintf('���һ:��ֵ����,�껯%.2f%%',...
    (exp(log(VB.true_value(end)/init_money+1)/...
    (length(VB.true_value)/250))-1)*100),...
    sprintf('��϶�:��ֵ����,�껯%.2f%%',...
    (exp(log(VB2.true_value(end)/init_money+1)/...
    (length(VB2.true_value)/250))-1)*100),'location','best');
title('��ֵ����');
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
legend('���һ','��϶�','location','best');
title('���ն�%');
