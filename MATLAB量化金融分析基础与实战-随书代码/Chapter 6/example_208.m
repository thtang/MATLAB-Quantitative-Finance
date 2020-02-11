load Data_EquityIdx
Data=Data(1:1500,:); %取前1500个点进行回归
xobvs = ret2price(price2ret(Data(:,2))); %观察值序列
time = (1:length(xobvs));   % 时间序列，时间步长1
vrbl = ones(size(xobvs)); 
h = 0.5; % 回归步长0.5
timeseq = [0:h: length(xobvs)]; %模拟时间序列
x0 = xobvs(1); % SDE初始值
parmin = [x0, 1e-4,1e-4]; %参数上限
parmax = [x0,1,1]; %参数下限
parmask = [0,1,1]; % 需要估计的参数置为1,第一项对应x0，必须为0
parbase = [x0, 0.01, 0.05]; % 初始值指定
problem = 'M4'; %指定模型
numsim = 4000;
sdetype = 'Ito'; % 参数取Ito的'M4'模型为M4a模型
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
