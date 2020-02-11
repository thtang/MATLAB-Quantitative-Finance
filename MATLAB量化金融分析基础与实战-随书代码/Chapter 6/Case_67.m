%% 建立投资组合
m=[0.0132; 0.0155];
C=[ 0.0024, 0.0008; 0.0008, 0.0014];
r0=2.5/1000;
p=Portfolio('RiskFreeRate',r0,'AssetMean',m,'AssetCovar',...
	C,'LowerBound',zeros(size(m)),'LowerBudget',1,'UpperBudget',1);
%% 找到夏普比率最高的组合点
swgt = estimateMaxSharpeRatio(p)
%% 算出方差srsk和收益sret
[srsk, sret] = estimatePortMoments(p, swgt);
%% 建立第二个投资组合q
q=setBudget(p,0,1.5);
%% 画出有效边界
plotFrontier(p);
hold on
plotFrontier(q);
plot(srsk,sret,'o','markersize',15)
axis([0.034 0.038 0.0148 .0156])