function [ y, lb, ub,x, M ] = Gramacy_Lee3_1d()
addpath('help_functions') 
addpath('TPLHD')

n = 1;
lb = -1.5*ones(n,1);        % lower bound
ub = 6*ones(n,1); 


% Initial samples
x = scaled_TPLHD(n*10,lb,ub);  

M = @(xx) Gramacy_Lee_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Gramacy_Lee_function(xx)

term1 = 50*sin(6*pi*xx) / (cos(xx));
term2 = (xx-1)^4;

if xx>0.5 && xx<=2.5
   term2 = 0.8*(xx-1)^4;
   term1 = 20*sin(6*pi*xx)/(3*(xx)); 
   epsilon = -100.0;
elseif xx>2.5
   term2 = 0.5*(xx-1)^3;
   term1 = 100*sin(4*pi*xx)/((xx)); 
   epsilon = -50.0;
else
    
    epsilon= -30.0;
end
y = term1 + term2+epsilon;
end


