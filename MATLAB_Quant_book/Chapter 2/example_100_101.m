%% ��100
X=magic(3);
LineArray={ '-' , ':'  '-.' };
h=bar(X); %���л���״ͼ
for k=1:3
  set(h(k),'LineStyle',LineArray{k})
end
legend('��1','��2','��3','location','best')
xlabel('�к�')
%% ��101
h2=bar(X,'stacked');
for k=1:3
  set(h2(k),'LineStyle',LineArray{k})
end
legend('��1','��2','��3','location','best')
xlabel('�к�')