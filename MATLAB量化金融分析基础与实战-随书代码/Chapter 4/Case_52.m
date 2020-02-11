
%% step 1
hospital = readtable('hospital.xls','ReadRowNames',true);
hospital.smoke = nominal(hospital.smoke,{'No','Yes'}); 
%% step 2
model='sys ~ 1 + age + wgt + smoke';
mdl = fitlm(hospital, model)
plotResiduals(mdl)

outlier = mdl.Residuals.Raw > 9;  %数据清洗条件
OL=find(outlier);
mdl = fitlm(hospital, model,'Exclude', OL);
mdl.ObservationInfo(OL,:)

mdl1 = step(mdl,'NSteps',10);

mdl1.Formula.disp
%% step 3
ages = [20;40;60];
smoker = {'Yes';'No';'Yes'};
predictnew = mdl1.feval(ages,smoker)

mdl1.Coefficients(:,1)