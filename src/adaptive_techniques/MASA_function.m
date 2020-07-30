%% Mixed  Adaptive  Sampling  Algorithm (MASA)
% Eason, John, and Selen Cremaschi. "Adaptive sequential sampling for surrogate model generation with artificial neural networks."
% Computers & Chemical Engineering 68 (2014): 220-232.
function x_new = MASA_function(obj,A)
% Details: Starting function for MASA sampling.
%
% inputs:
% obj - Ordinary kriging class object
% A - Definition of parametric space
%
% outputs:
% x_new - New found sample point


% Create committee by LOOCV or different autocorrelation functions
committee_type = 'AutoCorrelation';
% committee_type = 'LOOCV';

Committee = MASA_comittee(obj, committee_type);
N_of_Committe = numel(Committee);

% Create candidate points, user chosen 5000*dimensions
addpath('help_functions')
d = size(obj.X,2);
C_candidatePoints = 5000 * d;
lb = A(1,:);
ub = A(2,:);
CandidatePoints = scale_rand(C_candidatePoints,lb,ub);

for j=1:C_candidatePoints
    normal_model_value = predict(obj,CandidatePoints(j,:));
    for i=1:N_of_Committe
        committee_model_value = predict(Committee{i},CandidatePoints(j,:));
        y_tilde(j,i) = N_of_Committe * normal_model_value - (N_of_Committe - 1) * committee_model_value;
    end
    k = dsearchn(obj.X,CandidatePoints(j,:));
    nndp(j) = norm(obj.X(k,:) - CandidatePoints(j,:));
end

for j=1:C_candidatePoints
    y_tilde_avg = mean(y_tilde(j,:));
    
    val = 0;
    for i=1:N_of_Committe
        val = val + (y_tilde(j,i) - y_tilde_avg)^2;
    end
    s_sq(j) = ( 1/(N_of_Committe * (N_of_Committe - 1))) * val;
end


for j=1:C_candidatePoints
    np(j) = (nndp(j)/max(nndp)) + (s_sq(j)/(max(s_sq)));
end

[~,I_c] = max(np);
x_new = CandidatePoints(I_c,:);

end

function Committee = MASA_comittee(obj, committee_type)
% Details: Create comittee of kriging models by LOOCV or Autocorrelation
% function
%
% inputs:
% obj - Ordinary kriging class object
% committee_type - Definition of how to create committee
%
% outputs:
% Committee - Cell array of committee members 

% Create comittee of kriging models by LOOCV
if strcmp(committee_type,'LOOCV')
N=obj.m;
index = randperm( size(obj.X,1),N);
for i=1:numel(index)
    Xp = obj.X;
    Xp(index(i),:) = [];
    Yp = obj.Y;
    Yp(index(i)) = [];
    
    M_hatp = OK_model(obj.auto_correlation_function,Xp,Yp,obj.theta_opti_technique);
    Committee{i} = M_hatp;
end
% Create comittee of kriging models by AutoCorrelation
elseif strcmp(committee_type,'AutoCorrelation')
M_hat_Cubic = OK_model(@Cubic_spline_matrix,obj.X,obj.Y,obj.theta_opti_technique);        
M_hat_Matern32 = OK_model(@Matern32_matrix,obj.X,obj.Y,obj.theta_opti_technique);  
M_hat_Matern52 = OK_model(@Matern52_matrix,obj.X,obj.Y,obj.theta_opti_technique);
M_hat_ex_sq = OK_model(@R_sq_ex_matrix,obj.X,obj.Y,obj.theta_opti_technique);
M_hat_ex = OK_model(@R_ex_matrix,obj.X,obj.Y,obj.theta_opti_technique);


Committee = {M_hat_Cubic; M_hat_Matern32; M_hat_Matern52; M_hat_ex_sq; M_hat_ex };
end
end



