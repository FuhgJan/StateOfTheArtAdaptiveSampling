function [ y, lb, ub,x, M ] = Eggholder_2d()
addpath('help_functions') 
addpath('TPLHD')

n = 2;
lb = -216*ones(n,1);        % lower bound
ub = 216*ones(n,1); 


% Initial samples
x = scaled_TPLHD(n*10,lb,ub);  

M = @(xx) Eggholder(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Eggholder_function(xx)
x1 = xx(1);
x2 = xx(2);

term1 = -(x2+47) * sin(sqrt(abs(x2+x1/2+47)));
term2 = -x1 * sin(sqrt(abs(x1-(x2+47))));

y = term1 + term2;
end