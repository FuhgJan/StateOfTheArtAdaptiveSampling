function [ R ] = Matern32_matrix( x1,x2,theta )
% Details: Create autocorrelation matrix with Matern32 kernel
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
        R_val = 1;
        for p=1:n
            r = x1(i,p)-x2(j,p);
            %kval = (sqrt(3)*abs(r))/theta(p);
            kval = (sqrt(3)*abs(r))*theta(p);
            val = (1+ kval)*exp(-kval);
            R_val = R_val* val;
        end
        R(i,j) = R_val;
    end
end



end
