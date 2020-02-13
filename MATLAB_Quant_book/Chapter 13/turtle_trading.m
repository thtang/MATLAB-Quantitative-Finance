function [Value_add,summary,positions,Dat,Dat2]=turtle_trading(...
    code,init_money,level,min_bail_rate)
% Value_add  ��������Ϊʱ�䡢�ʲ�����ֵ�ͱ�֤��;
% summary ����Ϊ ���롢�������ݿ�ʼʱ�䡢�������ݽ���ʱ�䡢
%           �껯�����ʡ�����һ���״�����ƽ�����ֵȴ�ʱ�䡢ʤ�ʺ� 
%           ������Ľ��״�����ƽ�����ֵȴ�ʱ�䡢ʤ��
% positionsΪ�������ֵķ�����,��СΪ0,���Ϊ2,�Ҳ����ַ���
% Dat Ϊ����һ������ϸ
% Dat2 Ϊ�����������ϸ
% init_money Ϊ��ʼ�����ʲ�
% levelΪÿ������
% min_bail_rateΪ��֤�����
%% ����һ����
Dat_raw=DATA_prep(code);
Dat=Dat_raw;
% ���ɽ���״̬�� 
%��ͷ���� �ֲ� ƽ�ֶ�Ӧ 1 2 3
%��ͷ���� �ֲ� ƽ�ֶ�Ӧ 4 5 6
Dat.status=zeros(size(Dat.date));
% ���ɽ��׿��̼���
Dat.open_price=zeros(size(Dat.date));
% �������ڼ��������ʵĽ���ͷ�緽�����
% �ֻ�ƽ��ֵ�����Ϊ+1,�ֻ�ƽ�ղֵ�����Ϊ-1
Dat.position=zeros(size(Dat.date));
% ����ֹ��۸�����
Dat.stop_price=zeros(size(Dat.date));
% ����ǰ�����̼�����
Dat.preclose=zeros(size(Dat.date));
% ���ɵ��������������
Dat.gain=zeros(size(Dat.date));
% �ڽ��׽�������ʱ���ɵ�ǰ�ź��ۼ������������
Dat.gain_of_trade=zeros(size(Dat.date));
% �����ϴν���ӯ��������
Dat.last_gain_of_trade=zeros(size(Dat.date));
last_gain_of_trade=0;
for daynumber=2:size(Dat,1)
    Dat.preclose(daynumber)=Dat.CLOSE(daynumber-1);
    % ��ȡ��ͷ����״̬�����ּۺ�ֹ���
    if Dat.status(daynumber-1)==1 ||  Dat.status(daynumber-1)==2
        Dat.status(daynumber)=2;
        Dat.open_price(daynumber)=Dat.open_price(daynumber-1);
        Dat.stop_price(daynumber)=Dat.stop_price(daynumber-1);
    end
    % ��ȡ��ͷ����״̬�����ּۺ�ֹ���
    if Dat.status(daynumber-1)==4 ||  Dat.status(daynumber-1)==5
        Dat.status(daynumber)=5;
        Dat.open_price(daynumber)=Dat.open_price(daynumber-1);
        Dat.stop_price(daynumber)=Dat.stop_price(daynumber-1);
    end
    % �ɽ����źż��㽻����Ϣ,����
    if Dat.signal_1(daynumber)==1 && Dat.status(daynumber-1)==0
        Dat.status(daynumber)=1;
        Dat.open_price(daynumber)=Dat.CLOSE(daynumber);
        Dat.stop_price(daynumber)=Dat.CLOSE(daynumber)-2*Dat.N(daynumber);
    end
    % �ɽ����źż��㽻����Ϣ,����
    if Dat.signal_1(daynumber)==-1 && Dat.status(daynumber-1)==0
        Dat.status(daynumber)=4;
        Dat.open_price(daynumber)=Dat.CLOSE(daynumber);
        Dat.stop_price(daynumber)=Dat.CLOSE(daynumber)+2*Dat.N(daynumber);
    end
    % �ɽ����źż��㽻����Ϣ,ƽ��
    if Dat.quit_1(daynumber)==-1 && ...
            ( Dat.status(daynumber-1)==1 || Dat.status(daynumber-1)==2)
        Dat.status(daynumber)=3;
    end
    % �ɽ����źż��㽻����Ϣ,ƽ��
    if Dat.quit_1(daynumber)==1 && ...
            ( Dat.status(daynumber-1)==4 || Dat.status(daynumber-1)==5)
        Dat.status(daynumber)=6;
    end
    % �����λ����    
    if Dat.status(daynumber)==5 || Dat.status(daynumber)==6
        Dat.position(daynumber)=-1;
    end
    % �����λ����
    if Dat.status(daynumber)==2 || Dat.status(daynumber)==3
        Dat.position(daynumber)=1;
    end
    % ��ͷֹ��
    if Dat.position(daynumber)==1 && Dat.CLOSE(daynumber)<...
            Dat.stop_price(daynumber)
        Dat.status(daynumber)=3;
    end
    % ��ͷֹ��
    if Dat.position(daynumber)==-1 && Dat.CLOSE(daynumber)>...
            Dat.stop_price(daynumber)
        Dat.status(daynumber)=6;
    end
    % �����ͷ����
    if Dat.status(daynumber)==2 || Dat.status(daynumber)==3
        Dat.gain(daynumber)=Dat.CLOSE(daynumber)-Dat.preclose(daynumber);
    end
    % �����ͷ����
    if Dat.status(daynumber)==5 || Dat.status(daynumber)==6
        Dat.gain(daynumber)=-Dat.CLOSE(daynumber)+Dat.preclose(daynumber);
    end
    % ��ȡ�ϱʽ��������
    if Dat.position(daynumber)==1 || Dat.position(daynumber)==-1 ...
            || Dat.status(daynumber)==1 || Dat.status(daynumber)==4
        Dat.last_gain_of_trade(daynumber)=last_gain_of_trade;
    end
    % ��¼���ʶ�ͷ����������Ϊѭ�����±ʽ��׵��ϱ������
    if Dat.status(daynumber)==3
        Dat.gain_of_trade(daynumber)=Dat.CLOSE(daynumber)...
            -Dat.open_price(daynumber);
        last_gain_of_trade=Dat.gain_of_trade(daynumber);
    end
    % ��¼���ʿ�ͷ����������Ϊѭ�����±ʽ��׵��ϱ������
    if Dat.status(daynumber)==6
        Dat.gain_of_trade(daynumber)=-Dat.CLOSE(daynumber)...
            +Dat.open_price(daynumber);
        last_gain_of_trade=Dat.gain_of_trade(daynumber);
    end
