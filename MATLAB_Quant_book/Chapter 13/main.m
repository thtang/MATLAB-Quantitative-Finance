summary = {'code', 'start time', 'end time', 'annualized rate of return',...
    '# of transactions of rule 1', 'trading interval', 'odds', ...
    '# of transactions of rule 2', 'trading interval', 'odds', ...
    'volatility', 'sharpe ratio', 'holding period'};

filename = 'C:\Users\thtang\Documents\GitHub\MATLAB-Quantitative-Finance\MATLAB_Quant_book\Chapter 13\data\currency_list.csv';
currency_list = readtable(filename);

code = char(currency_list{17,1});
init_money = 10000000;
level =100000;
min_bail_rate = 10;
period = 804; %2017
[value_add, summary_add, positions, Dat, Dat2]=FX_turtle_trading(...
    code, init_money, level, min_bail_rate, period); %value_add=[Dat.date,true_value-init_money,true_value,true_bail];
% summary = [summary; summary_add];
%%
% PnL curve
figure;
pnl = value_add(:,2)./init_money+1;
plot(Dat.date, pnl);
datetick('x', 'yyyy-mm-dd', 'keepticks');
xlim([Dat.date(1) Dat.date(end)])
ax = gca;
ax.XTickLabelRotation = 45;

%%
plot(Dat.date, pnl, 'linewidth', 2);
%% 
% consider all currency
for i=1:height(currency_list)
    code = char(currency_list{i,1});
    init_money = 10000000;
    level = 1000;
    min_bail_rate = 10;
    period = 804;
    [value_add, summary_add, positions, Dat, Dat2]=FX_turtle_trading(...
        code, init_money, level, min_bail_rate, period);
    summary = [summary; summary_add];
    
    if i==1
        value = mat2dataset(value_add(:,1:2), 'VarNames', {'date',code});
    else
        value = join(value, mat2dataset(value_add(:,1:2), 'VarNames',{'date',code}),...
            'keys','date','mergekeys',true,'type','outer');
    end
end
%%
for col=2:size(value,2)
    if isnan(double(value(1,col)))
        value{1,col}=0;
    end
    for daynumber=2:size(value,1)
        if isnan(double(value(daynumber,col)))
            value(daynumber,col)=value(daynumber-1,col);
        end
    end
end
%%
value_portfolio=mat2dataset([value.date,sum(double(value(:,2:end)),2)],'VarNames',{'date','value'});
%% save results
T = cell2table(summary(2:end,:),'VariableNames',{'code', 'start_time', 'end_time',...
    'annualized_rate_of_return',  'n_of_transacqtions_of_rule_1', 'trading_interval_1', 'odds_1', ...
    'n_of_transactions_of_rule_2', 'trading_interval_2', 'odds_2', 'volatility', 'sharpe_ratio', 'holding_period'});
%% 
% Write the table to a CSV file
writetable(T,'C:\Users\tsunh\Documents\GitHub\MATLAB-Quantitative-Finance\MATLAB_Quant_book\Chapter 13\data\results_20200226_02.csv')