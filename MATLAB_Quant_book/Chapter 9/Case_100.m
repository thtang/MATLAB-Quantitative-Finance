%% 不可用
A = [1,2,3];
B = @cos;
parfor i = 1:3
	A(i) = B(i);
end
%% 可用
A = [1,2,3];
B = @cos;
parfor i = 1:3
	A(i) = feval(B,i);
end