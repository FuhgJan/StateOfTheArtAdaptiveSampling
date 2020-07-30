%% Space-Filling Cross Validation Tradeoff (SFCVT)
% Aute, Vikrant, et al. "Cross-validation based single response adaptive design of experiments for Kriging metamodeling of deterministic computer simulations."
% Structural and Multidisciplinary Optimization 48.3 (2013): 581-605.
function x_new = SFVCT_function(obj,A,strategy)
% Details: Starting function for SFCVT sampling.
%
% inputs:
% obj - Ordinary kriging class object
% A - Definition of parametric space
% strategy - Optimization strategy to be used
%
% outputs:
% x_new - New found sample point

rel_elo = calculate_rel_elo(obj);

e_model = OK_model(obj.auto_correlation_function,obj.X,rel_elo,strategy);


AA = [];
b = [];
Aeq = [];
beq = [];

lb = A(1,:);
ub = A(2,:);

S = SFVCT_S(obj);

fun = @(x)SFVCT_optimize(e_model,x);
nonlcon = @(x)SFVCT_con(obj,S,x);


strategy = 'MS';
x_new = optimizationTools(fun,strategy,AA,b,Aeq,beq,lb,ub,nonlcon);



end

function elo_min = SFVCT_optimize(e_model,x)
% Details: Function to be optimized.
%
% inputs:
% e_model - Ordinary kriging class object
% x - Input value
%
% outputs:
% elo_min - Value to be optimized

elo_min = - e_model.predict(x);
end

function rel_elo = calculate_rel_elo(obj)
% Details: Obtain the relative leave-one-out error
%
% inputs:
% e_model - Ordinary kriging class object
%
% outputs:
% rel_elo - Array of relative leave-one-out errors

rel_elo = zeros(obj.m,1);
for i=1:obj.m
    Xp = obj.X;
    Xp(i,:) = [];
    Yp = obj.Y;
    Yp(i) = [];
    M_hatp = OK_model(obj.auto_correlation_function,Xp,Yp,obj.theta_opti_technique);
    
    y = obj.Y(i,:);
    [mu_hatp,~] = predict(M_hatp,obj.X(i,:));
    
    rel_elo(i,1) = (norm(y - mu_hatp));%/y;
end
end

function [S] = SFVCT_S(obj)
% Details: Get the SFVCT distance for the nonlinear constraint
%
% inputs:
% obj - Ordinary kriging class object
%
% outputs:
% S - Distance constraint value


% This is faster than pdist2
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

% Check pdist2
%min_distances = max(pdist2(obj.X,obj.X,'euclidean','Smallest',2));


max_distance = max(min_distances);

S= 0.5 *max_distance;

end

function [c, ceq] = SFVCT_con(obj,d,x)
% Details: Define arrays needed for the constraint definition
%
% inputs:
% obj - Ordinary kriging class object
% d - Distance constraint value
% x - Input value
%
% outputs:
% c - Inequality constraint array
% ceq - Equality constraint array

ceq = [];

for i=1:obj.m
    c(i) = d - norm(obj.X(i,:) - x);
end
end
