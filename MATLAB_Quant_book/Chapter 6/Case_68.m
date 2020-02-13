%% 建立投资组合
Rets_simu = mvnrnd(m, C, 20000);
pCVaR = PortfolioCVaR('Scenarios', Rets_simu, ...
	'LowerBound', 0, 'LowerBudget', 1, 'UpperBudget', 1, 'ProbabilityLevel', 0.95);
%% 找到有效边界上资产配置权重
pcwgt = estimateFrontier(pCVaR, 20);
%% 计算有效边界在均值方差模型下的标准差与收益
[pcrsk, pcret] = estimatePortMoments(p, pcwgt);
%% 计算出均值方差模型的有效边界
pwgt = estimateFrontier(p, 20);
[prsk, pret] = estimatePortMoments(p, pwgt);
%% 画图对比两个模型有效边界
 portfolioexamples_plot('有效边界对比',{'line', prsk, pret}, {'scatter', pcrsk, pcret,[],'rd'})