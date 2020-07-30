%% Jin's Cross validation approach (CVA)
% Jin, Ruichen, Wei Chen, and Agus Sudjianto. "On sequential sampling for global metamodeling in engineering design."
% ASME 2002 International Design Engineering Technical Conferences and Computers and Information in Engineering Conference. American Society of Mechanical Engineers, 2002.
function x_new = Jin_CV_function(obj,A,strategy)
% Details: Starting function for CVA sampling.
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
    M_hatps{i} = OK_model(obj.auto_correlation_function,Xp,Yp,obj.theta_opti_technique);
end

fun = @(x) adaptive_Jin_CV(M_hatps,x);
AA = [];
b = [];
Aeq = [];
beq = [];
n = numel(A(1,:));
lb = A(1,:);
ub = A(2,:);

x_new = optimizationTools(fun,strategy,AA,b,Aeq,beq,lb,ub,[]);
end



function Jin_CV_min = adaptive_Jin_CV(obj,M_hatps,x)
% Details: Optimization function definition for CVA sampling.
%
% inputs:
% obj - Ordinary kriging class object
% M_hatps - Leave-one-out surrgoate class
% x - Input value
%
% outputs:
% Jin_CV_min - Value to be optimized

val=0;
for i=1:obj.m
    
    [mu_hat,~] = predict(obj,x);
    [mu_hatp,~] = predict(M_hatps{i},x);
    
    val = val + (mu_hatp - mu_hat)^2;
end

e = sqrt((1/obj.m) * val);

Jin_CV_min = - e * d(obj,x);
end

function min_distance = d(obj,x)
% Details: Definition of the optimization constraint
%
% inputs:
% obj - Ordinary kriging class object
% x - Input value
%
% outputs:
% min_distance - Constraint value

for i=1:obj.m
    d(i) = norm(obj.X(i,:)-x);
end
min_distance = min(d);
end
