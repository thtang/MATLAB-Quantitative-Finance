function weight=weight_gen(x,L1,L2,L3,L4)
weight=(x<L1)*1+(x<L2)*1+(x<L3)*1+(x<L4)*1;
