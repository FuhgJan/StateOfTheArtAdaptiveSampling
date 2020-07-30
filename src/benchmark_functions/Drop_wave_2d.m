function [ y, lb, ub,x, M ] = Drop_wave_2d()
addpath('help_functions') 
addpath('TPLHD')

n = 2;
lb = -0.6*ones(n,1);        % lower bound
ub = 0.9*ones(n,1); 


% Initial samples
x = scaled_TPLHD(n*10,lb,ub);  

M = @(xx) Drop_wave_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Drop_wave_function(xx)
x1 = xx(1);
x2 = xx(2);


frac1 = 1 + cos(12*sqrt(x1^2+x2^2));
frac2 = 0.5*(x1^2+x2^2) + 2;

y = -frac1/frac2;
end

