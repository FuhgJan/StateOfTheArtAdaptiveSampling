function [ y, lb, ub ,x, M ] = Franke_2d()
addpath('help_functions') 
addpath('TPLHD')

n = 2;
lb = -0.5*ones(n,1);        % lower bound
ub = 1*ones(n,1); 


% Initial samples
x = scaled_TPLHD(10,lb,ub);  

M = @(xx) franke_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function [y] = franke_function(xx)


x1 = xx(1);
x2 = xx(2);

term1 = 0.75 * exp(-(9*x1-2)^2/4 - (9*x2-2)^2/4);
term2 = 0.75 * exp(-(9*x1+1)^2/49 - (9*x2+1)/10);
term3 = 0.5 * exp(-(9*x1-7)^2/4 - (9*x2-3)^2/4);
term4 = -0.2 * exp(-(9*x1-4)^2 - (9*x2-7)^2);

y = 2.5*term1 + 1.5*term2 + term3 + 8*term4;

end