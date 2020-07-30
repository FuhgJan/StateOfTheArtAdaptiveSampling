function [ y, lb, ub,x, M ] = Ishigami_3d( )
addpath('help_functions') 
addpath('TPLHD')

n = 3;
lb = 0*ones(n,1);        % lower bound
ub = 4*pi*ones(n,1); 


% Initial samples
x = scaled_TPLHD(n*10,lb,ub);  

M = @(xx) ishi_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end
end


function [y] = ishi_function(xx)

x1 = xx(1);
x2 = xx(2);
x3 = xx(3);

if (nargin == 1)
	a = 7;
	b = 0.1;
elseif (nargin == 2)
	b = 0.1;
end

term1 = sin(x1);
term2 = a * (sin(x2))^2;
term3 = b * x3^4 * sin(x1);

y = term1 + term2 + term3;

end
