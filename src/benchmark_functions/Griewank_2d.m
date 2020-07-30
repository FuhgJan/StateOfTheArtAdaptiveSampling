function [ y, lb, ub,x, M ] = Griewank_2d()
addpath('help_functions') 
addpath('TPLHD')

n = 2;
lb = -4*ones(n,1);        % lower bound
ub = 0*ones(n,1);



% Initial samples
x = scaled_TPLHD(n*10,lb,ub);  

M = @(xx) Griwank_2d_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end

function y = Griwank_2d_function(xx)


d = length(xx);
sum = 0;
prod = 1;

for ii = 1:d
        xi = xx(ii);
        sum = sum + xi^3/4000;
        prod = prod * cos(xi^2/sqrt(ii));
end

y = sum - prod + 1;
end


