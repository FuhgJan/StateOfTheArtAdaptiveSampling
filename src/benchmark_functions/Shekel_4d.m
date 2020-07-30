function [ y, lb, ub,x, M ] = Shekel_4d()
addpath('help_functions') 
addpath('TPLHD')

n = 4;
lb = 0*ones(n,1);        % lower bound
ub = 10*ones(n,1); 


% Initial samples
x = scaled_TPLHD(n*10,lb,ub);  

M = @(xx) Shekel_4d_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end



end


function y = Shekel_4d_function(xx)
m = 10;
b = 0.1 * [1, 2, 2, 4, 4, 6, 3, 7, 5, 5]';
C = [4.0, 1.0, 8.0, 6.0, 3.0, 2.0, 5.0, 8.0, 6.0, 7.0;
     4.0, 1.0, 8.0, 6.0, 7.0, 9.0, 3.0, 1.0, 2.0, 3.6;
     4.0, 1.0, 8.0, 6.0, 3.0, 2.0, 5.0, 8.0, 6.0, 7.0;
     4.0, 1.0, 8.0, 6.0, 7.0, 9.0, 3.0, 1.0, 2.0, 3.6];

outer = 0;
for ii = 1:m
	bi = b(ii);
	inner = 0;
	for jj = 1:4
		xj = xx(jj);
		Cji = C(jj, ii);
		inner = inner + (xj-Cji)^2;
	end
	outer = outer + 1/(inner+bi);
end

y = -outer;

end
