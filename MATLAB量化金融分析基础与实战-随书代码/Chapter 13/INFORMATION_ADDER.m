function [VALUE,BAIL,summary,POSITION]=INFORMATION_ADDER(VALUE,BAIL,...
    POSITION,summary,code,initial_money,level,min_bail_rate)
%函数将新合约代码的资产增加值序列加入到VALUE且将保证金序列加入BAIL;
%VALUE为资产增加值序列;
%BAIL为保证金序列;
%code为期货代码;
%initial_money为初始名义资产;
%level为每手重量;
%min_bail_rate为最低保证金比例;
[Value_add,summary_add,positions]=turtle_trading(...
    code,initial_money,level,min_bail_rate);
summary=[summary;summary_add];
VALUE=join(VALUE,mat2dataset(Value_add(:,1:2),'VarNames',{'date',code}),...
    'keys','date','mergekeys',true,'type','outer');
BAIL=join(BAIL,dataset(Value_add(:,1),Value_add(:,3),'VarNames',{'date',code}),...
    'keys','date','mergekeys',true,'type','outer');
POSITION=join(POSITION,dataset(Value_add(:,1),positions,'VarNames',...
    {'date',code}), 'keys','date','mergekeys',true,'type','outer');
