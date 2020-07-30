function [ y, lb, ub ,x, M ] = Rosenbrock_2d()
addpath('help_functions') 
addpath('TPLHD')

n = 2;
lb = -2.5*ones(n,1);        % lower bound
ub = 2.5*ones(n,1); 


% Initial samples
x = scaled_TPLHD(10,lb,ub);  

M = @(xx) rosenbrock_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function [y] = rosenbrock_function(xx)

d = length(xx);
sum = 0;
for ii = 1:(d-1)
	xi = xx(ii);
	xnext = xx(ii+1);
	new = 100*(xnext-xi^2)^2 + (xi-1)^2;
    if xx(2) > 1.5
       new = new + 700*xx(2)*xx(1); 
    end
	sum = sum + new;
end

y = sum;
end
