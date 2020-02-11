function OUT=splitfun(INPUT)
INPUT=sortrows(INPUT,'mv','ascend');
SMALL_GROUP=INPUT(1:min(10,size(INPUT,1)),:);
OUT=[SMALL_GROUP.date(1),mean(SMALL_GROUP.next_month_Ret)];
