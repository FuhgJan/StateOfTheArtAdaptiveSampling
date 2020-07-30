function [ y, lb, ub ,x, M ] = Styblinski_Tang_5d()
addpath('help_functions') 
addpath('TPLHD')

n = 5;
lb = -5*ones(n,1);        % lower bound
ub = 5*ones(n,1); 


% Initial samples
x = scaled_TPLHD(n*10,lb,ub);  

M = @(xx) Styblinski_Tang_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Styblinski_Tang_function(xx)
d = length(xx);
sum = 0;
for ii = 1:d
	xi = xx(ii);
	new = xi^4 - 16*xi^2 + 5*xi;
	sum = sum + new;
end

y = sum/2;

end
