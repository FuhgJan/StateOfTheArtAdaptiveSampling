%% Taylor expansion-based adaptive design (TEAD)
% Mo, Shaoxing, et al. "A Taylor expansion‐based adaptive design strategy for global surrogate modeling with applications in groundwater modeling."
% Water Resources Research 53.12 (2017): 10802-10823.
function x_new = TEAD_function(obj,A, strategy)
% Details: Starting function for TEAD sampling.
%
% inputs:
% obj - Ordinary kriging class object
% A - Definition of parametric space
% strategy - Optimization strategy to be used
%
% outputs:
% x_new - New found sample point

n = size(obj.X,2);
lb = A(1,:);
ub = A(2,:);
% Obtain gradient information
delta_s = central_difference_gradient(obj);

% Generate candidate points
number_candidate_points = 20000*n;
x_cand = lhs_scaled(number_candidate_points,lb,ub);

% Obtain nearest neighbor
[Idx,D] = knnsearch(obj.X, x_cand);

% Obtain weight
Lmax = max(max(pdist2(obj.X, obj.X)));
w = ones(number_candidate_points,1) - D./Lmax;

% Conduct first order Taylor expansion
%t = zeros(number_candidate_points,1);
%s = zeros(number_candidate_points,1);
for i=1:number_candidate_points
    g = obj.X(Idx(i,1),:) - x_cand(i,:);
    t(i,:) = obj.Y(Idx(i,1))+ delta_s(Idx(i,1),:)*g';
    s(i,:) = obj.predict(x_cand(i,:));
    Res(i,1) = norm(s(i,:)- t(i,:));
end

% Obtain residual
%             Res = norm(s-t);

% Compute J
J = D/max(D) + w.* (Res / max(Res));

% Find max J
[~,idx_max] = max(J);

% New point
x_new = x_cand(idx_max,:);
end



function delta_s = central_difference_gradient(obj)
% Details: Find gradient with cenral difference scheme
%
% inputs:
% obj - Ordinary kriging class object
%
% outputs:
% delta_s - Array of approx. gradient values


h = 1e-4;
n = size(obj.X,2);
delta_s = zeros(obj.m,n);
for i=1:obj.m
    X_ip1 = obj.X(i,:)+h;
    X_im1 = obj.X(i,:)-h;
    
    Y_ip1 = obj.predict(X_ip1);
    Y_im1 = obj.predict(X_im1);
    delta_s(i,:) = (Y_ip1- Y_im1)/(2*h);
end
end

