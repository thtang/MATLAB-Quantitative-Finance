function [value_add, summary, positions, Dat, Dat2]=FX_turtle_trading(...
    code, init_money, level, min_bail_rate, period, volatility_smoothing, sys1_open, sys1_close, sys2_open, sys2_close)

Dat_raw = FX_DATA_prep(code, period, volatility_smoothing, sys1_open, sys1_close, sys2_open, sys2_close);

denomination = code(4:6);
if strcmp(denomination, 'USD')==0
    init_money = init_money*Dat_raw.CLOSE(1);
    disp(['init_money:',num2str(init_money),' ',denomination]);
end

Dat=Dat_raw;

Dat.status=zeros(size(Dat.date));

Dat.open_price=zeros(size(Dat.date));

Dat.position=zeros(size(Dat.date));

Dat.stop_price=zeros(size(Dat.date));

Dat.preclose=zeros(size(Dat.date));

Dat.gain=zeros(size(Dat.date));

Dat.gain_of_trade=zeros(size(Dat.date));

Dat.last_gain_of_trade=zeros(size(Dat.date));
last_gain_of_trade=0;

for daynumber=2:size(Dat,1)
    Dat.preclose(daynumber)=Dat.CLOSE(daynumber-1);
    
    if Dat.status(daynumber-1)==1 ||  Dat.status(daynumber-1)==2
        Dat.status(daynumber)=2;
        Dat.open_price(daynumber)=Dat.open_price(daynumber-1);
        Dat.stop_price(daynumber)=Dat.stop_price(daynumber-1);
    end
    
    if Dat.status(daynumber-1)==4 ||  Dat.status(daynumber-1)==5
        Dat.status(daynumber)=5;
        Dat.open_price(daynumber)=Dat.open_price(daynumber-1);
        Dat.stop_price(daynumber)=Dat.stop_price(daynumber-1);
    end
    
    if Dat.signal_1(daynumber)==1 && Dat.status(daynumber-1)==0
        Dat.status(daynumber)=1;
        Dat.open_price(daynumber)=Dat.CLOSE(daynumber);
        Dat.stop_price(daynumber)=Dat.CLOSE(daynumber)-2*Dat.N(daynumber);
    end
    
    if Dat.signal_1(daynumber)==-1 && Dat.status(daynumber-1)==0
        Dat.status(daynumber)=4;
        Dat.open_price(daynumber)=Dat.CLOSE(daynumber);
        Dat.stop_price(daynumber)=Dat.CLOSE(daynumber)+2*Dat.N(daynumber);
    end
    
    if Dat.quit_1(daynumber)==-1 && ...
            ( Dat.status(daynumber-1)==1 || Dat.status(daynumber-1)==2)
        Dat.status(daynumber)=3;
    end
    
    if Dat.quit_1(daynumber)==1 && ...
            ( Dat.status(daynumber-1)==4 || Dat.status(daynumber-1)==5)
        Dat.status(daynumber)=6;
    end
    
    if Dat.status(daynumber)==5 || Dat.status(daynumber)==6
        Dat.position(daynumber)=-1;
    end
    
    if Dat.status(daynumber)==2 || Dat.status(daynumber)==3
        Dat.position(daynumber)=1;
    end
    
    if Dat.position(daynumber)==1 && Dat.CLOSE(daynumber)<...
            Dat.stop_price(daynumber)
        Dat.status(daynumber)=3;
    end
    
    if Dat.position(daynumber)==-1 && Dat.CLOSE(daynumber)>...
            Dat.stop_price(daynumber)
        Dat.status(daynumber)=6;
    end
    
    if Dat.status(daynumber)==2 || Dat.status(daynumber)==3
        Dat.gain(daynumber)=Dat.CLOSE(daynumber)-Dat.preclose(daynumber);
    end
    
    if Dat.status(daynumber)==5 || Dat.status(daynumber)==6
        Dat.gain(daynumber)=-Dat.CLOSE(daynumber)+Dat.preclose(daynumber);
    end
    
    if Dat.position(daynumber)==1 || Dat.position(daynumber)==-1 ...
            || Dat.status(daynumber)==1 || Dat.status(daynumber)==4
        Dat.last_gain_of_trade(daynumber)=last_gain_of_trade;
    end
    
    if Dat.status(daynumber)==3
        Dat.gain_of_trade(daynumber)=Dat.CLOSE(daynumber)...
            -Dat.open_price(daynumber);
        last_gain_of_trade=Dat.gain_of_trade(daynumber);
    end
    
    if Dat.status(daynumber)==6
        Dat.gain_of_trade(daynumber)=-Dat.CLOSE(daynumber)...
            +Dat.open_price(daynumber);
        last_gain_of_trade=Dat.gain_of_trade(daynumber);
    end
