%% 不可用
A = [1,1;2,2];
n = size(A, 2);
parfor i = 1:size(A, 1)
	
	for j = 1:n
		A(i, j) = i*2+j;
	end
	disp(A(i,1))

end

%% 可用
A = [1,1;2,2];
n = size(A, 2);
parfor i = 1:size(A, 1)
	v = zeros(1,2);  
		for j = 1:n
			v(j) = i*2+j;
		end
	disp(v(1))
	A(i,:)=v;
end

