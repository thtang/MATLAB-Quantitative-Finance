load Data_EquityIdx
r =100*price2ret(DataTable.NASDAQ);
NASDAQ=ret2price(r/100);
Mdl = arima('ARLags',1,'MALags',1);
EstMdl = estimate(Mdl,r);
[e0,v0] = infer(EstMdl,r);
[y,e,v] = simulate (EstMdl,length(r) ,'NumPaths',10000,'Y0',r,'E0',e0,'V0',v0);
Nas_simu= ret2price(y/100);
disp(EstMdl)
figure
plot(prctile(Nas_simu',90),'r--')
hold on
plot(prctile(Nas_simu',10),'g--')
plot(NASDAQ,'k')
legend('模拟90%区间','模拟10%区间','Nasdaq','location','best')
