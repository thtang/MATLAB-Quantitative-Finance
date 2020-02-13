%% 不可用
A = [1,1;2,2];
parfor i = 1:2
	for j = 0:1
		A(i, j + 1) = i + j;
	end
end

%% 可用
A = [1,1;2,2];
parfor i = 1:2
	for j = 1:2
		A(i, j) = i + j - 1;
	end
end