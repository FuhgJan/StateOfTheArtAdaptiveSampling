function [ y, lb, ub,x, M ] = Hartmann_3d()
addpath('help_functions') 
addpath('TPLHD')

n = 3;
lb = -1*ones(n,1);        % lower bound
ub = 1*ones(n,1); 


% Initial samples
x = scaled_TPLHD(10*n,lb,ub);  

M = @(xx) Hartmann_3d_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Hartmann_3d_function(xx)
alpha = [1.0, 1.2, 3.0, 3.2]';
A = [3.0, 10, 30;
     0.1, 10, 35;
     3.0, 10, 30;
     0.1, 10, 35];
P = 10^(-4) * [3689, 1170, 2673;
               4699, 4387, 7470;
               1091, 8732, 5547;
               381, 5743, 8828];

outer = 0;
for ii = 1:4
	inner = 0;
	for jj = 1:3
		xj = xx(jj);
		Aij = A(ii, jj);
		Pij = P(ii, jj);
		inner = inner + Aij*(xj-Pij)^2;
	end
	new = alpha(ii) * exp(-inner);
	outer = outer + new;
end

y = -outer;

end

