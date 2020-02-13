%% 不可用
A = [1,1;2,2];
n = size(A, 2);
parfor i = 1:size(A, 1)
   for j = 1
      A(i, j) = i*2+j;
   end
   for j = 2
      A(i, j) = i+j;
   end

end
%% 可用
A = [1,1;2,2];
n = size(A, 2);
parfor i = 1:size(A, 1)
   for j = 1:n
      if j==1
        A(i, j) = i*2+j;
      else
        A(i, j) = i+j;
       end
   end
end
