%% ��260
M=zeros(5,5); % ����һ:����MATLAB����
G=gpuArray(M); %�����:����gpuArray��
G2=G+1; %������:������
G3=gather(G2); %������:������������ΪMATLAB����