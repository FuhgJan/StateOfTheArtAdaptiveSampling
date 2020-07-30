%% Weighted Accumulative Error (WAE)
% Jiang, Ping, et al. "A novel sequential exploration-exploitation sampling strategy for global metamodeling."
% IFAC-PapersOnLine 48.28 (2015): 532-537.
function x_new = WAE_function(obj,A, strategy)
% Details: Starting function for WAE sampling.
%
% inputs:
% obj - Ordinary kriging class object
% A - Definition of parametric space
% strategy - Optimization strategy to be used
%
% outputs:
% x_new - New found sample point

for i=1:obj.m
    Xp = obj.X;
    Xp(i,:) = [];
    Yp = obj.Y;
    Yp(i) = [];
    
    M_hatp{i} = OK_model(obj.auto_correlation_function,Xp,Yp,obj.theta_opti_technique);
end

d_WAE = WAE_threshold(obj);
AA = [];
b = [];
Aeq = [];
beq = [];

lb = A(1,:);
ub = A(2,:);
fun = @(x) WAE_optimize(obj,M_hatp,x);
nonlcon = @(x)WAE_con(obj,d_WAE,x);

strategy = obj.theta_opti_technique;
x_new = optimizationTools(fun,strategy,AA,b,Aeq,beq,lb,ub,nonlcon);


end

function d_WAE = WAE_threshold(obj)
% Details: Define distance threshold needed for optimization
%
% inputs:
% obj - Ordinary kriging class object
%
% outputs:
% d_WAE - Distance threshold

alpha = 0.3;
WAE_min_distances = zeros(obj.m,1);

for i=1:obj.m
    Xp = obj.X;
    Xp(i,:) = [];
    [~,WAE_min_distances(i)] = knnsearch(Xp, obj.X(i,:));
end

d_WAE = mean(WAE_min_distances)*alpha;
end


function e_WAE = WAE_optimize(obj, M_hatp, x)
% Details: Function to be optimized to define new sample
%
% inputs:
% obj - Ordinary kriging class object
% M_hatp - Cell array of Leave-one-out ordinary kriging class objects
%
% outputs:
% e_WAE - Value to be optimized

w_vec = zeros(obj.m,1);

mu_hat_m1 = zeros(obj.m,1);
for i=1:obj.m
    w_vec(i) = exp(-norm(x- obj.X(i,:)));
end

wi = w_vec/sum(w_vec);

[mu_hat,~] = predict(obj,x);
for i=1:obj.m
    [mu_hat_m1(i),~] = predict(M_hatp{i},x);
end

e_WAE = 0;
for i=1:obj.m
    e_WAE = e_WAE + wi(i)*(mu_hat_m1(i)-mu_hat)^2;
end

e_WAE = sqrt(e_WAE);

end

function [c, ceq] = WAE_con(obj,d,x)
% Details: Define arrays needed for constraint optimization
%
% inputs:
% obj - Ordinary kriging class object
% d - distance constraint
% x - Input value
%
% outputs:
% c - Inequality array
% ceq - Equality array

ceq = [];

for i=1:obj.m
    c(i) = d - norm(obj.X(i,:) - x);
end
end








