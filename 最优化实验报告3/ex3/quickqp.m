%2150248 姚天亮 自动化

function [z]=quickqp(Q,c,x,G,W,S)
% H为二次项Q
% f为一次项c’
%A，l，u为约束条件 H即是Q
n = size(Q,1);
% w = ones(n,1);
% z = ones(n,1);
% s = ones(n,1);
y=ones(n,1);

maxiter = 10000;

k=0;    %迭代计数

K=inv(Q)*G';
J=inv(Q)*c;
L=max(eig(G*inv(Q)*G'));
y_1=y;  %记录上一次y

while k<maxiter
beta=max((k-1)/k+2,0);
w=y+beta*(y-y_1);
z=-K*w-J*x;
s=(1/L)*G*z-(1/L)*(W+S*x);
y_1=y;
y=max(w+s,0);
k=k+1;
end