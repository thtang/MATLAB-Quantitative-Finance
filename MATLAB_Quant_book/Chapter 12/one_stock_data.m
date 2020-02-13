function OUT=one_stock_data(code_name,ktype,autpye)
A=py.tushare.get_k_data(code_name,pyargs('ktype',ktype,'autype', autpye,...
	'start','1995-01-01')).to_dict();
Values=values(A);
Keys=keys(A);
VarNames=cellfun(@char,cell(keys(A)),'UniformOutput',false);
M=cellfun(@(x) transpose(cell(values(x))), cell(Values), 'UniformOutput',false);
DM=cell(length(M{1}),length(M));
for j=1:length(M)
	DM(:,j)=M{:,j};
end
Data=cell2dataset(DM,'VarNames',VarNames);
Data.code =cellfun(@char,Data.code,'UniformOutput',false);
Data.date =datenum(cellfun(@char,Data.date,'UniformOutput',false),'yyyy-mm-dd');
OUT=[Data.date,Data.close];
OUT=sortrows(OUT,1);