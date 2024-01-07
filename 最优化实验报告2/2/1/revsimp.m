% revsimp.m
function [x,v,Binv]=revsimp(c,A,b,v,Binv,options)
if nargin ~= 6
options = [];
if nargin ~= 5
disp('Wrong number of arguments.');
return;
end
end
format compact;
%format short e;
options = foptions(options);
print = options(1);

n=length(c);
m=length(b);

cB=c(v(:));
y0 = Binv*b;
lambdaT=cB'*Binv;
r = c'-lambdaT*A; %row vector of relative cost coefficients
if print
disp(' ');
disp('Initial revised tableau [v B^(-1) y0]:');
disp([v Binv y0]);
disp('Relative cost coefficients:');
disp(r);
end %if

while ones(1,n)*(r' >= zeros(n,1)) ~= n
if options(5) == 0;
[r_q,q] = min(r);
else
%Bland’s rule
q=1;
while r(q) >= 0
q=q+1;
end
end %if
yq = Binv*A(:,q);
min_ratio = inf;
p=0;
for i=1:m,
if yq(i)>0
if y0(i)/yq(i) < min_ratio
min_ratio = y0(i)/yq(i);
p = i;
end %if
end %if
end %for
if p == 0
disp('Problem unbounded');
break;
end %if
if print,
disp('Augmented revised tableau [v B^(-1) y0 yq]:')
disp([v Binv y0 yq]);
disp('(p,q):');
disp([p,q]);
end

augrevtabl=pivot([Binv y0 yq],p,m+2);
Binv=augrevtabl(:,1:m);
y0=augrevtabl(:,m+1);

v(p) = q;

cB=c(v(:));
lambdaT=cB'*Binv;
r = c'-lambdaT*A; %row vector of relative cost coefficients

if print,
disp('New revised tableau [v B^(-1) y0]:');
disp([v Binv y0]);
disp('Relative cost coefficients:');
disp(r);
end %if
end %while
x=zeros(n,1);
x(v(:))=y0;