end
% ����һ�����ϱʽ���ӯ��������źŹ���
Dat.gain_after_adj=Dat.gain;
Dat.status_adj=Dat.status;
Dat.gain_after_adj(Dat.last_gain_of_trade>0)=0;
Dat.status_adj(Dat.last_gain_of_trade>0)=0;

%% ���������
% �����źŹ��˲���,���������ͱ����еĳ�Ա�����ͬ����һ
Dat2=Dat_raw;
Dat2.status=zeros(size(Dat2.date));
Dat2.open_price=zeros(size(Dat2.date));
Dat2.position=zeros(size(Dat2.date));
Dat2.stop_price=zeros(size(Dat2.date));
Dat2.preclose=zeros(size(Dat2.date));
Dat2.gain=zeros(size(Dat2.date));
Dat2.gain_of_trade=zeros(size(Dat2.date));
for daynumber=2:size(Dat2,1)
    Dat2.preclose(daynumber)=Dat2.CLOSE(daynumber-1);
    if Dat2.status(daynumber-1)==1 ||  Dat2.status(daynumber-1)==2
        Dat2.status(daynumber)=2;
        Dat2.open_price(daynumber)=Dat2.open_price(daynumber-1);
        Dat2.stop_price(daynumber)=Dat2.stop_price(daynumber-1);
    end
    if Dat2.status(daynumber-1)==4 ||  Dat2.status(daynumber-1)==5
        Dat2.status(daynumber)=5;
        Dat2.open_price(daynumber)=Dat2.open_price(daynumber-1);
        Dat2.stop_price(daynumber)=Dat2.stop_price(daynumber-1);
    end
    if Dat2.signal_2(daynumber)==1 && Dat2.status(daynumber-1)==0
        Dat2.status(daynumber)=1;
        Dat2.open_price(daynumber)=Dat2.CLOSE(daynumber);
        Dat2.stop_price(daynumber)=Dat2.CLOSE(daynumber)-2*Dat2.N(daynumber);
    end
    if Dat2.signal_2(daynumber)==-1 && Dat2.status(daynumber-1)==0
        Dat2.status(daynumber)=4;
        Dat2.open_price(daynumber)=Dat2.CLOSE(daynumber);
        Dat2.stop_price(daynumber)=Dat2.CLOSE(daynumber)+2*Dat2.N(daynumber);
    end
    if Dat2.quit_2(daynumber)==-1 && ...
            ( Dat2.status(daynumber-1)==1 || Dat2.status(daynumber-1)==2)
        Dat2.status(daynumber)=3;
    end
    if Dat2.quit_2(daynumber)==1 &&  ...
            ( Dat2.status(daynumber-1)==4 || Dat2.status(daynumber-1)==5)
        Dat2.status(daynumber)=6;
    end
    if Dat2.status(daynumber)==5 || Dat2.status(daynumber)==6
        Dat2.position(daynumber)=-1;
    end
    if Dat2.status(daynumber)==2 || Dat2.status(daynumber)==3
        Dat2.position(daynumber)=1;
    end
    if Dat2.position(daynumber)==1 && Dat2.CLOSE(daynumber)<...
            Dat2.stop_price(daynumber)
        Dat2.status(daynumber)=3;
    end
    if Dat2.position(daynumber)==-1 && Dat2.CLOSE(daynumber)>...
            Dat2.stop_price(daynumber)
        Dat2.status(daynumber)=6;
    end    
    if Dat2.status(daynumber)==2 || Dat2.status(daynumber)==3
        Dat2.gain(daynumber)=Dat2.CLOSE(daynumber)-Dat2.preclose(daynumber);
    end
    if Dat2.status(daynumber)==5 || Dat2.status(daynumber)==6
        Dat2.gain(daynumber)=-Dat2.CLOSE(daynumber)+Dat2.preclose(daynumber);
    end
    if Dat2.status(daynumber)==3
        Dat2.gain_of_trade(daynumber)=Dat2.CLOSE(daynumber)...
            -Dat2.open_price(daynumber);
    end  
    if Dat2.status(daynumber)==6
        Dat2.gain_of_trade(daynumber)=-Dat2.CLOSE(daynumber)...
            +Dat2.open_price(daynumber);
    end
