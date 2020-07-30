function [ y, lb, ub,x, M ] = Perm0db_1d()
addpath('help_functions') 
addpath('TPLHD')

n = 1;
lb = -1*ones(n,1);        % lower bound
ub = 2.0*ones(n,1); 


% Initial samples
% x = scaled_TPLHD(3,lb,ub); 
x = [-0.5; 0.5;  1.5; 1.7];

M = @(xx) perm0db_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function [y] = perm0db_function(xx)


if (nargin == 1)
    b = 10;
end

d = length(xx);
outer = 0;

for ii = 1:d
	inner = 0;
	for jj = 1:d
		xj = xx(jj);
        inner = inner + (jj+b)*(xj^ii-(1/jj)^ii);
	end
	outer = outer + inner^2;
end

y = outer;


end




