%% 
load disney
h(1)=subplot(2,1,1); %时间坐标轴连续,会有非交易日以空白显示在图上
candle(dis_HIGH(1:40),dis_LOW(1:40),dis_CLOSE(1:40),dis_OPEN(1:40),...
	[],dis.dates(1:40),'yyyy-mm-dd')
axis tight %使图形尽可能填满

%% 
h(2)=subplot(2,1,2); %按照交易日连续画图无空白,除非交易数据为NaN
candle(dis_HIGH(1:40),dis_LOW(1:40),dis_CLOSE(1:40),dis_OPEN(1:40))
tick_index = 1:20:40;
tick_label = datestr(dis.dates(tick_index), 'yyyy-mm-dd');
set(gca,'XTick',tick_index); 
set(gca,'XTickLabel',tick_label);
axis tight 