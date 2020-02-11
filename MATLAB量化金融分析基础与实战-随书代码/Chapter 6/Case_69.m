pMAD = PortfolioMAD('Scenarios', Rets_simu, ...
	'LowerBound', 0, 'LowerBudget', 1, 'UpperBudget', 1);

pcwgt = estimateFrontier(pMAD, 20);
[pcrsk, pcret] = estimatePortMoments(p, pcwgt);
pwgt = estimateFrontier(p, 20);
[prsk, pret] = estimatePortMoments(p, pwgt);
portfolioexamples_plot('��Ч�߽�Ա�',{'line', prsk, pret}, {'scatter', pcrsk, pcret,[],'rd'})



