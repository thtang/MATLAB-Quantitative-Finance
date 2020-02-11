function OUT=stock_total_share()
A=py.tushare.get_stock_basics().to_dict();
Values=values(A);
Keys=keys(A);
CODES=cellfun(@char,cell(py.list(keys(Values{1})))','UniformOutput',false);
VarNames=cellfun(@char,cell(keys(A)),'UniformOutput',false);
M=cellfun(@(x) transpose(cell(values(x))), cell(Values), 'UniformOutput',false);
DM=cell(length(M{1}),length(M));
for j=1:length(M)
	DM(:,j)=M{:,j};
end
Data=cell2dataset(DM,'VarNames',VarNames);
OUT=dataset(CODES,Data.totals,'VarNames',{'code','totals'});
