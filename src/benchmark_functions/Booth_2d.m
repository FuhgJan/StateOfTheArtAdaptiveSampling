function [ y, lb, ub,x, M ] = Booth_2d()
addpath('help_functions') 
addpath('TPLHD')

n = 2;
lb = [-10;-10];        % lower bound
ub = [10;10]; 


% Initial samples
x = scaled_TPLHD(6,lb,ub);  

M = @(xx) Booth_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Booth_function(xx)

x1 = xx(1);
x2 = xx(2);

term1 = (x1 + 2*x2 - 7)^2;
term2 = (2*x1 + x2 - 5)^2;

y = term1 + term2;
end


