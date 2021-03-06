function [Value_add,summary,positions,Dat,Dat2]=turtle_trading(...
    code,init_money,level,min_bail_rate)
% Value_add  三列依次为时间、资产增加值和保证金;
% summary 依次为 代码、交易数据开始时间、交易数据结束时间、
%           年化收益率、法则一交易次数、平均开仓等待时间、胜率和 
%           法则二的交易次数、平均开仓等待时间、胜率
% positions为触发开仓的法则数,最小为0,最大为2,且不区分方向
% Dat 为法则一交易明细
% Dat2 为法则二交易明细
% init_money 为初始名义资产
% level为每手重量
% min_bail_rate为保证金比例
%% 法则一计算
Dat_raw=DATA_prep(code);
Dat=Dat_raw;
% 生成交易状态列 
%多头开仓 持仓 平仓对应 1 2 3
%空头开仓 持仓 平仓对应 4 5 6
Dat.status=zeros(size(Dat.date));
% 生成交易开盘价列
Dat.open_price=zeros(size(Dat.date));
% 生成用于计算收益率的交易头寸方向价列
% 持或平多仓的日期为+1,持或平空仓的日期为-1
Dat.position=zeros(size(Dat.date));
% 生成止损价格序列
Dat.stop_price=zeros(size(Dat.date));
% 生成前日收盘价序列
Dat.preclose=zeros(size(Dat.date));
% 生成当日收益点数序列
Dat.gain=zeros(size(Dat.date));
% 在交易结束日期时生成当前信号累计收益点数序列
Dat.gain_of_trade=zeros(size(Dat.date));
% 生成上次交易盈亏额序列
Dat.last_gain_of_trade=zeros(size(Dat.date));
last_gain_of_trade=0;
for daynumber=2:size(Dat,1)
    Dat.preclose(daynumber)=Dat.CLOSE(daynumber-1);
    % 提取多头交易状态、开仓价和止损价
    if Dat.status(daynumber-1)==1 ||  Dat.status(daynumber-1)==2
        Dat.status(daynumber)=2;
        Dat.open_price(daynumber)=Dat.open_price(daynumber-1);
        Dat.stop_price(daynumber)=Dat.stop_price(daynumber-1);
    end
    % 提取空头交易状态、开仓价和止损价
    if Dat.status(daynumber-1)==4 ||  Dat.status(daynumber-1)==5
        Dat.status(daynumber)=5;
        Dat.open_price(daynumber)=Dat.open_price(daynumber-1);
        Dat.stop_price(daynumber)=Dat.stop_price(daynumber-1);
    end
    % 由交易信号计算交易信息,开多
    if Dat.signal_1(daynumber)==1 && Dat.status(daynumber-1)==0
        Dat.status(daynumber)=1;
        Dat.open_price(daynumber)=Dat.CLOSE(daynumber);
        Dat.stop_price(daynumber)=Dat.CLOSE(daynumber)-2*Dat.N(daynumber);
    end
    % 由交易信号计算交易信息,开空
    if Dat.signal_1(daynumber)==-1 && Dat.status(daynumber-1)==0
        Dat.status(daynumber)=4;
        Dat.open_price(daynumber)=Dat.CLOSE(daynumber);
        Dat.stop_price(daynumber)=Dat.CLOSE(daynumber)+2*Dat.N(daynumber);
    end
    % 由交易信号计算交易信息,平多
    if Dat.quit_1(daynumber)==-1 && ...
            ( Dat.status(daynumber-1)==1 || Dat.status(daynumber-1)==2)
        Dat.status(daynumber)=3;
    end
    % 由交易信号计算交易信息,平空
    if Dat.quit_1(daynumber)==1 && ...
            ( Dat.status(daynumber-1)==4 || Dat.status(daynumber-1)==5)
        Dat.status(daynumber)=6;
    end
    % 计算仓位方向    
    if Dat.status(daynumber)==5 || Dat.status(daynumber)==6
        Dat.position(daynumber)=-1;
    end
    % 计算仓位方向
    if Dat.status(daynumber)==2 || Dat.status(daynumber)==3
        Dat.position(daynumber)=1;
    end
    % 多头止损
    if Dat.position(daynumber)==1 && Dat.CLOSE(daynumber)<...
            Dat.stop_price(daynumber)
        Dat.status(daynumber)=3;
    end
    % 空头止损
    if Dat.position(daynumber)==-1 && Dat.CLOSE(daynumber)>...
            Dat.stop_price(daynumber)
        Dat.status(daynumber)=6;
    end
    % 计算多头收益
    if Dat.status(daynumber)==2 || Dat.status(daynumber)==3
        Dat.gain(daynumber)=Dat.CLOSE(daynumber)-Dat.preclose(daynumber);
    end
    % 计算空头收益
    if Dat.status(daynumber)==5 || Dat.status(daynumber)==6
        Dat.gain(daynumber)=-Dat.CLOSE(daynumber)+Dat.preclose(daynumber);
    end
    % 提取上笔交易收益额
    if Dat.position(daynumber)==1 || Dat.position(daynumber)==-1 ...
            || Dat.status(daynumber)==1 || Dat.status(daynumber)==4
        Dat.last_gain_of_trade(daynumber)=last_gain_of_trade;
    end
    % 记录当笔多头交易收益额，即为循环中下笔交易的上笔收益额
    if Dat.status(daynumber)==3
        Dat.gain_of_trade(daynumber)=Dat.CLOSE(daynumber)...
            -Dat.open_price(daynumber);
        last_gain_of_trade=Dat.gain_of_trade(daynumber);
    end
    % 记录当笔空头交易收益额，即为循环中下笔交易的上笔收益额
    if Dat.status(daynumber)==6
        Dat.gain_of_trade(daynumber)=-Dat.CLOSE(daynumber)...
            +Dat.open_price(daynumber);
        last_gain_of_trade=Dat.gain_of_trade(daynumber);
    end
