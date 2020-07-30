%% MC-intersite-proj-th (MIPT)
% Crombecq, Karel, Eric Laermans, and Tom Dhaene. "Efficient space-filling and non-collapsing sequential design strategies for simulation-based modeling."
% European Journal of Operational Research 214.3 (2011): 683-696.
function x_new = MIPT_function(obj,A)
% Details: Starting function for MIPT sampling.
%
% inputs:
% obj - Ordinary kriging class object
% A - Definition of parametric space
%
% outputs:
% x_new - New found sample point

addpath('TPLHD')
n = numel(A(1,:));
lb = A(1,:);
ub = A(2,:);
p = scaled_TPLHD(100 * obj.m,lb,ub);

alpha = 0.5;
dmin = (2*alpha)/ obj.m;
MIPT_val = -inf;

addpath('help_functions')
for i=1:size(p,1)
    val = intersite_proj_th(dmin, obj.X,p(i,:));
    if val > MIPT_val
        MIPT_val = val;
        x_new = p(i,:);
    end
    
end

end

