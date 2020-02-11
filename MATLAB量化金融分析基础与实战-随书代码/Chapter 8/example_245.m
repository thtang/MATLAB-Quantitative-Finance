load Data_EquityIdx
nasdaq = DataTable.NASDAQ;
nasdaqModel = arima(1,1,1);
nasdaqModel.Variance=gjr(1,1); %方差符合gjr(1,1)
FIT = estimate(nasdaqModel,nasdaq, 'display','off');%不显示模型
[Y,Y_est] = forecast(FIT,1000,'Y0',nasdaq);
lower = Y - 1.96*sqrt(Y_est);
upper = Y + 1.96*sqrt(Y_est);
figure
plot(nasdaq,'Color','g');
hold on
s_pt=length(nasdaq);
h1 = plot(s_pt +1: s_pt +1000,lower,'r:','LineWidth',1.5);
plot(s_pt +1: s_pt +1000,upper,'r:','LineWidth', 1.5)
h2 = plot(s_pt +1: s_pt +1000,Y,'k','LineWidth', 1.5);
legend([h1 h2],'95% 置信区间','预测','Location','NorthWest')
title('NASDAQ 预测')
disp(FIT)
