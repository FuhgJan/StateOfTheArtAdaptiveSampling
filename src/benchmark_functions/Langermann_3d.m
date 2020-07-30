function [ y, lb, ub,x, M ] = Langermann_3d()
% Langermann  https://www.sfu.ca/~ssurjano/langer.html

n = 3;
lb = 0*ones(n,1);        % lower bound
ub = 10*ones(n,1); 


% Initial samples
x = scaled_TPLHD(n*10,lb,ub);  

M = @(xx) Langermann_3d_function(xx);

y = zeros(size(x,1),1);
for i=1:size(x,1)
    y(i,1) = M(x(i,:));
end


end


function y = Peppe_Det_3d_function(xx)

x1 = xx(1);
x2 = xx(2);
x3 = xx(3);

term1 = exp(-2/(x1^1.75));
term2 = exp(-2/(x2^1.5));
term3 = exp(-2/(x3^1.25));

y = 100 * (term1 + term2 + term3);

end
end
