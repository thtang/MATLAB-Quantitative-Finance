function p=predict(theta, X)
[m, n] = size(X);
X = [ones(m, 1) X];
p=round(sigmoid(X*theta)); %小于0.5则归类为0，大于等于0则为1

