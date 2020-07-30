%% Sampling with Lipschitz Criterion (LIP)
% Lovison, Alberto, and Enrico Rigoni. "Adaptive sampling with a Lipschitz criterion for accurate metamodeling."
% Communications in Applied and Industrial Mathematics 1.2 (2011): 110-126.
function x_new = LIP_function(obj,A, strategy)
% Details: Starting function for LIP sampling.
%
% inputs:
% obj - Ordinary kriging class object
% A - Definition of parametric space
% strategy - Optimization strategy to be used
%
% outputs:
% x_new - New found sample point

d = size(obj.X,2);
lb = A(1,:);
ub = A(2,:);

% Delaunay triangulation of current sample points
T = delaunayn(obj.X);

% Find the maximum Lipschitz constant for each candidate point
max_Lips = zeros(obj.m,1);
for i=1:obj.m
    max_Lips(i)= find_max_Lip_value(obj,i,T);
end


% Generate candidate points with OLHD
m_candidate=5000*d;
x_cand=lhs_scaled(2*m_candidate,lb,ub);


% Obtain the merit function for each candidate point and find
% the candidate with the highest merit
merit = 0;

for i=1:size(x_cand,1)
    [Idx,radius] = knnsearch(obj.X, x_cand(i,:));
    merit_temp = max_Lips(Idx)*radius;
    if merit_temp > merit
        merit = merit_temp;
        x_temp = x_cand(i,:);
    end
end

% New sample point is candidate point with maximum merit
x_new = x_temp;

end
function adj_nodes = find_adj_Delaunay_nodes(obj, index, T)
% Details: Obtain adjacent nodes in Delaunay triangulation
%
% inputs:
% obj - Ordinary kriging class object
% index - Sample point index
% T - Delaunay tringulation definition
%
% outputs:
% adj_nodes - Adjacent nodes

[neighbor_index,~] = find(T==index);

neighbors = T(neighbor_index,:);
adj_nodes = setdiff(unique(neighbors), index);

end

function max_Lip = find_max_Lip_value(obj,index,T)
% Details: Find the maximum Lipschitz constant of the sample point given
% by the index
%
% inputs:
% obj - Ordinary kriging class object
% index - Sample point index
% T - Delaunay tringulation definition
%
% outputs:
% max_Lip - Maximum Lipschitz constant

% Obtain adjacent nodes in Delaunay triangulation
adj_nodes = find_adj_Delaunay_nodes(obj, index, T);
for i=1:numel(adj_nodes)
    L(i) = norm(obj.Y(index)-obj.Y(adj_nodes(i)))/ norm(obj.X(index,:) -  obj.X(adj_nodes(i),:)  );
end

max_Lip = max(L);

end


