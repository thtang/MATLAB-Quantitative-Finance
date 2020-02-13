%% Ä£ÐÍ
X=(1:1:10)';
y=[zeros(5,1);ones(5,1)];
[m, n]=size(X);
Xs=[ones(m, 1) X];
initial_theta=zeros(n + 1, 1);
opt = optimset('GradObj', 'on', 'MaxIter',400,'Display','off');
[theta, cost]=fminunc(@(t)(costFunction(t, Xs, y)), initial_theta, opt);

%% Ô¤²â
predict(theta,[5.4;5.5])