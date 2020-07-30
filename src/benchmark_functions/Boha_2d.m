function [ y, lb, ub,x, M ] = Boha_2d()
addpath('help_functions') 
addpath('TPLHD')

n = 2;
lb = [-100;-100];        % lower bound
ub = [100;100]; 


% Initial samples
x = scaled_TPLHD(6,lb,ub);  

M = @(xx) Boha_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Boha_function(xx)

x1 = xx(1);
x2 = xx(2);

term1 = x1^2;
term2 = 2*x2^2;
term3 = -0.3 * cos(3*pi*x1);
term4 = -0.4 * cos(4*pi*x2);

y = term1 + term2 + term3 + term4 + 0.7;
end

