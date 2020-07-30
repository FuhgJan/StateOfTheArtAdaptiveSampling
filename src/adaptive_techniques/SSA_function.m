%% Smart Sampling Algorithm (SSA)
%  Garud, Sushant Suhas, Iftekhar A. Karimi, and Markus Kraft. 
%  "Smart sampling algorithm for surrogate model development." Computers & Chemical Engineering 96 (2017): 103-114
function x_new = SSA_function(obj,A,strategy)
% Details: Starting function for SSA sampling.
%
% inputs:
% obj - Ordinary kriging class object
% A - Definition of parametric space
% strategy - Optimization strategy to be used
%
% outputs:
% x_new - New found sample point

% obtain crowding distance metric
CMD = zeros(obj.m,1);
for i=1:obj.m
    val = 0.0;
    for j=1:obj.m
        val = val + norm(obj.X(i,:)-obj.X(j,:))^2;
    end
    CMD(i) = val;
end

[~,p] = sort(CMD,'descend');

AA = [];
b = [];
Aeq = [];
beq = [];
lb = A(1,:);
ub = A(2,:);

% Assume epsilon to 0.01. Value not given by the authors.
epsilon = 0.01;

T = 0;
iter = 1;
while ~all(T)
    
    clear diff Xp Yp
    Xp = obj.X;
    Xp(p(iter),:) = [];
    
    Yp = obj.Y;
    Yp(p(iter),:) = [];
    M_hatp = OK_model(obj.auto_correlation_function,Xp,Yp,obj.theta_opti_technique);
    M_hat = obj;
    fun = @(x) SSA_optimize(x,M_hatp,M_hat);
    x_new = optimizationTools(fun,strategy,AA,b,Aeq,beq,lb,ub,[]);
    
    diff = zeros(obj.m,1);
    for ii=1:obj.m
        diff(ii) = norm(x_new - obj.X(ii,:));
    end
    
    T = diff > epsilon;
    
    iter = iter+1;
    
    if (iter > obj.m)
        iter =1;
        epsilon = epsilon/2;
    end
end

end


function NLP = SSA_optimize(x,OKp,obj)
% Details: Function to be optimized
%
% inputs:
% x - Input value
% OKp - Leave-one-out ordinary Kriging models
% obj - Ordinary kriging class object
%
% outputs:
% NLP - Value to be optimized

val = 0.0;
for i=1:obj.m
    val = val + norm(x-obj.X(i,:))^2;
end
CMD = val;
[mu_hat,~] = predict(obj,x);
[mu_hatp,~] = predict(OKp,x);
Delta = (mu_hat - mu_hatp)^2;

NLP = -Delta * CMD;
end

