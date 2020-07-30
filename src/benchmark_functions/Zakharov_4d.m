function [ y, lb, ub ,x, M ] = Zakharov_4d()
addpath('help_functions') 
addpath('TPLHD')

n = 4;
lb = -10*ones(n,1);        % lower bound
ub = 10*ones(n,1); 


% Initial samples
x = scaled_TPLHD(n*10,lb,ub);  

M = @(xx) Zakharov_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Zakharov_function(xx)
d = length(xx);
sum1 = 0;
sum2 = 0;

for ii = 1:d
	xi = xx(ii);
	sum1 = sum1 + xi^2;
	sum2 = sum2 + 0.5*ii*xi;
end

y = sum1 + sum2^2 + sum2^4;
end


