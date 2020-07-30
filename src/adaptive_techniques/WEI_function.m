%% Weighted expected improvement (WEI)
% Jones, Donald R., Matthias Schonlau, and William J. Welch. "Efficient global optimization of expensive black-box functions."
% Journal of Global optimization 13.4 (1998): 455-492.
function WEI_min = WEI_function(obj,x)
% Details: Starting function for WEI sampling.
%
% inputs:
% obj - Ordinary kriging class object
% A - Definition of parametric space
%
% outputs:
% x_new - New found sample point

beta_hat = compute_beta_hat(obj,obj.R);
sigma_sq_hat = compute_sigma_sq_hat(obj,obj.R,beta_hat);

mu_hat = compute_mu_hat(obj,obj.R,beta_hat,x(:),obj.theta);
sigma_Y_sq_hat = compute_sigma_Y_sq_hat(obj,sigma_sq_hat,x(:),obj.theta,obj.R);


ymin = min(obj.Y);
val = (ymin-mu_hat)/sqrt(sigma_Y_sq_hat);
w = 0.2;

WEI = w * (ymin - mu_hat) * normcdf(val) + (1-w) * sqrt(sigma_Y_sq_hat) * normpdf(val);

WEI_min=-WEI;
end

%% WEI
function WEI_min = adaptive_WEI(obj,x)
% Details: Function to be optimized to find new sample
%
% inputs:
% obj - Ordinary kriging class object
% x - Input value
%
% outputs:
% WEI_min - Value to be optimized

beta_hat = compute_beta_hat(obj,obj.R);
sigma_sq_hat = compute_sigma_sq_hat(obj,obj.R,beta_hat);

mu_hat = compute_mu_hat(obj,obj.R,beta_hat,x(:),obj.theta);
sigma_Y_sq_hat = compute_sigma_Y_sq_hat(obj,sigma_sq_hat,x(:),obj.theta,obj.R);


ymin = min(obj.Y);
val = (ymin-mu_hat)/sqrt(sigma_Y_sq_hat);
w = 0.2;
WEI = w * (ymin - mu_hat) * normcdf(val) + (1-w) * sqrt(sigma_Y_sq_hat) * normpdf(val);

WEI_min=-WEI;
end


