function p=predict(theta, X)
[m, n] = size(X);
X = [ones(m, 1) X];
p=round(sigmoid(X*theta)); %С��0.5�����Ϊ0�����ڵ���0��Ϊ1

