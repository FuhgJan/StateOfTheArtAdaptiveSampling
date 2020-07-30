function [ y, lb, ub,x, M ] = Sphere_4d()
addpath('help_functions') 
addpath('TPLHD')

n = 4;
% lb = [-5.12;-5.12; -5.12];        % lower bound
% ub = [5.12;5.12; 5.12]; 
lb = -5.12*ones(n,1);       % lower bound
ub = 5.12*ones(n,1);

% Initial samples
x = scaled_TPLHD(10,lb,ub);  

M = @(xx) sphere_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = sphere_function(xx)
d = length(xx);
sum = 0;
for ii = 1:d
	xi = xx(ii);
	sum = sum + xi^2;
end

y = sum;
end

