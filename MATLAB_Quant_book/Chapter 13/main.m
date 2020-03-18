function [M, T, value_portfolio] = main(volatility_smoothing, sys1_open, sys1_close, sys2_open, sys2_close, period)
%%
summary = {'code', 'start time', 'end time', 'annualized rate of return',...
    '# of transactions of rule 1', 'trading interval', 'odds', ...
    '# of transactions of rule 2', 'trading interval', 'odds', ...
    'volatility', 'sharpe ratio', 'holding period'};

metrics = {'code', 'start time', 'end time', 'volatility', 'sharpe ratio', 'holding period'};
data_path = 'C:\Users\tsunh\Documents\GitHub\MATLAB-Quantitative-Finance\MATLAB_Quant_book\Chapter 13\data\';
filename = [data_path,'currency_list.csv'];
currency_list = readtable(filename);

%% 
% consider all currency
for i=1:height(currency_list)
    code = char(currency_list{i,1});
    init_money = 10000000; %USD
    level = 1000;
    min_bail_rate = 10;
%     period = 4700;
%     volatility_smoothing = 20;
%     sys1_open = 20;
%     sys1_close = 10;
%     sys2_open = 55;
%     sys2_close = 20;
    [value_add, summary_add, positions, Dat, Dat2]=FX_turtle_trading(...
        code, init_money, level, min_bail_rate, period, volatility_smoothing, sys1_open, sys1_close, sys2_open, sys2_close);
    summary = [summary; summary_add];
    metrics = [metrics; summary_add([1,2,3,11,12,13])];
    
    if i==1
        VALUE = mat2dataset(value_add(:,[1,3]), 'VarNames', {'date', code}); %value_add=[Dat.date, daily_return, net_profit, true_bail];
        RETURN = mat2dataset(value_add(:,[1,2]), 'VarNames', {'date', code});
        position = dataset(value_add(:,1), positions, 'VarNames', {'date', code});
    else
        VALUE = join(VALUE, mat2dataset(value_add(:,[1,3]), 'VarNames',{'date', code}),...
            'keys','date','mergekeys',true,'type','outer');
        RETURN = join(RETURN, mat2dataset(value_add(:,[1,2]), 'VarNames',{'date', code}),...
            'keys','date','mergekeys',true,'type','outer');
        position = join(position, dataset(value_add(:,1), positions, 'VarNames',{'date', code}), ...
            'keys', 'date', 'mergekeys', true, 'type', 'outer');
    end
end
%%
% fill in na value
for col=2:size(VALUE,2)
    if isnan(double(VALUE(1,col)))
        VALUE{1,col} = 0;
    end
    if isnan(double(RETURN(1,col)))
        RETURN{1,col} = 0;
    end
    
    for daynumber=2:size(VALUE,1)
        if isnan(double(VALUE(daynumber,col)))
            VALUE(daynumber,col) = VALUE(daynumber-1,col);
        end
    end
    for daynumber=2:size(RETURN,1)
        if isnan(double(RETURN(daynumber,col)))
            RETURN(daynumber,col) = RETURN(daynumber-1,col);
        end
    end
end
%% performance metrics (portfolio)
value_portfolio = mat2dataset([VALUE.date,sum(double(VALUE(:,2:end)),2)],'VarNames',{'date','value'});
position_portfolio = mat2dataset([position.date, nansum(double(position(:,2:end)),2)],'VarNames',{'date','position'});

% daily_return_portfolio = sum(double(RETURN(:,2:end)),2);
daily_return_portfolio = value_portfolio.value;
% daily_return_portfolio(isinf(daily_return_portfolio)|isnan(daily_return_portfolio)) = 0;
volatility_portfolio = std(daily_return_portfolio);
sr_portfolio = mean(daily_return_portfolio) / std(daily_return_portfolio) * sqrt(250);
holding_period_portfolio = mean(cell2mat(metrics(2:end,6)));

output = sprintf('volatility_portfolio: %f, sr: %f, holding period: %f',volatility_portfolio, sr_portfolio, holding_period_portfolio);
metrics_output = [metrics(1,:); {'Portfolio', datestr(value_portfolio.date(1)), datestr(value_portfolio.date(end)),...
    volatility_portfolio, sr_portfolio, holding_period_portfolio}; metrics(2:end,:)];

%% ploting 
fig = plot_pnl(init_money, VALUE, value_portfolio, volatility_smoothing, sys1_open, sys1_close, sys2_open, sys2_close, period, currency_list);
%% save results
T = cell2table(summary(2:end,:),'VariableNames',{'code', 'start_time', 'end_time',...
    'annualized_rate_of_return',  'n_of_transacqtions_of_rule_1', 'trading_interval_1', 'odds_1', ...
    'n_of_transactions_of_rule_2', 'trading_interval_2', 'odds_2', 'volatility', 'sharpe_ratio', 'holding_period'});

M = cell2table(metrics_output(2:end,:),'VariableNames',{'code', 'start_time', 'end_time', 'volatility', ...
    'sharpe_ratio', 'holding_period'});

output_name = sprintf('results\\20200318\\metrics\\metrics_%d_%d_%d_%d_%d_%d.csv',...
    volatility_smoothing, sys1_open, sys1_close, sys2_open, sys2_close, period);
writetable(M, [data_path,output_name]);

output_name = sprintf('results\\20200318\\summary\\summary_%d_%d_%d_%d_%d_%d.csv',...
    volatility_smoothing, sys1_open, sys1_close, sys2_open, sys2_close, period);
writetable(T , [data_path,output_name]);