end
%% �������
% ����һ����
Dat.num_of_position=zeros(size(Dat.date));
% ���������
Dat2.num_of_position=zeros(size(Dat.date));
% �ʲ�����
value=init_money*ones(size(Dat.date));
if Dat.status_adj(1)==1
    Dat.num_of_position(1)=value(1)/Dat.N(1)/level*0.01;
end
if Dat2.status(1)==1
    Dat2.num_of_position(1)=value(1)/Dat2.N(1)/level*0.01;
end

for daynumber=2:size(Dat,1)
    value(daynumber)=value(daynumber-1);
    % �������һ�гֲ�������ʲ��仯
    if Dat.status(daynumber)==2 || Dat.status(daynumber)==3 ...
            || Dat.status(daynumber)==5 || Dat.status(daynumber)==6
        Dat.num_of_position(daynumber)=Dat.num_of_position(daynumber-1);
        value(daynumber)=value(daynumber)+Dat.num_of_position(daynumber)...
            *Dat.gain_after_adj(daynumber)*level;
    end
    % ���������гֲ�������ʲ��仯    
    if Dat2.status(daynumber)==2 || Dat2.status(daynumber)==3 ...
            || Dat2.status(daynumber)==5 || Dat2.status(daynumber)==6
        Dat2.num_of_position(daynumber)=Dat2.num_of_position(daynumber-1);
        value(daynumber)=value(daynumber)+Dat2.num_of_position(daynumber)...
            *Dat2.gain(daynumber)*level;
    end
    % �������һ�¿������������
    if Dat.status(daynumber)==1 || Dat.status(daynumber)==4
        Dat.num_of_position(daynumber)=floor(value(daynumber)/...
            Dat.N(daynumber)/level*0.01);
    end
    % ���������¿������������    
    if Dat2.status(daynumber)==1 || Dat2.status(daynumber)==4
        Dat2.num_of_position(daynumber)=floor(value(daynumber)/...
            Dat2.N(daynumber)/level*0.01);
    end
end
% �ֱ������������ı�֤������
Dat.bail=Dat.num_of_position.*Dat.CLOSE.*min_bail_rate/100*level;
Dat2.bail=Dat2.num_of_position.*Dat2.CLOSE.*min_bail_rate/100*level;
% �����������
yr_rate=(exp(log(value(end)/value(1))/(length(value)/250))-1)*100;
sys_1_no=sum(Dat.status==3)+ sum(Dat.status==6);
sys_2_no=sum(Dat2.status==3)+ sum(Dat2.status==6);
summary=[{code},... %����
    {datestr(Dat.date(1)),datestr(Dat.date(end))},... %����������ֹʱ��
    {yr_rate},... %�껯������ ��ʽ X.XX%
    {sys_1_no},... %����һ���״���
    {size(Dat,1)/sys_1_no},... %����һƽ�����ֵȴ�ʱ��
    {sum(Dat.gain_of_trade>0)/sys_1_no*100},... %����һʤ�� ��ʽ X.XX%
    {sys_2_no},... %��������״��� 
    {size(Dat,1)/sys_2_no},... %�����ƽ�����ֵȴ�ʱ��
    {sum(Dat2.gain_of_trade>0)/sys_2_no*100}];%�����ʤ�� ��ʽ X.XX%
%% ����ʵ���ʲ�����ͷ��
bails=Dat.bail+Dat2.bail;
true_value=value;
true_bail=bails;
for daynumber=1:size(value,1)-1
    %ʵ�ʱ�֤��Ӧ������ʵ���ʲ�����Ҫ��֤��Ľ�С��
    true_bail(daynumber)=min(true_value(daynumber),bails(daynumber));
    if bails(daynumber)==0
        continue;
    end
    true_value(daynumber+1)=true_value(daynumber)+...
        (value(daynumber+1)-value(daynumber))...
        *true_bail(daynumber)/bails(daynumber);
end
true_bail(end)=min(true_value(end),bails(end));
% ���������������Ϊʱ�䡢�ʲ�����ֵ��ʵ�ʱ�֤��
Value_add=[Dat.date,true_value-init_money,true_bail];
% ���㴥���ķ������
positions=(Dat.num_of_position>0)+(Dat2.num_of_position>0);