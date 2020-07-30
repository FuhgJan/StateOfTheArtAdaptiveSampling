%% Adaptive Maximum Entropy (AME)
% Liu, Haitao, et al. "An adaptive Bayesian sequential sampling approach for global metamodeling."
% Journal of Mechanical Design 138.1 (2016): 011404.
function x_new = AME_function(obj,A,strategy)
% Details: Starting function for AME sampling.
%
% inputs:
% obj - Ordinary kriging class object
% A - Definition of parametric space
% strategy - Optimization strategy to be used
%
% outputs:
% x_new - New found sample point

global gamma_index
global AMEpattern

global theta_or_not
eloos = AME_eL00_function(obj);
nu = ( (1/max(eloos)) .* eloos ).^(AMEpattern(gamma_index));


R_adj = zeros(obj.m,obj.m);

%theta2 = optimize_theta2(obj, nu);

for i=1:obj.m
    for j=1:obj.m
        R_adj(i,j) = bayesian_autocorrelation_Matern(obj.X(i,:),obj.X(j,:),nu(i),nu(j),obj.theta );
    end
end

%             obj.R = R_adj;
R_adj = obj.R;
beta_hat = compute_beta_hat(obj,obj.R);
sigma_sq_hat = compute_sigma_sq_hat(obj,obj.R,beta_hat);

fun =@(x) adj_r0(obj,x,R_adj,nu, sigma_sq_hat);
AA = [];
b = [];
Aeq = [];
beq = [];
lb = A(1,:);
ub = A(2,:);

strategy = 'MS';

x_new = optimizationTools(fun,strategy,AA,b,Aeq,beq,lb,ub,[]);

gamma_index = gamma_index+1;
if gamma_index > numel(AMEpattern)
    gamma_index = 1;
end
%disp(AMEpattern(gamma_index))


end


function eLOO_perPoint = AME_eL00_function(obj)
% Details: Obtains leave-one-out error value per sample point
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
    
    M_hatp = OK_model(obj.auto_correlation_function,Xp,Yp,obj.theta_opti_technique, obj.theta);
    
    
    
    y = obj.Y(i);
    
    [mu_hatp,~] = predict(M_hatp,obj.X(i,:));
    
    
    
    eLOO_perPoint(i) = norm(y - mu_hatp);
    
end

end


function AME_function_opti = adj_r0(obj,x,R,nu, sigma_sq)
% Details: Function that needs to be optimized for AME.
%
% inputs:
% obj - Ordinary kriging class object
% x - Point in sample space
% R - Given autocorrelation matrix
% sigma_sq - Variance
%
% outputs:
% AME_function_opti - Function output to be optimized

%r0 = zeros(obj.m,1);

Idx = knnsearch(obj.X,x);

r02 = zeros(obj.m,1);
for i=1:obj.m
    r02(i,1) =bayesian_autocorrelation_Matern(x,obj.X(i,:),nu(Idx),nu(i),obj.theta);
end
OptiMatrix =  [R r02;
    r02' 1];

AME_function_opti = -det(OptiMatrix);



end

function R = bayesian_autocorrelation_Matern(x1,x2,nu1,nu2,theta )
%%
% Details: Define altered Matern 3/2 autocorrelation function
%
% inputs:
% x1 - First input
% x2 - Second input
% nu1 - First alteration value
% nu2 - Second alteration value
% theta - Hyperparamter vector
%
% outputs:
% R - Autocorrelation value

n = numel(x1);


R_val = 1;
for i=1:n
    r = x1(i)-x2(i);
    %kval = (sqrt(3)*abs(r))/theta(p);
    kval = (sqrt(3)*abs(r))*(theta(i)*nu1*nu2);
    val = (1+ kval)*exp(-kval);
    R_val = R_val* val;
end
R = R_val;



end


