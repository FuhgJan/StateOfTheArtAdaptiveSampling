function [ y, lb, ub,x, M ] = Detpep_3d( )
addpath('help_functions') 
addpath('TPLHD')

n = 3;
lb = 0*ones(n,1);        % lower bound
ub = 0.5*ones(n,1); 


% Initial samples
x = scaled_TPLHD(n*10,lb,ub);  

M = @(xx) detpep10curv(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end
end


function [y] = detpep10curv(xx)

x1 = xx(1);
x2 = xx(2);
x3 = xx(3);

term1 = 4 * (x1 - 2 + 8*x2 - 8*x2^2);
term2 = (4*x2)^2;
term3 = 16 * sqrt(x3+1) * (2*x1-1);

y = 0.6*term2 + sin(term3+ term1);

end




