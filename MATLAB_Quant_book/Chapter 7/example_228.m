%% 模型
mu=[0,0];
sigma=[1,0.8;0.8,1];
r= mvnrnd(mu,sigma,10000);
[coeff,score,latent,tsquared,explained,mu] = pca(r);
figure
plot(r(:,1),r(:,2),'k.');
hold on
quiver(0,0,5*coeff(1,1),5*coeff(2,1),'b-')
quiver(0,0,3*coeff(1,2),3*coeff(2,2),'r--')
axis equal
legend('数据','Z_1轴',' Z_2轴','location','best')
%% 查看坐标变换系数
disp(coeff)
%% 查看方差解释比例
disp(explained)