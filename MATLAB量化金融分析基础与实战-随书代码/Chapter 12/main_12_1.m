%% 步骤一　提取上证50成份股后复权收盘价
>> py.importlib.import_module('tushare');
>> STOCK=cell(values(py.tushare.get_sz50s().to_dict()));
>> STOCK=STOCK{:,2};
>> STOCK_CODE=cellfun(@char,cell(values(STOCK)),'UniformOutput',false);
>> STOCK_CLOSE=cell(size(STOCK_CODE));
%% 步骤二 生成上证50成份股的5日与20日均线
% 并行计算
parpool('local'); %如果已经有在运行的parpool,此句可省略
tic
parfor i=1:length(STOCK_CODE)
	code_name=STOCK_CODE{i};
	OUT=one_stock_data(code_name,'D','hfq');
	[short,long]=movavg(OUT(:,2),5,20);
	STOCK_CLOSE{i}= [OUT,short,long];
end
toc
% 或者
tic
for i=1:length(STOCK_CODE)
	code_name=STOCK_CODE{i};
	OUT=one_stock_data(code_name,'D','hfq');
	[short,long]=movavg(OUT(:,2),5,20);
	STOCK_CLOSE{i}= [OUT,short,long];
end
toc
% 生成收盘价、5日均线和20日均线矩阵其以join函数按照时间将各个股票拼接起来
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
%% 步骤三 计算每个股票的收益率
% GPU计算
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
% 或者CPU计算
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
%% 画图
figure
semilogy(CLOSE.date,STG_NPV)
datetick('x','yyyy/mm/dd','keepticks')
ax=gca;
ax.XTickLabelRotation = 45; % 横坐标刻度旋转45度
axis tight
title('各个股票均线净值')
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
legend('净值曲线25%区间','净值曲线75%区间','净值曲线50%区间',...
	'收益均值的净值曲线','location','best');
title(sprintf('收益均值的年化收益为%.4f%%', yr_rate))
ax=gca;
ax.XTickLabelRotation = 45; % 横坐标刻度旋转45度
axis tight
%% 计算平均收益曲线的年化夏普比率
sharpe(gather(nanmean(RET_gpu,2)),0.02/252)*sqrt(252)
%% 绘制出所有股票的日收益率夏普比率统计图
SHARPE=sharpe(STG_RET,0.02/252);
hist(SHARPE)
title('夏普比率')
