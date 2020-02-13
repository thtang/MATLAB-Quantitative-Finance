%% ģ��
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
legend('����','Z_1��',' Z_2��','location','best')
%% �鿴����任ϵ��
disp(coeff)
%% �鿴������ͱ���
disp(explained)