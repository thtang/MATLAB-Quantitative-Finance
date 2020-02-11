%% 模型
mu1 = [2 2];
SIGMA1 = [1 0; 0 1];
r1 = mvnrnd(mu1,SIGMA1,100);
mu2 = [-2 -2];
SIGMA2 = [ 1 0; 0 1];
r2 = mvnrnd(mu2,SIGMA2,100);
X=[r1;r2];
y=[zeros(100,1);ones(100,1)];
mdl = fitcknn (X,y);

%% 查看预测结果
disp(norm(predict(mdl,X)-y))