end
% 法则一按照上笔交易盈亏额进行信号过滤
Dat.gain_after_adj=Dat.gain;
Dat.status_adj=Dat.status;
Dat.gain_after_adj(Dat.last_gain_of_trade>0)=0;
Dat.status_adj(Dat.last_gain_of_trade>0)=0;

%% 法则二计算
% 无需信号过滤部分,其他变量和变量中的成员释义均同法则一
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
%% 收益计算
% 法则一手数
Dat.num_of_position=zeros(size(Dat.date));
% 法则二手数
Dat2.num_of_position=zeros(size(Dat.date));
% 资产序列
value=init_money*ones(size(Dat.date));
if Dat.status_adj(1)==1
    Dat.num_of_position(1)=value(1)/Dat.N(1)/level*0.01;
end
if Dat2.status(1)==1
    Dat2.num_of_position(1)=value(1)/Dat2.N(1)/level*0.01;
end

for daynumber=2:size(Dat,1)
    value(daynumber)=value(daynumber-1);
    % 如果法则一有持仓需计算资产变化
    if Dat.status(daynumber)==2 || Dat.status(daynumber)==3 ...
            || Dat.status(daynumber)==5 || Dat.status(daynumber)==6
        Dat.num_of_position(daynumber)=Dat.num_of_position(daynumber-1);
        value(daynumber)=value(daynumber)+Dat.num_of_position(daynumber)...
            *Dat.gain_after_adj(daynumber)*level;
    end
    % 如果法则二有持仓需计算资产变化    
    if Dat2.status(daynumber)==2 || Dat2.status(daynumber)==3 ...
            || Dat2.status(daynumber)==5 || Dat2.status(daynumber)==6
        Dat2.num_of_position(daynumber)=Dat2.num_of_position(daynumber-1);
        value(daynumber)=value(daynumber)+Dat2.num_of_position(daynumber)...
            *Dat2.gain(daynumber)*level;
    end
    % 如果法则一新开仓需计算手数
    if Dat.status(daynumber)==1 || Dat.status(daynumber)==4
        Dat.num_of_position(daynumber)=floor(value(daynumber)/...
            Dat.N(daynumber)/level*0.01);
    end
    % 如果法则二新开仓需计算手数    
    if Dat2.status(daynumber)==1 || Dat2.status(daynumber)==4
        Dat2.num_of_position(daynumber)=floor(value(daynumber)/...
            Dat2.N(daynumber)/level*0.01);
    end
end
% 分别计算两个法则的保证金数额
Dat.bail=Dat.num_of_position.*Dat.CLOSE.*min_bail_rate/100*level;
Dat2.bail=Dat2.num_of_position.*Dat2.CLOSE.*min_bail_rate/100*level;
% 计算策略特征
yr_rate=(exp(log(value(end)/value(1))/(length(value)/250))-1)*100;
sys_1_no=sum(Dat.status==3)+ sum(Dat.status==6);
sys_2_no=sum(Dat2.status==3)+ sum(Dat2.status==6);
summary=[{code},... %代码
    {datestr(Dat.date(1)),datestr(Dat.date(end))},... %交易数据起止时间
    {yr_rate},... %年化收益率 格式 X.XX%
    {sys_1_no},... %法则一交易次数
    {size(Dat,1)/sys_1_no},... %法则一平均开仓等待时间
    {sum(Dat.gain_of_trade>0)/sys_1_no*100},... %法则一胜率 格式 X.XX%
    {sys_2_no},... %法则二交易次数 
    {size(Dat,1)/sys_2_no},... %法则二平均开仓等待时间
    {sum(Dat2.gain_of_trade>0)/sys_2_no*100}];%法则二胜率 格式 X.XX%
%% 按照实际资产调整头寸
bails=Dat.bail+Dat2.bail;
true_value=value;
true_bail=bails;
for daynumber=1:size(value,1)-1
    %实际保证金应当等于实际资产与需要保证金的较小者
    true_bail(daynumber)=min(true_value(daynumber),bails(daynumber));
    if bails(daynumber)==0
        continue;
    end
    true_value(daynumber+1)=true_value(daynumber)+...
        (value(daynumber+1)-value(daynumber))...
        *true_bail(daynumber)/bails(daynumber);
end
true_bail(end)=min(true_value(end),bails(end));
% 输出变量三列依次为时间、资产增加值和实际保证金
Value_add=[Dat.date,true_value-init_money,true_bail];
% 计算触发的法则个数
positions=(Dat.num_of_position>0)+(Dat2.num_of_position>0);
