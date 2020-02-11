mu1 = [2 2];
SIGMA1 = [1 0; 0 1];
r1 = mvnrnd(mu1,SIGMA1,100);
mu2 = [-2 -2];
SIGMA2 = [ 1 0; 0 1];
r2 = mvnrnd(mu2,SIGMA2,100);
X=[r1;r2];
[idx,C] = kmeans(X,2);
x1 = min(X(:,1)):0.01:max(X(:,1));
x2 = min(X(:,2)):0.01:max(X(:,2));
[x1G,x2G] = meshgrid(x1,x2);
XGrid = [x1G(:),x2G(:)];
idxRegion = kmeans(XGrid,2,'MaxIter',1,'Start',C);  %利用当前形心计算XGrid所在分组
gscatter(XGrid(:,1),XGrid(:,2),idxRegion,[0,0.75,0.75;0.75,0,0.75],'..');
hold on
plot(r1(:,1),r1(:,2),'k+');
plot(r2(:,1),r2(:,2),'k*')
