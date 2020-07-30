function [ y, lb, ub,x, M ] = Single_hump_1d()
addpath('help_functions') 
addpath('TPLHD')

n = 1;
lb = -1.5*ones(n,1);        % lower bound
ub = 5.0*ones(n,1); 


% Initial samples
% x = scaled_TPLHD(5,lb,ub);  
 x = [-1.5;0.;1.4;2.5;3.8;4.4];
%x = [4.4;4.5;4.6];
M = @(xx) Single_hump_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Single_hump_function(x)

y = 3*x -0.5./ ((x-4.75).^2 + .04) -0.07./ ((x-4.45).^2 + .005)  - 6;
end
