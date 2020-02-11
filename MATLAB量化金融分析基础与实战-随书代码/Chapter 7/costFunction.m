function [J grad]=costFunction(theta, X, y)
J=sum(-y.*log(sigmoid(X*theta))-(1-y).*log(1-sigmoid(X*theta)))/length(y);
grad=(((sigmoid(X*theta))-y)'*X)'/length(y);
