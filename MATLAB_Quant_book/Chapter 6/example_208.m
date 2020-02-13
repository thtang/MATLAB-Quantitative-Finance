load Data_EquityIdx
Data=Data(1:1500,:); %ȡǰ1500������лع�
xobvs = ret2price(price2ret(Data(:,2))); %�۲�ֵ����
time = (1:length(xobvs));   % ʱ�����У�ʱ�䲽��1
vrbl = ones(size(xobvs)); 
h = 0.5; % �ع鲽��0.5
timeseq = [0:h: length(xobvs)]; %ģ��ʱ������
x0 = xobvs(1); % SDE��ʼֵ
parmin = [x0, 1e-4,1e-4]; %��������
parmax = [x0,1,1]; %��������
parmask = [0,1,1]; % ��Ҫ���ƵĲ�����Ϊ1,��һ���Ӧx0������Ϊ0
parbase = [x0, 0.01, 0.05]; % ��ʼֵָ��
problem = 'M4'; %ָ��ģ��
numsim = 4000;
sdetype = 'Ito'; % ����ȡIto��'M4'ģ��ΪM4aģ��
integrator = 'EM';
numdepvars = 1;
randseed = 0;
myopt = optimset('fminsearch');
myopt = optimset(myopt,'MaxFunEvals',20000,'MaxIter',5000,'TolFun'...
	,1.e-4,'TolX',1.e-4,'Display','iter');
freeparest = fminsearchbnd('SDE_NPSML',parbase(2:end),parmin(2:end),...
	parmax(2:end),myopt,timeseq,time,vrbl,xobvs,problem,numsim,...
	sdetype,parbase,parmin,parmax,parmask,integrator,numdepvars,randseed);
totparam = SDE_param_unmask(freeparest,parmask,parbase);
SDE_ParConfInt('SDE_NPSML',freeparest,timeseq,time,vrbl,xobvs,problem,...
	numsim,sdetype,parbase,parmin,parmax ,parmask,integrator,numdepvars,randseed);
yesdata = 1;
SDE_graph(totparam,[],yesdata,problem,sdetype,integrator,numdepvars,...
	timeseq,[],numsim,time,xobvs,0);
SDE_stats(totparam,[],problem,timeseq,numdepvars,numsim,sdetype,integrator,0);
