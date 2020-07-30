function [ y, lb, ub,x, M ] = Two_humps_function_1d()
addpath('help_functions') 
addpath('TPLHD')

n = 1;
lb = -0.5*ones(n,1);        % lower bound
ub = 5.0*ones(n,1); 


% Initial samples
% x = scaled_TPLHD(n*8,lb,ub);  
% x = [0.0;0.92;1.56250000000000;2.25000000000000;2.93750000000000;3.62500000000000;4.31250000000000;5];
x = [3.2;3.4;3.6];
M = @(xx) Two_humps_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Two_humps_function(x)

y = 5*x +0.05./ ((x-0.45).^2 + .002) - 0.5 ./ ((x-3.5).^2 + .03) - 6;
end