end

Dat.gain_after_adj=Dat.gain;
Dat.status_adj=Dat.status;
Dat.gain_after_adj(Dat.last_gain_of_trade>0)=0;
Dat.status_adj(Dat.last_gain_of_trade>0)=0;


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


Dat.num_of_position=zeros(size(Dat.date));

Dat2.num_of_position=zeros(size(Dat.date));

value=init_money*ones(size(Dat.date));
if Dat.status_adj(1)==1
    Dat.num_of_position(1)=value(1)/Dat.N(1)/level*0.01;
end
if Dat2.status(1)==1
    Dat2.num_of_position(1)=value(1)/Dat2.N(1)/level*0.01;
end

for daynumber=2:size(Dat,1)
    value(daynumber)=value(daynumber-1);
    
    if Dat.status(daynumber)==2 || Dat.status(daynumber)==3 ...
            || Dat.status(daynumber)==5 || Dat.status(daynumber)==6
        Dat.num_of_position(daynumber)=Dat.num_of_position(daynumber-1);
        value(daynumber)=value(daynumber)+Dat.num_of_position(daynumber)...
            *Dat.gain_after_adj(daynumber)*level;
    end
        
    if Dat2.status(daynumber)==2 || Dat2.status(daynumber)==3 ...
            || Dat2.status(daynumber)==5 || Dat2.status(daynumber)==6
        Dat2.num_of_position(daynumber)=Dat2.num_of_position(daynumber-1);
        value(daynumber)=value(daynumber)+Dat2.num_of_position(daynumber)...
            *Dat2.gain(daynumber)*level;
    end
   
    if Dat.status(daynumber)==1 || Dat.status(daynumber)==4
        Dat.num_of_position(daynumber)=floor(value(daynumber)/...
            Dat.N(daynumber)/level*0.01);
    end
    
    if Dat2.status(daynumber)==1 || Dat2.status(daynumber)==4
        Dat2.num_of_position(daynumber)=floor(value(daynumber)/...
            Dat2.N(daynumber)/level*0.01);
    end
end

Dat.bail=Dat.num_of_position.*Dat.CLOSE.*min_bail_rate/100*level;
Dat2.bail=Dat2.num_of_position.*Dat2.CLOSE.*min_bail_rate/100*level;

yr_rate=(exp(log(value(end)/value(1))/(length(value)/250))-1)*100;
sys_1_no=sum(Dat.status==3)+ sum(Dat.status==6);
sys_2_no=sum(Dat2.status==3)+ sum(Dat2.status==6);


bails=Dat.bail+Dat2.bail;
true_value=value;
true_bail=bails;
for daynumber=1:size(value,1)-1
    
    true_bail(daynumber)=min(true_value(daynumber),bails(daynumber));
    if bails(daynumber)==0
        continue;
    end
    true_value(daynumber+1)=true_value(daynumber)+...
        (value(daynumber+1)-value(daynumber))...
        *true_bail(daynumber)/bails(daynumber);
end

true_bail(end)=min(true_value(end),bails(end));


daily_return = tick2ret(true_value);

volatility = std(daily_return);
sr = mean(daily_return) / std(daily_return) * sqrt(250);

if strcmp(denomination, 'USD')==0
    value_add=[Dat.date,(true_value-init_money)./Dat_raw.CLOSE,...
        true_value./Dat_raw.CLOSE,true_bail./Dat_raw.CLOSE];
else
    value_add=[Dat.date,true_value-init_money,true_value,true_bail];
end
positions=(Dat.num_of_position>0)+(Dat2.num_of_position>0);
holding_period = sum(abs(positions))/ sum(abs(diff(positions)));
summary=[{code},... 
    {datestr(Dat.date(1)),datestr(Dat.date(end))},... 
    {yr_rate},...
    {sys_1_no},...
    {size(Dat,1)/sys_1_no},... 
    {sum(Dat.gain_of_trade>0)/sys_1_no*100},... 
    {sys_2_no},... 
    {size(Dat,1)/sys_2_no},... 
    {sum(Dat2.gain_of_trade>0)/sys_2_no*100},...
    {volatility},...
    {sr},...
    {holding_period}];