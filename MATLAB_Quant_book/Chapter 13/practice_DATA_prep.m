code = 'IF0';
if any(strcmp(code,{'IF0','IC0','IH0'}))
    DT=urlread(strcat('http://stock2.finance.sina.com.cn/futures/api/',...
        'json.php/CffexFuturesService.getCffexFuturesDailyKLine?symbol=',code));
else
    DT=urlread(strcat('http://stock2.finance.sina.com.cn/futures/api/',...
        'json.php/IndexService.getInnerFuturesDailyKLine?symbol=',code));
end

Records=regexp(DT,'\[{1}[^\[]+?\]','match'); 

DATA=cellfun(@(x) regexp(x,'"(?<mytokens>.*?)"','tokens'),Records,'UniformOutput',false);

MAT=cell2mat(cellfun(@(x)[datenum(x{1},'yyyy-mm-dd'),str2num(x{3}{1}),...
    str2num(x{4}{1}),str2num(x{5}{1})],DATA','UniformOutput',false));
MAT(any(MAT==0,2),:)=[];
MAT=sortrows(MAT,+1);

ATR=[max([MAT(2:end,2)-MAT(2:end,3),MAT(2:end,2)-MAT(1:end-1,4),...
    MAT(1:end-1,4)-MAT(2:end,3)],[],2)];

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

%%
% m = readtable('/AUD_USD Historical Data.csv');
filename = 'C:\Users\tsunh\Desktop\Quant\MATLAB_Finance_quant\Chapter 13\data\AUD_USD Historical Data.csv';
raw_data = readtable(filename);

date_col = datenum(table2array(raw_data(:,1)));
price_col = table2array(raw_data(:,[2,3,4]));
MAT = cat(2, date_col, price_col);
ATR=[max([MAT(2:end,2)-MAT(2:end,3),MAT(2:end,2)-MAT(1:end-1,4), MAT(1:end-1,4)-MAT(2:end,3)],[],2)];
N=movavg(double(ATR),20,20,0);
Dat=dataset(MAT(2:end,1),MAT(2:end,2),MAT(2:end,3),MAT(2:end,4),ATR,N,...
    'VarNames',{'date','HIGH','LOW','CLOSE','ATR','N'});