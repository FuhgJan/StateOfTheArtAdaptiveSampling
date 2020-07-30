function [ R ] = Cubic_spline_matrix( x1,x2,theta )
% Details: Create autocorrelation matrix with cubic spline kernel
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
        xi = theta(p) * abs(x1(i,p)-x2(j,p));
        if (0.0 <= xi) && (xi <= 0.2)
            val = 1 - 15*xi^2 + 30* xi^3;
        elseif (0.2 < xi) && (xi < 1.0)
            val = 1.25 * (1 - xi)^3;
        elseif xi >= 1.0
            val = 0.0;
        end
        R_val = R_val* val;
        end
        R(i,j) = R_val;
    end
end


end