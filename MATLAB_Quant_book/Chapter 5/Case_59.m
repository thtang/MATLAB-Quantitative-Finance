py.importlib.import_module('tushare');
A=py.tushare.get_k_data('000001',pyargs('ktype','W','autype','hfq',...
	'start', '1980-01-01')).to_dict();
Values=values(A);
Keys=keys(A);
VarNames=cellfun(@char,cell(keys(A)),'UniformOutput',false);
M=cellfun(@(x) transpose(cell(values(x))), cell(Values), 'UniformOutput',false);
DM=cell(length(M{1}),length(M));
for i=1:length(M)
	DM(:,i)=M{:,i};
end
Data=cell2dataset(DM,'VarNames',VarNames);% 平安银行周线后复权交易数据
Data.code =cellfun(@char,Data.code,'UniformOutput',false);
Data.date =cellfun(@char,Data.date,'UniformOutput',false);

candle(Data.high,Data.low,Data.close,Data.open);
tick_index = 1:200:size(Data,1);
tick_label = datestr(Data.date(tick_index), 'yyyy-mm-dd');
set(gca,'XTick',tick_index); 
set(gca,'XTickLabel',tick_label);
axis tight
