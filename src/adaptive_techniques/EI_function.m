%% Expected improvement (EI)
% Jones, Donald R., Matthias Schonlau, and William J. Welch. "Efficient global optimization of expensive black-box functions."
% Journal of Global optimization 13.4 (1998): 455-492.
function x_new = EI_function(obj,A, strategy)
% Details: Starting function for EI sampling.
%
% inputs:
% obj - Ordinary kriging class object
% A - Definition of parametric space
% strategy - Optimization strategy to be used
%
% outputs:
% x_new - New found sample point

fun = @(x) adaptive_EI(obj,x);
AA = [];
b = [];
Aeq = [];
beq = [];
n = numel(A(1,:));
lb = A(1,:);
ub = A(2,:);

x_new = optimizationTools(fun,strategy,AA,b,Aeq,beq,lb,ub,[]);
end

function EI_min = adaptive_EI(obj,x)
% Details: EI optimization function.
%
% inputs:
% obj - Ordinary kriging class object
% x - Input value
%
% outputs:
% EI_min - Value to be optimized

beta_hat = compute_beta_hat(obj,obj.R);
sigma_sq_hat = compute_sigma_sq_hat(obj,obj.R,beta_hat);

mu_hat = compute_mu_hat(obj,obj.R,beta_hat,x,obj.theta);
sigma_Y_sq_hat = compute_sigma_Y_sq_hat(obj,sigma_sq_hat,x,obj.theta,obj.R);


ymin = min(obj.Y);
val = (ymin-mu_hat)/sqrt(sigma_Y_sq_hat);
EI = (ymin - mu_hat) * normcdf(val) + sqrt(sigma_Y_sq_hat) * normpdf(val);

EI_min=-EI;


end
