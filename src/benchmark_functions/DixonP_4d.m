function [ y, lb, ub,x, M ] = DixonP_4d()
addpath('help_functions') 
addpath('TPLHD')

n = 3;
lb = [-10;-10;-10;-10];        % lower bound
ub = [10;10;10;10]; 


% Initial samples
x = scaled_TPLHD(10,lb,ub);  

M = @(xx) dixonp_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = dixonp_function(xx)
x1 = xx(1);
d = length(xx);
term1 = (x1-1)^2;

sum = 0;
for ii = 2:d
	xi = xx(ii);
	xold = xx(ii-1);
	new = ii * (2*xi^2 - xold)^2;
	sum = sum + new;
end

y = term1 + sum;
end
