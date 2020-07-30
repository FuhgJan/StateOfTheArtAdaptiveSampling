function [ y, lb, ub ,x, M ] = Colville_4d()
addpath('help_functions') 
addpath('TPLHD')

n = 4;
lb = -2*ones(n,1);        % lower bound
ub = 2*ones(n,1); 


% Initial samples
x = scaled_TPLHD(10*n,lb,ub);  

M = @(xx) Colville_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Colville_function(xx)
x1 = xx(1);
x2 = xx(2);
x3 = xx(3);
x4 = xx(4);

if x1 < 0 || x2 < 0
    term1 = -100 * ((x1-x2)^3)*sin(x3);
term2 = (x1-4)^2;
else
term1 = 100 * (x1^2-x2)^2;
term2 = (x1-1)^2;
end
term3 = (x3-1)^2;
term4 = 90 * (x3^2-x4)^2;
term5 = 10.1 * ((x2-1)^2 + (x4-1)^2);
term6 = 19.8*(x2-1)*(x4-1);

y = term1 + term2 + term3 + term4 + term5 + term6;
end

