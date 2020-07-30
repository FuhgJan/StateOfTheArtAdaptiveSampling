function [ y, lb, ub ,x, M ] = Michalewicz_3d()
addpath('help_functions') 
addpath('TPLHD')

n = 3;
lb = 0*ones(n,1);        % lower bound
ub = pi*ones(n,1); 


% Initial samples
x = scaled_TPLHD(n*10,lb,ub);  

M = @(xx) Michalewicz_3d_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Michalewicz_3d_function(xx)
if (nargin == 1)
    m = 10;
end

d = length(xx);
sum = 0;

for ii = 1:d
	xi = xx(ii);
	new = sin(xi) * (sin(ii*xi^2/pi))^(2*m);
	sum  = sum + new;
end

y = -sum;
end

