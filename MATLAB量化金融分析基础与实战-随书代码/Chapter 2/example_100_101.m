%% 例100
X=magic(3);
LineArray={ '-' , ':'  '-.' };
h=bar(X); %对列画柱状图
for k=1:3
  set(h(k),'LineStyle',LineArray{k})
end
legend('列1','列2','列3','location','best')
xlabel('行号')
%% 例101
h2=bar(X,'stacked');
for k=1:3
  set(h2(k),'LineStyle',LineArray{k})
end
legend('列1','列2','列3','location','best')
xlabel('行号')