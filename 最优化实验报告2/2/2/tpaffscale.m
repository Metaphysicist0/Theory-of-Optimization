% tpaffscale.m
function [x,N]=tpaffscale(c,A,b,options)
if nargin ~= 4
options = [];
if nargin ~= 3
disp('Wrong number of arguments.');
return;
end
end
%clc;
format compact;
format short e;
options = foptions(options);
print = options(1);
n=length(c);
m=length(b);
%Phase I
if print,
disp(' ');
disp('Phase I');
disp('-------');
end
u = rand(n,1);
v = b-A*u;
if v ~= zeros(m,1),
u = affscale([zeros(1,n),1]',[A v],b,[u' 1]',options);
u(n+1) = [0];%caotamadedashabigeilaozichacuochabantian
end
if print
disp('')
disp('Initial condition for Phase II:')
disp(u)
end
if u(n+1) < options(2),
%Phase II
u(n+1) = [];
if print
disp(' ');
disp('Phase II');
disp('--------');
disp('Initial condition for Phase II:');
disp(u);
end
[x,N]=affscale(c,A,b,u,options);
if nargout == 0
disp('Final point =');
disp(x');
disp('Number of iterations =');
disp(N);
end %if
else
disp('Terminating: problem has no feasible solution.');
end
