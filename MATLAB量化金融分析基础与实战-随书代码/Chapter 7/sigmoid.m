function g = sigmoid(z)
g = ones(size(z));
g=1./(1+exp(-z));
