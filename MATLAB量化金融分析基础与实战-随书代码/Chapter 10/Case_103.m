%% 例260
M=zeros(5,5); % 步骤一:创建MATLAB矩阵
G=gpuArray(M); %步骤二:创建gpuArray类
G2=G+1; %步骤三:做运算
G3=gather(G2); %步骤四:将运算结果传回为MATLAB矩阵