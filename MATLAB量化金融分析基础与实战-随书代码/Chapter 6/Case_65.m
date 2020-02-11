%% 
load disney
h(1)=subplot(2,1,1); %ʱ������������,���зǽ������Կհ���ʾ��ͼ��
candle(dis_HIGH(1:40),dis_LOW(1:40),dis_CLOSE(1:40),dis_OPEN(1:40),...
	[],dis.dates(1:40),'yyyy-mm-dd')
axis tight %ʹͼ�ξ���������

%% 
h(2)=subplot(2,1,2); %���ս�����������ͼ�޿հ�,���ǽ�������ΪNaN
candle(dis_HIGH(1:40),dis_LOW(1:40),dis_CLOSE(1:40),dis_OPEN(1:40))
tick_index = 1:20:40;
tick_label = datestr(dis.dates(tick_index), 'yyyy-mm-dd');
set(gca,'XTick',tick_index); 
set(gca,'XTickLabel',tick_label);
axis tight 