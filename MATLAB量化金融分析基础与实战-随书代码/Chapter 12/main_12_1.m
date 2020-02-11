%% ����һ����ȡ��֤50�ɷݹɺ�Ȩ���̼�
>> py.importlib.import_module('tushare');
>> STOCK=cell(values(py.tushare.get_sz50s().to_dict()));
>> STOCK=STOCK{:,2};
>> STOCK_CODE=cellfun(@char,cell(values(STOCK)),'UniformOutput',false);
>> STOCK_CLOSE=cell(size(STOCK_CODE));
%% ����� ������֤50�ɷݹɵ�5����20�վ���
% ���м���
parpool('local'); %����Ѿ��������е�parpool,�˾��ʡ��
tic
parfor i=1:length(STOCK_CODE)
	code_name=STOCK_CODE{i};
	OUT=one_stock_data(code_name,'D','hfq');
	[short,long]=movavg(OUT(:,2),5,20);
	STOCK_CLOSE{i}= [OUT,short,long];
end
toc
% ����
tic
for i=1:length(STOCK_CODE)
	code_name=STOCK_CODE{i};
	OUT=one_stock_data(code_name,'D','hfq');
	[short,long]=movavg(OUT(:,2),5,20);
	STOCK_CLOSE{i}= [OUT,short,long];
end
toc
% �������̼ۡ�5�վ��ߺ�20�վ��߾�������join��������ʱ�佫������Ʊƴ������
CLOSE= dataset(STOCK_CLOSE{1}(:,1),STOCK_CLOSE{1}(:,2),...
	'VarNames',{'date',strcat('x',STOCK_CODE{1})});
for i=2:length(STOCK_CODE)
	CLOSE =join(CLOSE,dataset(STOCK_CLOSE{i}(:,1), STOCK_CLOSE{i}(:,2),...
		'VarNames',{'date',strcat('x',STOCK_CODE{i})}),'type','outer',...
		'mergekeys',true,'keys','date');
end
CLOSE=sortrows(CLOSE,'date','ascend');

MA5= dataset(STOCK_CLOSE{1}(:,1),STOCK_CLOSE{1}(:,3),...
	'VarNames',{'date',strcat('x',STOCK_CODE{1})});
for i=2:length(STOCK_CODE)
	MA5=join(MA5,dataset(STOCK_CLOSE{i}(:,1), STOCK_CLOSE{i}(:,3),...
		'VarNames',{'date',strcat('x',STOCK_CODE{i})}),'type','outer',...
		'mergekeys',true,'keys','date');
end
MA5=sortrows(MA5,'date','ascend');

MA20= dataset(STOCK_CLOSE{1}(:,1),STOCK_CLOSE{1}(:,4),...
	'VarNames',{'date',strcat('x',STOCK_CODE{1})});
for i=2:length(STOCK_CODE)
	MA20=join(MA20,dataset(STOCK_CLOSE{i}(:,1), STOCK_CLOSE{i}(:,4),...
		'VarNames',{'date',strcat('x',STOCK_CODE{i})}),'type','outer',...
		'mergekeys',true,'keys','date');
end
MA20=sortrows(MA20,'date','ascend');
%% ������ ����ÿ����Ʊ��������
% GPU����
tic
CLOSE_gpu=gpuArray(double(CLOSE(:,2:end)));
RET_gpu=tick2ret(CLOSE_gpu);
MA5_gpu= gpuArray(double(MA5(:,2:end)));
MA20_gpu= gpuArray(double(MA20(:,2:end)));
MA_cross= MA5_gpu> MA20_gpu;
STG_RET=gather(MA_cross(1:end-1,:).*RET_gpu);
STG_RET(isnan(RET_gpu))=0;
STG_NPV= ret2tick(STG_RET);
toc
% ����CPU����
tic
CLOSE_cpu=double(CLOSE(:,2:end));
RET_cpu=tick2ret(CLOSE_cpu);
MA5_cpu=double(MA5(:,2:end));
MA20_cpu= double(MA20(:,2:end));
MA_cross= MA5_cpu> MA20_cpu;
STG_RET=MA_cross(1:end-1,:).*RET_cpu;
STG_RET(isnan(RET_cpu))=0;
STG_NPV= ret2tick(STG_RET);
toc
%% ��ͼ
figure
semilogy(CLOSE.date,STG_NPV)
datetick('x','yyyy/mm/dd','keepticks')
ax=gca;
ax.XTickLabelRotation = 45; % ������̶���ת45��
axis tight
title('������Ʊ���߾�ֵ')
mean_NPV= ret2tick(nanmean(RET_gpu,2));
figure
p25= prctile(STG_NPV,25,2);
p50= prctile(STG_NPV,50,2);
p75= prctile(STG_NPV,75,2);
semilogy(CLOSE.date(1:50:end),p25(1:50:end) ,'k--')
hold on
semilogy(CLOSE.date(1:50:end),p50 (1:50:end),'-.')
semilogy(CLOSE.date(1:50:end),p75(1:50:end) ,'k--')
semilogy(CLOSE.date,mean_NPV,'r')
datetick('x','yyyy/mm/dd','keepticks')
yr_rate=(exp(log(mean_NPV (end)/ mean_NPV (1))/(length(mean_NPV)/250))-1)*100;
legend('��ֵ����25%����','��ֵ����75%����','��ֵ����50%����',...
	'�����ֵ�ľ�ֵ����','location','best');
title(sprintf('�����ֵ���껯����Ϊ%.4f%%', yr_rate))
ax=gca;
ax.XTickLabelRotation = 45; % ������̶���ת45��
axis tight
%% ����ƽ���������ߵ��껯���ձ���
sharpe(gather(nanmean(RET_gpu,2)),0.02/252)*sqrt(252)
%% ���Ƴ����й�Ʊ�������������ձ���ͳ��ͼ
SHARPE=sharpe(STG_RET,0.02/252);
hist(SHARPE)
title('���ձ���')
