%% ������
A = [1,2,3];
B = @cos;
parfor i = 1:3
	A(i) = B(i);
end
%% ����
A = [1,2,3];
B = @cos;
parfor i = 1:3
	A(i) = feval(B,i);
end