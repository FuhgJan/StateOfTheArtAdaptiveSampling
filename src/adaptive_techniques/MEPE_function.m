%% Maximizing Expected Prediction Error (MEPE)
%Liu, Haitao, Jianfei Cai, and Yew-Soon Ong. "An adaptive sampling approach for kriging metamodeling by maximizing expected prediction error."
%Computers & Chemical Engineering 106 (2017): 171-182.
function x_new = MEPE_function(obj,A,strategy)
% Details: Starting function for MEPE sampling.
%
% inputs:
% obj - Ordinary kriging class object
% A - Definition of parametric space
% strategy - Optimization strategy to be used
%
% outputs:
% x_new - New found sample point

global MEPE_q
global old_Model
if MEPE_q == 1
    old_Model = obj;
    e_true = inf;
elseif MEPE_q>1
    e_true = abs(old_Model.predict(obj.X(end,:))-obj.Y(end));
    old_Model = obj;
end

beta_hat = compute_beta_hat(obj,obj.R);
sigma_sq_hat = compute_sigma_sq_hat(obj,obj.R,beta_hat);

sigma_Y_sq_hat_fun = @(x) compute_sigma_Y_sq_hat(obj,sigma_sq_hat,x,obj.theta,obj.R);


e_CV = e_CV_fast_function(obj);
alpha = MEPE_alpha_function(obj,e_true, e_CV(end));
fun =@(x) -( alpha * e_CV_nearestPoint_function(obj,e_CV, x) + (1-alpha) * sigma_Y_sq_hat_fun(x));

AA = [];
b = [];
Aeq = [];
beq = [];
lb = A(1,:);
ub = A(2,:);

x_new = optimizationTools(fun,strategy,AA,b,Aeq,beq,lb,ub,[]);
end

function e_CV_fast = e_CV_fast_function(obj)
% Details: Efficient way to obtain leave-one-out cross validation error as
% defined in paper
%
% inputs:
% obj - Ordinary kriging class object
%
% outputs:
% e_CV_fast - Array of leave-one-out error values

beta_hat = compute_beta_hat(obj,obj.R);
H = obj.F *((obj.F' * obj.F)\obj.F');
d = obj.Y - obj.F * beta_hat;
inv_R = inv(obj.R);
e_CV_fast = zeros(obj.m,1);
for i=1:obj.m
    
    e_CV_fast(i) = ((inv_R(i,:) * ( d + H(:,i) * (d(i)/(1-H(i,i)))) ) / (inv_R(i,i)) )^2;
end
end


function e_CV_nearestPoint = e_CV_nearestPoint_function(obj, e_CV, x)
% Details: Utility function to find the leave-one-out error of the nearest
% point
%
% inputs:
% obj - Ordinary kriging class object
% e_CV - Array of leave-one-out errors 
% x - Input value
%
% outputs:
% e_CV_nearestPoint - Leave-one-out error at position x

k = dsearchn(obj.X,x);
e_CV_nearestPoint = e_CV(k);
end




function alpha = MEPE_alpha_function(obj,e_true, e_CV)
% Details: Utility function to get the current alpha value
%
% inputs:
% obj - Ordinary kriging class object
% e_true - "True" leave-one-out errors 
% e_CV - Leave-one-out errors 
%
% outputs:
% alpha - alpha value

global MEPE_q

if MEPE_q == 1
    alpha = 0.5;
elseif MEPE_q>1
    val = 0.5 * ((e_true^2) / e_CV);
    alpha = 0.99 * min(val,1);
end

MEPE_q = MEPE_q + 1;
end



