function [VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,...
    POSITION,summary,code,initial_money,level,min_bail_rate)
%�������º�Լ������ʲ�����ֵ���м��뵽VALUE�ҽ���֤�����м���BAIL;
%VALUEΪ�ʲ�����ֵ����;
%BAILΪ��֤������;
%codeΪ�ڻ�����;
%initial_moneyΪ��ʼ�����ʲ�;
%levelΪÿ������;
%min_bail_rateΪ��ͱ�֤�����;
[Value_add,summary_add,positions]=turtle_trading(...
    code,initial_money,level,min_bail_rate);
summary=[summary;summary_add];
VALUE=join(VALUE,mat2dataset(Value_add(:,1:2),'VarNames',{'date',code}),...
    'keys','date','mergekeys',true,'type','outer');
BAIL=join(BAIL,dataset(Value_add(:,1),Value_add(:,3),'VarNames',{'date',code}),...
    'keys','date','mergekeys',true,'type','outer');
POSITION=join(POSITION,dataset(Value_add(:,1),positions,'VarNames',...
    {'date',code}), 'keys','date','mergekeys',true,'type','outer');
