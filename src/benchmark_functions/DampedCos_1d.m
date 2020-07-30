function [ y, lb, ub,x, M ] = DampedCos_1d()
addpath('help_functions') 
addpath('TPLHD')

n = 1;
lb = 0*ones(n,1);        % lower bound
ub = 1*ones(n,1); 


% Initial samples
x = scaled_TPLHD(5,lb,ub); 
% x = [-0.5; 0.5;  1.5];

M = @(xx) damped_cos_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function [y] = damped_cos_function(x)


fact1 = exp(-1.4*x);
fact2 = cos(3.5*pi*x);

y = fact1 * fact2;

end




