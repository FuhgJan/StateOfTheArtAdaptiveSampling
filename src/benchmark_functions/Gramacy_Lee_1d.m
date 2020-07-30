function [ y, lb, ub,x, M ] = Gramacy_Lee_1d()
addpath('help_functions') 
addpath('TPLHD')

n = 1;
lb = -1.5*ones(n,1);        % lower bound
ub = 1.0*ones(n,1); 


% Initial samples
x = scaled_TPLHD(n*10,lb,ub);  

M = @(xx) Gramacy_Lee_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Gramacy_Lee_function(xx)

term1 = 10*sin(6*pi*xx) / (2*cos(xx));
term2 = (xx-1)^4;


y = term1 + term2;
end


