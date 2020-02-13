%%¡¡Ä£ÐÍ
load Data_GlobalIdx1
Returns=tick2ret(table2array(DataTable));
n=size(Returns, 2);
eR=mean(Returns);
sigma=std(Returns);
correlation = corrcoef(Returns);
F = @(t,X) diag(eR)*X;
G = @(t,X) diag(X)*diag(sigma);
SDE = sde(F, G, 'Correlation', correlation, 'StartState', ones(n,1));
%% Ä£Äâ
dt=1;
[S,T] = simulate(SDE, 200, 'DeltaTime', dt);
style= {'-','>','x','*','+','o'};
hold on
for k= 1:size(S,2)
	plot(T(1:2:end),S(1:2:end,k),style{k})
end
xlabel('Trading Day'), 
ylabel('Price')
legend(DataTable.Properties.VariableNames,'location','best')