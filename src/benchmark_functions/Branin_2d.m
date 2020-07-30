function [ y, lb, ub,x, M ] = Branin_2d()
addpath('help_functions') 
addpath('TPLHD')

n = 2;
lb = [-5;0];        % lower bound
ub = [10;15]; 


% Initial samples
x = scaled_TPLHD(10,lb,ub);  

M = @(xx) Branin_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end

function [y] = Branin_function(xx)


x1 = xx(1);
x2 = xx(2);


a = 1;
b = 5.1 / (4*pi^2);
c = 5 / pi;
r = 6;
s = 10;
t = 1 / (8*pi);
term1 = a * (x2 - b*x1^2 + c*x1 - r)^2;
term2 = s*(1-t)*cos(x1);

y = term1 + term2 + s;
end



