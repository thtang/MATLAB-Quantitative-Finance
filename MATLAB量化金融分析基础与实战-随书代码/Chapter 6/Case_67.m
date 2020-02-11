%% ����Ͷ�����
m=[0.0132; 0.0155];
C=[ 0.0024, 0.0008; 0.0008, 0.0014];
r0=2.5/1000;
p=Portfolio('RiskFreeRate',r0,'AssetMean',m,'AssetCovar',...
	C,'LowerBound',zeros(size(m)),'LowerBudget',1,'UpperBudget',1);
%% �ҵ����ձ�����ߵ���ϵ�
swgt = estimateMaxSharpeRatio(p)
%% �������srsk������sret
[srsk, sret] = estimatePortMoments(p, swgt);
%% �����ڶ���Ͷ�����q
q=setBudget(p,0,1.5);
%% ������Ч�߽�
plotFrontier(p);
hold on
plotFrontier(q);
plot(srsk,sret,'o','markersize',15)
axis([0.034 0.038 0.0148 .0156])