% affscale.m
function [x,N] = affscale(c,A,b,u,options);
if nargin ~= 5
options = [];
if nargin ~= 4
disp('Wrong number of arguments.');
return;
end
end
xnew=u;
if length(options) >= 14
if options(14)==0
options(14)=1000*length(xnew);
end
else
options(14)=1000*length(xnew);
end
%if length(options) < 18
options(18)=0.99; %optional step size
%end
%clc;
format compact;
format short e;
options = foptions(options);
print = options(1);
epsilon_x = options(2);
epsilon_f = options(3);
max_iter=options(14);
alpha=options(18);
n=length(c);
m=length(b);
for k = 1:max_iter,
xcurr=xnew;
D = diag(xcurr);
Abar = A*D;
Pbar = eye(n) - Abar'*inv(Abar*Abar')*Abar;
d = -D*Pbar*D*c;
if d ~= zeros(n,1),
nonzd = find(d<0);
r = min(-xcurr(nonzd)./d(nonzd));
else
disp('Terminating: d = 0');
break;
end
xnew = xcurr+alpha*r*d;
if print,
disp('Iteration number k =')
disp(k); %print iteration index k
disp('alpha_k =');
disp(alpha*r); %print alpha_k
disp('New point =');
disp(xnew'); %print new point
end %if
if norm(xnew-xcurr) <= epsilon_x*norm(xcurr)
disp('Terminating: Relative difference between iterates <');
disp(epsilon_x);
break;
end %if
if abs(c'*(xnew-xcurr)) < epsilon_f*abs(c'*xcurr),
disp('Terminating: Relative change in objective function <' );
disp(epsilon_f);
break;
end %if
if k == max_iter
disp('Terminating with maximum number of iterations');
end %if
end %for
if nargout >= 1
x=xnew;
if nargout == 2
N=k;
end
else
disp('Final point =');
disp(xnew');
disp('Number of iterations =');
disp(k);
end %if

