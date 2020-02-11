%% 不可用
parfor i=1:2
	eval('disp(1)');
end

%% 可用
parfor i=1:2
	parfun()
end