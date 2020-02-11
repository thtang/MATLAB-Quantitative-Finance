stock={'000001';'300001';'600000';'002527'};
SH=cellfun(@(x) regexp(x,'^60.*','match'),stock,'UniformOutput',false);
SH=SH(~cellfun(@isempty ,SH)) ;


SZ=cellfun(@(x)regexp(x,'^(00|30).*','match'),stock,'UniformOutput',false);
SZ=SZ(~cellfun(@isempty ,SZ));
