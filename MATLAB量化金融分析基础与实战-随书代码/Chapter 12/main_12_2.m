%% ����һ����ȡ��֤50�ɷݹɵĹɱ���Ϣ�͹ɼ۲�������ֵ
MV=stock_total_share();
STOCK=cell(values(py.tushare.get_sz50s().to_dict()));
STOCK=STOCK{:,2};
STOCK_CODE=cellfun(@char,cell(values(STOCK)),'UniformOutput',false);
STOCK_MV=cell(size(STOCK_CODE));
% ��parforѭ�����ɹ�Ʊ��ֵ�����̼���Ϣ
parpool('local'); %����Ѿ��������е�parpool,�˾��ʡ��
tic
parfor i=1:length(STOCK_CODE)
	code_name=STOCK_CODE{i};
	OUT=one_stock_data(code_name,'M',py.None);
	OUT_b=one_stock_data(code_name,'M','hfq');
	code_cell= cellfun(@(x) code_name,cell(size(OUT,1),1),'UniformOutput',false);
	MV_cell=OUT(:,2)*MV.totals(strcmp(MV.code,code_name));
	MVS=dataset(OUT(:,1) ,'VarNames',{'date'});
	MVS.mv= MV_cell;
	MVS.code= code_cell;
	CLOSES=mat2dataset(OUT_b,'VarNames',{'date','close_hfq'});
	STOCK_MVS=join(MVS,CLOSES,'type','inner','mergekeys',true,'keys','date');
	STOCK_MVS=sortrows(STOCK_MVS,'date','ascend');
	STOCK_MVS.next_month_Ret=[tick2ret(STOCK_MVS.close_hfq);0];
	STOCK_MV{i}= STOCK_MVS;
end
toc
%% ����� ������ֵ�Թ�Ʊ���з������򲢼���ǰ10����ֵ��С��Ʊ�ķ���������
STOCK_MV_ALL=STOCK_MV{1};
for i=2:length(STOCK_MV)
	STOCK_MV_ALL= [STOCK_MV_ALL;STOCK_MV{i}];
end
STOCK_MV_ALL = sortrows(STOCK_MV_ALL,'date','ascend');
Ret=splitapply(@splitfun,STOCK_MV_ALL,findgroups(STOCK_MV_ALL.date));
Ret=sortrows(Ret,1);
%% ������ ���Ա�50ָ��
index=py.tushare.get_k_data('000016',pyargs('index','true','ktype','M')).to_dict();
Values=values(index);
Keys=keys(index);
VarNames=cellfun(@char,cell(keys(index)),'UniformOutput',false);
M=cellfun(@(x) transpose(cell(values(x))), cell(Values), 'UniformOutput',false);
DM=cell(length(M{1}),length(M));
for j=1:length(M)
	DM(:,j)=M{:,j};
end
Data=cell2dataset(DM,'VarNames',VarNames);
Data.next_month_Ret=[tick2ret(Data.close);0];
Data.date=datenum(cellfun(@char,Data.date,'UniformOutput',false),'yyyy-mm-dd');
Ret=mat2dataset(Ret,'VarNames',{'date','NXM_Stock'});
Dat=dataset(Data.date,Data.next_month_Ret, 'VarNames',{'date','NXM_index'});
Result=join(Dat,Ret,'keys','date','type','inner','mergekeys',true);
%% ��ͼ
figure
h(1)=subplot(2,1,1);
semilogy(ret2tick(Result.NXM_index(1:end-1)),'r--');
hold on
semilogy(ret2tick(Result.NXM_Stock(1:end-1)));
title('��ֵ���߶Ա�');
legend('ָ��','С��ֵ','location','best');
tick_index=1:36:size(Result,1);
tick_label=datestr(Result.date(tick_index), 'yyyy-mm-dd');
set(gca,'XTick',tick_index); 
set(gca,'XTickLabel',tick_label);
axis tight
h(2)=subplot(2,1,2);
semilogy(cumprod(1+ Result.NXM_Stock(1:end-1)-Result.NXM_index(1:end-1))); 
alpha=mean(Result.NXM_Stock -Result.NXM_index)*100;
title(sprintf('alpha�ۼƸ��Ͼ�ֵ,�³���ر�=%5.2f%%', alpha));
set(gca,'XTick',tick_index); 
set(gca,'XTickLabel',tick_label);
linkaxes(h,'x');
axis tight