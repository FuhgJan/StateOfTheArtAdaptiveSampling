function [ y, lb, ub,x, M ] = Micha_2d()
addpath('help_functions') 
addpath('TPLHD')

n = 2;
lb = [0;0];        % lower bound
ub = [pi;pi]; 


% Initial samples
x = scaled_TPLHD(n*10,lb,ub);  

M = @(xx) Micha_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Micha_function(xx)
if (nargin == 1)
    m = 4;
end

d = length(xx);
sum = 0;

for ii = 1:d
	xi = xx(ii);
	new = -sin(2*xi) * (sin(ii*xi^2/(pi)))^(2*m);
	sum  = sum + new;
end

y = -sum- 0.2*xx(1);
end

