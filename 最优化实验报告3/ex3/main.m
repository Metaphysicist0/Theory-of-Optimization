%2150248 姚天亮 自动化

%MPC：QP加速梯度投影法
% 线性系统系数矩阵
A=[2 2 0; -2 -1 1;0 2 1.5]; 
B=[0;0;1];
% 初始状态量-如果不能在下一步回到约束范围内，则会造成无解
x0=[2;1;1];
% 预测步长
Np=10;
% 优化目标参数，加权矩阵
Q=eye(3); R=1;
% 转化为用控制量ut表示的，关于状态量的推导方程的矩阵
At=[]; Bt=[]; temp=[];
% 转换后的加权矩阵
Qt=[]; Rt=[];
% 加权矩阵的计算过程，以及推导方程矩阵的叠加过程
for i=1:Np
    At=[At; A^i];
    Bt=[Bt zeros(size(Bt,1), size(B,2));A^(i-1)*B temp];
    temp=[A^(i-1)*B temp];
    Qt=[Qt zeros(size(Qt,1),size(Q,1));zeros(size(Q,1),size(Qt,1)) Q];
    Rt=[Rt zeros(size(Rt,1),size(R,1));zeros(size(R,1),size(Rt,1)) R];
end

% 控制量ut的上下限
lb=-10*ones(Np,1);
ub=10*ones(Np,1);
% 转换后的优化目标函数矩阵，循环优化函数中H后的表达式为优化目标的另一项
H=2*(Bt'*Qt*Bt + Rt);
% 转换后的优化中的不等式约束左边系数矩阵，后面循环中的bi为不等式右边
Ai= eye(Np);
u=[]; % u用来保存每一步采用的控制量
x=x0; % x用来保存状态变量
xk=x0; % 保存当前时刻的状态

%此处为增加的梯度投影下降法使用到的矩阵
G=zeros(Np);
W=[20;10;20;zeros(7,1)];%此处的含义是为了满足Gz<=W+Sx，但是为了补足可乘，所以为10*1，多余补零
S=[eye(3);zeros(7,3)];%注意此处为了配合S*x，需要补成10*3的矩阵

for k=1:50

    % 进行二次优化
    C=(2*At'*Qt*Bt)';%与之前不同的是，本处因为采用到一阶系数矩阵，所以不能有xk，故不乘xk（测试过程中如果加上xk结果会出错）
    [ut]=quickqp(H,C,xk,G,W,S);
    %此处为QP以加速梯度投影法写成的求解器

    % 采用优化得到的控制量的第一个元素作为实际作用的控制量，代入到原系统中得到下一个时刻的状态量
    u(k) = ut(1);
    x(:, k+1) = A*x(:, k) + B*u(k);
    xk = x(:, k+1);
end

%打出图像
figure();
plot(x');
legend('x_1','x_2','x_3');

figure();
plot(u);
legend('u');