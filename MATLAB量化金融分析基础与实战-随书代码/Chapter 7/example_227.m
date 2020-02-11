%% 生成-1类点
r1 = sqrt(rand(1000,1)); 
t1 = 2*pi*rand(1000,1); 
D1 = [r1.*cos(t1), r1.*sin(t1)]; 
%% 生成1类点
r2 = 1 + sqrt(rand(1000,1)); 
t2 = 2*pi*rand(1000,1);  
D2 = [r2.*cos(t2), r2.*sin(t2)]; 
D3 = [D1;D2];
class = ones(2000,1);
class(1:1000) = -1;
%% 训练SVM分类模型
mdl = fitcsvm(D3,class,'KernelFunction','rbf','BoxConstraint',Inf,'ClassNames',[-1,1]);
[x1Grid,x2Grid] = meshgrid(min(D3(:,1)): 0.01:max(D3(:,1)),min(D3(:,2)): 0.01:max(D3(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];
[~,scores] = predict(mdl,xGrid);
%% 画出数据与决策边界
figure;
h(1:2) = gscatter(D3(:,1),D3(:,2),class,'rg','+.');
hold on
ezpolar(@(x)1);
h(3) = plot(D3(mdl.IsSupportVector,1),D3(mdl.IsSupportVector,2),'ko');
contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k');
legend(h,{'外圈','内圈','支持向量'});
axis equal
