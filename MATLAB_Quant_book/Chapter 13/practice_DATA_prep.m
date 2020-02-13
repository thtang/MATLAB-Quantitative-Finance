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