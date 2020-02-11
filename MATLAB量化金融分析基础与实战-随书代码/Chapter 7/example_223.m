GMModel = fitgmdist(X,2);
figure
y = [zeros(100,1);ones(100,1)];
h = gscatter(X(:,1),X(:,2),y,'br','+*');
hold on
ezcontour(@(x1,x2)pdf(GMModel,[x1 x2]),get(gca,{'XLim','YLim'}))
