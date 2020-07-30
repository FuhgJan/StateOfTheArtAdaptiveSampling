function [ y, lb, ub,x, M ] = Bukin2_2d()
addpath('help_functions') 
addpath('TPLHD')

n = 2;
lb = [-20;-5];        % lower bound
ub = [15;5]; 


% Initial samples
x = scaled_TPLHD(n*10,lb,ub);  

M = @(xx) Bukin_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Bukin_function(xx)
x1 = xx(1);
x2 = xx(2);

term1 = 20 * sqrt(abs(x2 * 0.01*x1^2));
term5 = 20 * abs(cos(x2 - 0.01*x1^2));
term3 = 5 * sqrt(abs(x2^2 * x1));

term4 = 10 * sqrt(abs(0.02*x2^2 + 0.001*x1^3));
term2 = 0.01 * abs(x1+10);

y = term1 + term3 + term5;
end

