function [ y, lb, ub,x, M ] = Rastrigin_2d()
addpath('help_functions') 
addpath('TPLHD')

n = 2;
lb = -6*ones(n,1);        % lower bound
ub = 2*ones(n,1);


% Initial samples
x = scaled_TPLHD(n*10,lb,ub);

M = @(xx) Rastrigin_2d_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end


end


function y = Rastrigin_2d_function(xx)


d = length(xx);
sum = 0;

if xx(1)<-2.5 && xx(2) <-2.5
for ii = 1:d
        xi = xx(ii);
        sum = sum + (0.2*xi^3 - 10*cos(2*pi*xi));
end
else
 for ii = 1:d
        xi = xx(ii);
        sum = sum + 0.2*xi^3+(3*abs(xi) - 30*sin(pi*abs(xi)));
end
end

y = 10*d + sum;
end

