%% ACcumulative Error (ACE)
% Li, Genzi, Vikrant Aute, and Shapour Azarm. "An accumulative error based adaptive design of experiments for offline metamodeling."
% Structural and Multidisciplinary Optimization 40.1-6 (2010): 137.
function x_new = ACE_function(obj,A)
%%
% Details: Obtain new sample point via ACE algorithm
%
% inputs:
% obj - Ordinary kriging class object
% A - Definition of parametric space
%
% outputs:
% x_new - New sample point

AA = [];
b = [];
Aeq = [];
beq = [];
lb = A(1,:);
ub = A(2,:);
eLOO = eL00_function(obj);

[alpha,d] = ACE_alpha(obj);

fun = @(x)ACE_optimize(obj,alpha,eLOO,x);
nonlcon = @(x)ACE_con(obj,d,x);


strategy = 'MS';
x_new = optimizationTools(fun,strategy,AA,b,Aeq,beq,lb,ub,nonlcon);


end

function eLOO_perPoint = eL00_function(obj)
%%
% Details: Define leave-one-out error for each sample point
%
% inputs:
% obj - Ordinary kriging class object
%
% outputs:
% eLOO_perPoint - Array of leave-one-out error values


eLOO_perPoint = zeros(obj.m,1);
for i=1:obj.m
    Xp = obj.X;
    Xp(i,:) = [];
    Yp = obj.Y;
    Yp(i) = [];
    M_hatp = OK_model(obj.auto_correlation_function,Xp,Yp,obj.theta_opti_technique);
    
    y = obj.Y(i);
    [mu_hatp,~] = predict(M_hatp,obj.X(i,:));
    
    eLOO_perPoint(i) = norm(y - mu_hatp);
end
end

function E_min = ACE_optimize(obj,alpha,eLOO, x)
%%
% Details: Define the optimization problem for ACE
%
% inputs:
% obj - Ordinary kriging class object
% alpha - Parameter value
% eLOO - Array of leave-one-out error values
% x - input for optimization 
%
% outputs:
% E_min - Value to be minimized

E = 0;
for i=1:obj.m
    E = E+ eLOO(i) * exp( - alpha * norm(obj.X(i,:) - x));
end

E_min = - E;
end


function [alpha, d] = ACE_alpha(obj)
%%
% Details: Obtain the alpha-value and the cluster threshold
%
% inputs:
% obj - Ordinary kriging class object
%
% outputs:
% alpha - alpha value needed for optimization problem
% d - distance criterion

min_distances= zeros(obj.m,1);
for i=1:obj.m
    clear distance_min
    iter = 1;
    distance_min = zeros(obj.m-1,1);
    for j=1:obj.m
        
        if ~(i==j)
            distance_min(iter) = norm(obj.X(i,:) - obj.X(j,:));
            iter = iter +1;
        end
    end
    min_distances(i) = min(distance_min);
end

max_distance = max(min_distances);

DOI_distance = 0.5 * max_distance;
worst_case_DOI = 10^(-5);
alpha = -log(worst_case_DOI) / DOI_distance;

d= 0.5 *mean(min_distances);

end


function [c, ceq] = ACE_con(obj,d,x)
%%
% Details: Define the nonlinear constraint
%
% inputs:
% obj - Ordinary kriging class object
% d - distance constraint value
% x - input value
%
% outputs:
% ceq - Array of equality constraints
% c - Array of inequality constraints

ceq = [];

for i=1:obj.m
    c(i) = d - norm(obj.X(i,:) - x);
end
end

