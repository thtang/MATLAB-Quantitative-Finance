%% 不可用
A = [1,1;2,2];

parfor i = 1:size(A, 1)
	for j = 1:size(A, 2)
		A(i, j) = i*2+j;
	end
end
%% 可用
A = [1,1;2,2];
n = size(A, 2);
parfor i = 1:size(A, 1)
	for j = 1:n
		A(i, j) = i*2+j;
	end
end

