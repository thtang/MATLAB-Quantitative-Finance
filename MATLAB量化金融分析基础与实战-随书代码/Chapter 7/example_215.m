%% ��ͼ
x1=(1:16)';
x2=ones(16,1);
x2(2:2:end)=-1;
x3= ones(16,1);
X = [x1+randn(16,1)*0.1 x2+randn(16,1)*0.1 x3+randn(16,1)*0.1];
y=4*x1+x2+randn(16,1)*0.1;
Xone=[ones(16,1),X];
%% �����ϵ��ͼ
corrplot(X,'testR','on')
%% ����VIF
R=corrcoef(X);
VIF = diag(inv(R))'
%% Belsley���
collintest(X);
%% ����ع�
Mu = mean(diag(Xone'*Xone));
k = 0:Mu;
betas = ridge(y,X,k,0);  % ���һ������ȡ0��ʾ���������ȡ1�����������
figure
style={'x','+','-'};
hold on
for j= 2:size(betas,1)
	plot(k(1:20:end), betas(j,1:20:end),style{j-1},'LineWidth',2.5)
end
xlim([0 Mu])
legend({'var1','var2','var3'})
xlabel('lambda')
ylabel('��ع����')
title('{\bf �뼣}')
axis tight
grid on
%% ������ع��MSE
[numParams,numBetas] = size(betas);
yHat = Xone*betas;
RidgeRes = repmat(y,1,numBetas)-yHat;
RidgeSSE = RidgeRes'*RidgeRes;
RidgeDFE = 16-numParams;
RidgeMSE = diag(RidgeSSE/RidgeDFE);
figure
plot(k,RidgeMSE,'m','LineWidth',2.5)
xlim([0 Mu])
xlabel('lambda')
ylabel('MSE')
title('{\bf �� MSE}')
axis tight
grid on
