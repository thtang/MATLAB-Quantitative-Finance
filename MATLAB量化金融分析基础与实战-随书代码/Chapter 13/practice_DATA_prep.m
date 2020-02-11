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
