%% Cross-Validation-Voronoi (CVVOR)
% Xu, Shengli, et al. "A robust error-pursuing sequential sampling approach for global metamodeling based on voronoi diagram and cross validation."
% Journal of Mechanical Design 136.7 (2014): 071009.
function x_new = CVVor_function(obj,A)
% Details: Starting function for CVVor sampling.
%
% inputs:
% obj - Ordinary kriging class object
% A - Definition of parametric space
%
% outputs:
% x_new - New found sample point

addpath('help_functions')
lb = A(1,:);
ub = A(2,:);
C = randomVoronoi(obj.X,lb,ub);


eLOO_perPoint = eL00_function(obj);

[~,k] = max(eLOO_perPoint);

P_sensitive = C{k,1};
maxDistance = -inf;
for i=2:size(C{k,2},1)
    distance = norm(C{k,2}(i,:)-P_sensitive);
    if distance > maxDistance
        x_new = C{k,2}(i,:);
        maxDistance = distance;
    end
end


end

function eLOO_perPoint = eL00_function(obj)
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
    M_hatp = OK_model(obj.auto_correlation_function,Xp,Yp,obj.theta_opti_technique);
    
    y = obj.Y(i);
    [mu_hatp,~] = predict(M_hatp,obj.X(i,:));
    
    eLOO_perPoint(i) = norm(y - mu_hatp);
end
end


