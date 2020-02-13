%% ��ȡ����
py.importlib.import_module('tushare');
A= py.tushare.get_k_data('399905',pyargs('index','true','ktype','M')).to_dict();
Values=values(A);
Keys=keys(A);
VarNames=cellfun(@char,cell(keys(A)),'UniformOutput',false);
M=cellfun(@(x) transpose(cell(values(x))), cell(Values), 'UniformOutput',false);
DM=cell(length(M{1}),length(M));
for i=1:length(M)
	DM(:,i)=M{:,i};
end
Data=cell2dataset(DM,'VarNames',VarNames);
Data.code =cellfun(@char,Data.code,'UniformOutput',false);
Data.date =cellfun(@char,Data.date,'UniformOutput',false);
%% ��֤500������������ɽ����仯����Э������
R=tick2ret(Data.close);
V=tick2ret(Data.volume);
egcitest([R V])
%% �������е�ƽ����
adftest(R)
adftest(V)
%% granger�������
[F,c_v]=granger_cause(R,V,0.05,1)

egcitest([V R])
[F,c_v]=granger_cause(V,R,0.05,1)