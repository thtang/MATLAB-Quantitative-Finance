function DST=sina_future_hist_data_get(code)
DT=urlread(strcat('http://stock2.finance.sina.com.cn/futures/api/',...
	'json.php/IndexService.getInnerFuturesDailyKLine?symbol=',code));
Records=regexp(DT,'\[{1}[^\[]+?\]','match');
DATA=cellfun(@(x) regexp(x,'"(?<mytokens>.*?)"','tokens'),Records,'UniformOutput',false);
MAT=cell2mat(cellfun(@(x)[datenum(x{1},'yyyy-mm-dd'),str2num(x{5}{1})],DATA',...
	'UniformOutput',false));
DST=mat2dataset(sortrows(MAT,+1),'VarNames',{'DATE',strcat(code,'_CLOSE_PRICE')});
DST(double(DST(:,2))==0,:)=[];
