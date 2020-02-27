function [Dat, exchange_rate]=FX_DATA_prep(code, period)

% m = readtable('/AUD_USD Historical Data.csv');
filename = ['C:\Users\tsunh\Desktop\Quant\MATLAB_Finance_quant\Chapter 13\data\',code,'.csv'];
raw_data = readtable(filename);

exchange_rate = raw_data{[end-period,end],2};

date_col = datenum(table2array(raw_data(end-period:end,1)));
price_col = table2array(raw_data(end-period:end,[3,4,5]));
MAT = cat(2, date_col, price_col);

ATR=[max([MAT(2:end,2)-MAT(2:end,3),MAT(2:end,2)-MAT(1:end-1,4), MAT(1:end-1,4)-MAT(2:end,3)],[],2)];
N=movavg(double(ATR),20,20,0);
Dat=dataset(MAT(2:end,1),MAT(2:end,2),MAT(2:end,3),MAT(2:end,4),ATR,N,...
    'VarNames',{'date','HIGH','LOW','CLOSE','ATR','N'});

Dat.signal_1=zeros(size(Dat.date)); 
Dat.signal_2=zeros(size(Dat.date)); 
Dat.quit_1=zeros(size(Dat.date));
Dat.quit_2=zeros(size(Dat.date));

for daynumber=56:size(Dat,1)  
    Dat.signal_1(daynumber)=(Dat.CLOSE(daynumber)>...
        max(Dat.HIGH(daynumber-20:daynumber-1)))-...
        (Dat.CLOSE(daynumber)<min(Dat.LOW(daynumber-20:daynumber-1)));

    Dat.quit_1(daynumber)=-(Dat.CLOSE(daynumber)<...
        min(Dat.LOW(daynumber-10:daynumber-1)))+...
        (Dat.CLOSE(daynumber)>max(Dat.HIGH(daynumber-10:daynumber-1)));

    Dat.signal_2(daynumber)=(Dat.CLOSE(daynumber)>...
        max(Dat.HIGH(daynumber-55:daynumber-1)))-...
        (Dat.CLOSE(daynumber)<min(Dat.LOW(daynumber-55:daynumber-1)));

    Dat.quit_2(daynumber)=-(Dat.CLOSE(daynumber)<...
        min(Dat.LOW(daynumber-20:daynumber-1)))+...
        (Dat.CLOSE(daynumber)>max(Dat.HIGH(daynumber-20:daynumber-1)));
end
Dat(1:55,:)=[];