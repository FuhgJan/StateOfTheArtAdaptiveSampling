%% Maximin Distance design (MSD)
% Johnson, Mark E., Leslie M. Moore, and Donald Ylvisaker. "Minimax and maximin distance designs."
% Journal of statistical planning and inference 26.2 (1990): 131-148.
function x_new = MSD_function(obj,A)
% Details: Starting function for MSD sampling.
%
% inputs:
% obj - Ordinary kriging class object
% A - Definition of parametric space
%
% outputs:
% x_new - New found sample point

k = numel(obj.theta);
alpha = obj.theta;
lb = A(1,:);
ub = A(2,:);
addpath('TPLHD')
n = obj.m*100*k;
Xc = lhsdesign_modified(n,lb,ub);

XA = [Xc; obj.X];

for i=1:size(Xc,1)
    iter =1;
    clear min_distance
    for j=1:(obj.m + size(Xc,1))
        if ~(isequal(Xc(i,:),XA(j,:)))
            min_distance(iter) = MSD_d_function(Xc(i,:),XA(j,:),obj.theta);
            iter = iter+1;
        end
    end
    distance(i) = min(min_distance);
end

[~,index] = max(distance);

x_new = Xc(index,:);
end

