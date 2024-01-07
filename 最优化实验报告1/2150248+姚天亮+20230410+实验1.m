% 2150248 姚天亮 实验一

% 读取数据
x = load('C:\Users\YTL\OneDrive\Desktop\data_x.txt');
y = load('C:\Users\YTL\OneDrive\Desktop\data_y.txt');

% 初始化参数
w = rand(1); % 随机生成一个0到1之间的数
b = rand(1); % 随机生成一个0到1之间的数
eta = 0.3; % 学习率
iter = 50; % 最大迭代次数

% 定义损失函数
n = length(x); % 数据的个数
L = @(w,b) (1/(n))*sum((x*w+b-y).^2); % 均方误差

% 定义梯度下降法的更新规则
dw = @(w,b) (1/n)*sum((x*w+b-y).*x); % w的偏导数
db = @(w,b) (1/n)*sum(x*w+b-y); % b的偏导数

% 初始化损失函数历史记录
costHistory = zeros(iter,1);

% 初始化参数历史记录
wHistory = zeros(iter,1);
bHistory = zeros(iter,1);

% 进行梯度下降法
for i = 1:iter
    % 更新参数
    w = w - eta*dw(w,b);
    b = b - eta*db(w,b);
    
    % 计算并记录损失函数值
    costHistory(i) = L(w,b);
    
    % 判断是否需要记录参数值
    if i <= 30
        % 记录参数值
        wHistory(i) = w;
        bHistory(i) = b;
    end
end

% 绘制数据点和拟合直线的图像
figure(1)
plot(x,y,'o') % 绘制数据点
hold on
plot(x,x*w+b,'r') % 绘制拟合直线
hold off
title('线性拟合结果')
xlabel('x')
ylabel('y')

% 绘制损失函数随迭代次数变化的图像
figure(2)
plot(1:iter,costHistory,'b')
title('损失函数随迭代次数变化')
xlabel('times')
ylabel('Loss')

% 创建一个表格，将wHistory、bHistory和costHistory的前30个值放入其中
T = table((1:30)',wHistory(1:30),bHistory(1:30),costHistory(1:30),'VariableNames',{'times','w','b','Loss'});

% 显示表格
disp(T)