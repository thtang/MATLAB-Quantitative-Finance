summary = {'code', 'start time', 'end time', 'annualized rate of return',...
    '# of transactions of rule 1', 'trading interval', 'odds', ...
    '# of transactions of rule 2', 'trading interval', 'odds'};

filename = 'C:\Users\tsunh\Desktop\Quant\MATLAB_Finance_quant\Chapter 13\data\currency_list.csv';
currency_list = readtable(filename);
for i=1:height(currency_list)
    code = char(currency_list{i,1});
    init_money = 10000000;
    level = 10;
    min_bail_rate = 10;

    [value_add, summary_add, positions, Dat, Dat2]=FX_turtle_trading(...
        code, init_money, level, min_bail_rate);
    summary = [summary; summary_add];
end

%% save results
T = cell2table(summary(2:end,:),'VariableNames',{'code', 'start_time', 'end_time',...
    'annualized_rate_of_return',  'n_of_transactions_of_rule_1', 'trading_interval_1', 'odds_1', ...
    'n_of_transactions_of_rule_2', 'trading_interval_2', 'odds_2'});
 
% Write the table to a CSV file
writetable(T,'C:\Users\tsunh\Desktop\Quant\MATLAB_Finance_quant\Chapter 13\data\results.csv')