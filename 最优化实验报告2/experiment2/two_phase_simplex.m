function [x, fval, basis, table] = two_phase_simplex(A, b, c)
% 两阶段修正单纯形法
% 输入：线性规划问题的 A, b, c
% 输出：最优值 x, 最优函数值 cTx, 最优值对应的基向量序号，以及迭代中间过程的修正单纯形表

[m, n] = size(A); % m 为约束个数，n 为变量个数
% 第一阶段：求解辅助问题
A1 = [A eye(m)]; % 添加人工变量
c1 = [zeros(n, 1); ones(m, 1)]; % 辅助目标函数系数
basis1 = n+1:n+m; % 初始基向量序号
table1 = [A1 b; c1' -c1'*A1 -c1'*b]; % 初始单纯形表
while any(table1(end, 1:end-1) < 0) % 辅助目标函数有负系数时继续迭代
    [~, q] = min(table1(end, 1:end-1)); % 选取最小负系数对应的列
    if all(table1(1:end-1, q) <= 0) % 如果该列全为非正数，则辅助问题无界
        error('The auxiliary problem is unbounded.');
    end
    theta = table1(1:end-1, end) ./ table1(1:end-1, q); % 计算每行的 theta 值
    theta(theta <= 0) = inf; % 将非正数设为无穷大
    [min_theta, p] = min(theta); % 选取最小正 theta 值对应的行
    basis1(p) = q; % 更新基向量序号
    table1(p, :) = table1(p, :) / table1(p, q); % 将主元所在行除以主元
    for i = [1:p-1 p+1:m+1] % 对其他行进行高斯消元
        table1(i, :) = table1(i, :) - table1(i, q) * table1(p, :);
    end
end

if abs(table1(end, end)) > 0 % 如果辅助问题的最优值不为零，则原问题无可行解
    error('The original problem is infeasible.');
end

% 第二阶段：求解原问题
A2 = table1(1:m, 1:n); % 去掉人工变量后的系数矩阵
b2 = table1(1:m, end); % 去掉人工变量后的右端项向量
basis2 = basis1(basis1 <= n); % 去掉人工变量后的基向量序号
table2 = [A2 b2; c' -c'*A2 -c'*b2]; % 初始单纯形表
while any(table2(end, 1:end-1) < 0) % 目标函数有负系数时继续迭代
    [~, q] = min(table2(end, 1:end-1)); % 选取最小负系数对应的列
    if all(table2(1:end-1, q) <= 0) % 如果该列全为非正数，则原问题无界
        error('The original problem is unbounded.');
    end
    theta = table2(1:end-1, end) ./ table2(1:end-1, q); % 计算每行的 theta 值
    theta(theta <= 0) = inf; % 将非正数设为无穷大
        [min_theta, p] = min(theta); % 选取最小正 theta 值对应的行
    basis2(p) = q; % 更新基向量序号
    table2(p, :) = table2(p, :) / table2(p, q); % 将主元所在行除以主元
    for i = [1:p-1 p+1:m+1] % 对其他行进行高斯消元
        table2(i, :) = table2(i, :) - table2(i, q) * table2(p, :);
    end
end

x = zeros(n, 1); % 初始化最优值向量
x(basis2) = table2(1:m, end); % 将基变量的值赋给最优值向量
fval = table2(end, end); % 最优函数值
basis = basis2; % 最优值对应的基向量序号
table = table2; % 迭代中间过程的修正单纯形表
end


