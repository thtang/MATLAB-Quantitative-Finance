function O=assign_parfor_loop
tic;
parfor i=1:1e8
	a(i)=1+1;
end
O=toc;
