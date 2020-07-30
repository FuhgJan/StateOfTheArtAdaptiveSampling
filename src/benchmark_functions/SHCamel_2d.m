function [ y, lb, ub,x, M ] = SHCamel_2d()
addpath('help_functions') 
addpath('TPLHD')

n = 2;
lb = [-2;-1];        % lower bound
ub = [2;1]; 


% Initial samples
x = scaled_TPLHD(10,lb,ub);  

M = @(xx) SHCamel_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function [y] = SHCamel_function(xx)

x1 = xx(1);
x2 = xx(2);

term1 = (4-2.1*x1^2+(x1^4)/3) * x1^2;
term2 = x1*x2;
term3 = (-4+4*x2^2) * x2^2;

y = term1 + term2 + term3;

end

