function conn=connect_database
conn.driver=[];
conn=database('instance','user','pass',...
	'oracle.jdbc.driver.OracleDriver','jdbc:oracle:thin:@192.168.1.111:1521:');
%����������Ӵ����ʱ����������
while(isempty(conn.driver)||conn.TimeOut~=0) 
	pause(3);
	try
		conn.close();
	catch err
		disp(err)
	end
	conn=database('instance','user','pass','oracle.jdbc.driver.OracleDriver',...
		'jdbc:oracle:thin:@192.168.1.111:1521:');
	fprintf('reconnecting\n')
end
