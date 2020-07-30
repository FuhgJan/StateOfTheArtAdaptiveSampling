function [ R ] = R_sq_ex_matrix( x1,x2,theta )
% Details: Create autocorrelation matrix with squared exponential kernel
%
% inputs:
% x1 - First input vector 
% x2 - Second input vector
% theta - Hyperparameter vector
%
% outputs:
% R - Autocorrelation matrix
n = size(x1,2);
m1 = size(x1,1);
m2 = size(x2,1);

R = -inf*(ones(m1,m2));
for i=1: m1
    
    for j=1:m2
        val = 0.0;
        for p=1:n
            r = abs(x1(i,p)-x2(j,p));
            val = val + ((r)/theta(p))^(2);
        end
        R(i,j) = exp(- val);
    end
end


end