function [ y, lb, ub ,x, M ] = Schwefel_5d()
addpath('help_functions') 
addpath('TPLHD')

n = 5;
lb = -100*ones(n,1);        % lower bound
ub = 100*ones(n,1); 


% Initial samples
x = scaled_TPLHD(n*10,lb,ub);  

M = @(xx) Schwefel_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Schwefel_function(xx)
d = length(xx);
sum = 0;
for ii = 1:d
	xi = xx(ii);
	sum = sum + xi*sin(sqrt(abs(xi)));
end

y = 420*d - sum;
end