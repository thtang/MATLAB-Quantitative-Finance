try
	load a.mat
catch err
	if size(err.stack,1)>=1
		linenumb=err.stack(end).line;
	else
		linenumb=0;
	end
fprintf('script error-line %d|%s|%s\n',linenumb,err.identifier,err.message);
end
