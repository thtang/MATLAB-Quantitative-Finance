%% ��140
tablename='TEST_CODE';
dat=[{2,'james'};{3,'jim'}]; %��������ӦΪcell��ʽ
conn=connect_database;
curs = exec(conn,sprintf('select * from %s',tablename));  %�������
data = fetch(curs,1); %���ù���ȡ��һ�����ݣ�����data�ṹ��
colnames=columnnames(data); %��ѯ����
colnames(find(colnames==''''))='"';%����������˫���Ż�תΪ������,����ת��
colnames=regexp(colnames, ',', 'split');
insert(conn,tablename,colnames,dat); %��������
conn.commit();%ע��conn�ڹر�ʱ�ᴥ��commit
close(curs); 
close(conn);
%% ��141
whereclause={'where "id"=2';}; % ��where�������ֱ������cell��Ԫ��
update(conn,tablename,colnames(2),{'lily'},whereclause);% �����������ĵڶ��и�Ϊlily