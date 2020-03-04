function fig = plot_pnl(init_money, value, value_portfolio, volatility_smoothing, sys1_open, sys1_close, sys2_open, sys2_close, period, currency_list)
fig =  figure;
x = dataset2cell(value(:,2:end));
legend_dollar = x(1,:);
lines = cell2mat(x(2:end,:))./init_money +1;
pnl_portfolio = value_portfolio.value/(init_money*size(currency_list,1))+1;
% lines = [lines,pnl_portfolio];
set(gca,'linestyleorder',{'-',':','-.','--'},...
'nextplot','add')

plot(value.date,pnl_portfolio,'LineWidth',2);
hold on
plot(value.date, lines);
hold off
legend(['Portfolio', legend_dollar],'FontSize',7, 'Location','northwest');
datetick('x', 'yyyy-mm-dd', 'keeplimits');
xlim([value_portfolio.date(1) value_portfolio.date(end)])
ax = gca;
ax.ColorOrder = [1 0.5 0; 0.5 0 1; 0 0.5 0.3];
ax.LineStyleOrder = {'-','--',':'};
set(gcf, 'Position',  [100, 100, 1200, 600])

data_path = 'C:\Users\tsunh\Documents\GitHub\MATLAB-Quantitative-Finance\MATLAB_Quant_book\Chapter 13\data\';
output_name = sprintf('figures\\pnl_20200304_%d_%d_%d_%d_%d_%d.png',...
    volatility_smoothing, sys1_open, sys1_close, sys2_open, sys2_close, period);
saveas(ax, [data_path,output_name]);
% fig.PaperPositionMode = 'auto';
% print(fig, [data_path,'figures\pnl'],'-dpng','-bestfit','BestFitFigure')
