%% ����Ͷ�����
Rets_simu = mvnrnd(m, C, 20000);
pCVaR = PortfolioCVaR('Scenarios', Rets_simu, ...
	'LowerBound', 0, 'LowerBudget', 1, 'UpperBudget', 1, 'ProbabilityLevel', 0.95);
%% �ҵ���Ч�߽����ʲ�����Ȩ��
pcwgt = estimateFrontier(pCVaR, 20);
%% ������Ч�߽��ھ�ֵ����ģ���µı�׼��������
[pcrsk, pcret] = estimatePortMoments(p, pcwgt);
%% �������ֵ����ģ�͵���Ч�߽�
pwgt = estimateFrontier(p, 20);
[prsk, pret] = estimatePortMoments(p, pwgt);
%% ��ͼ�Ա�����ģ����Ч�߽�
 portfolioexamples_plot('��Ч�߽�Ա�',{'line', prsk, pret}, {'scatter', pcrsk, pcret,[],'rd'})