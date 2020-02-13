%% 例140
tablename='TEST_CODE';
dat=[{2,'james'};{3,'jim'}]; %插入数据应为cell格式
conn=connect_database;
curs = exec(conn,sprintf('select * from %s',tablename));  %建立光标
data = fetch(curs,1); %利用光标读取第一行数据，存入data结构体
colnames=columnnames(data); %查询列名
colnames(find(colnames==''''))='"';%列名中如有双引号会转为单引号,故需转回
colnames=regexp(colnames, ',', 'split');
insert(conn,tablename,colnames,dat); %插入数据
conn.commit();%注意conn在关闭时会触发commit
close(curs); 
close(conn);
%% 例141
whereclause={'where "id"=2';}; % 将where条件语句分别放置在cell单元中
update(conn,tablename,colnames(2),{'lily'},whereclause);% 将满足条件的第二列改为lily