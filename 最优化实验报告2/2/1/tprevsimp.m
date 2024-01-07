function [x,v]=tprevsimp(c,A,b,options)
if nargin ~= 4
    options = [];
        if nargin ~= 3
        disp('Wrong number of arguments.');
        return;
    end
end

clc;
format compact;
%format short e;

options = foptions(options);
print = options(1);

n=length(c);
m=length(b);

%Phase I
if print
disp(' ');
disp('Phase I');
disp('-------');
end

v=n*ones(m,1);
for i=1:m
v(i)=v(i)+i;
end
[x,v,Binv]=revsimp([zeros(n,1);ones(m,1)],[A eye(m)],b,v,eye(m),options);

%Phase II
if print
disp(' ');
disp('Phase II');
disp('--------');
end

[x,v,Binv]=revsimp(c,A,b,v,Binv,options);

if print
        disp(' ');
    disp('Final solution:');
    disp(x');
end
