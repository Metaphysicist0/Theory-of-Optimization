
n = -10:10; % 定义n的范围
x1 = -n.*usD (-n); % 计算x1(n)
x2 = 2.^(-n).*usD(n);% 计算x2(n)
x3 = (0.5).^(n + 1).*usD (n+1); % 计算x3(n)

subplot (3,1,1); % 创建一个子图
stem (n,x1); % 绘制x1(n)
xlabel ('n'); % 标注x轴
ylabel ('x1(n)'); % 标注y轴
title ('x(n)=-nu(-n)'); % 标注标题

subplot (3,1,2); % 创建另一个子图
stem (n,x2); % 绘制x1(n)
xlabel ('n'); % 标注x轴
ylabel ('x2(n)'); % 标注y轴
title ('x(n)=2^{-n}u(-n)'); % 标注标题

subplot (3,1,3); % 创建另一个子图
stem (n,x3); % 绘制x2(n)
xlabel ('n'); % 标注x轴
ylabel ('x3(n)'); % 标注y轴
title ('x(n)=(1/2)^{(n+1)}u(n+1)'); % 标注标题
