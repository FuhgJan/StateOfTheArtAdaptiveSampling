%% Expected improvement for global fit (EIGF)
% Lam, Chen Quin. "Sequential adaptive designs in computer experiments for response surface model fit."
% Diss. The Ohio State University, 2008.
function x_new = EIGF_function(obj,A, strategy)
% Details: Starting function for EIGF sampling.
%
% inputs:
% obj - Ordinary kriging class object
% A - Definition of parametric space
% strategy - Optimization strategy to be used
%
% outputs:
% x_new - New found sample point

fun = @(x) adaptive_EIGF(obj,x);
AA = [];
b = [];
Aeq = [];
beq = [];
n = numel(A(1,:));
lb = A(1,:);
ub = A(2,:);

x_new = optimizationTools(fun,strategy,AA,b,Aeq,beq,lb,ub,[]);
end

function EIGF_min = adaptive_EIGF(obj, x)
% Details: EIGF optimization function.
%
% inputs:
% obj - Ordinary kriging class object
% x - Input value
%
% outputs:
% EIGF_min - Value to be optimized

beta_hat = compute_beta_hat(obj,obj.R);
sigma_sq_hat = compute_sigma_sq_hat(obj,obj.R,beta_hat);

mu_hat = compute_mu_hat(obj,obj.R,beta_hat,x,obj.theta);
sigma_Y_sq_hat = compute_sigma_Y_sq_hat(obj,sigma_sq_hat,x,obj.theta,obj.R);


k = dsearchn(obj.X,x);
EIGF = (mu_hat - obj.Y(k))^(2) + sigma_Y_sq_hat;

EIGF_min=-EIGF;
end
