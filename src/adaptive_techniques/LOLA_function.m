%% LOLA-Voronoi (LOLA)
% Crombecq, Karel, et al. "A novel hybrid sequential design strategy for global surrogate modeling of computer experiments."
% SIAM Journal on Scientific Computing 33.4 (2011): 1948-1974.
function x_new = LOLA_function(obj,A)
%%
% Details: Obtain new sample point via LOLA sampling algorithm
%
% inputs:
% obj - Ordinary kriging class object
% A - definition of parametric space
%
% outputs:
% x_new - New sample point


addpath('help_functions')
lb = A(1,:);
ub = A(2,:);

% Obtain volume estimates
C = randomVoronoi(obj.X,lb,ub);
Vol = zeros(obj.m,1);
for I_sample_P=1:obj.m
    Vol(I_sample_P) = size(C{I_sample_P,2},1);
end
abs_Vol= sum(Vol);
Vol = (1/abs_Vol)*Vol;


d = numel(lb);
no_neighbors = 2 * d;

for I_sample_P=1:obj.m
    
    % Find neighborhood
    p_ref = obj.X(I_sample_P,:);
    y_ref = obj.Y(I_sample_P);
    [p_neighbors, best_indexs] = find_best_p_neighbors(obj, p_ref, no_neighbors);
    data_neighbors{I_sample_P} =best_indexs;
    y_neighbors = obj.Y([best_indexs],:);
    
    % Gradient estimation
    Pr = zeros(no_neighbors, d);
    for i=1:d
        for j=1:no_neighbors
            Pr(j,i) = p_neighbors(j,i)-p_ref(i);
        end
    end
    g = linsolve(Pr,y_neighbors);
    
    % Obtain nonlinearity measure
    E(I_sample_P) =0.0;
    for j=1:no_neighbors
        E(I_sample_P) = E(I_sample_P)+ abs( y_neighbors(j,:)  - (y_ref + g' *(p_neighbors(j,:)  - p_ref)'));
    end
    
    
end

% Obtain H
Esum = sum(E) ;
H = zeros(obj.m,1);
for I_sample_P=1:obj.m
    H(I_sample_P) = Vol(I_sample_P) + (E(I_sample_P) / Esum);
end

[~,I_H] = max(H);

% Obtain new point with distance constraint
maxdistance = - inf;

p_ref_and_neighbors = [obj.X(I_H,:); obj.X([data_neighbors{I_H}],:)];
for i=2:size(C{I_H,2},1)
    cumDistance = 0;
    for j=1:size(p_ref_and_neighbors,1)
        cumDistance = cumDistance + norm(C{I_H,2}(i,:) - p_ref_and_neighbors(j,:));
    end
    if cumDistance > maxdistance
        x_new = C{I_H,2}(i,:);
    end
end



end



function [p_neighbors, best_indexs] =find_best_p_neighbors(obj, p_ref, no_neighbors)
%%
% Details: Find the best neighborhod points around sample p_ref
%
% inputs:
% obj - Ordinary kriging class object
% p_ref - Reference point to find best neighbors for
% no_neighbors - number of neighbors to find
%
% outputs:
% p_neighbors - Found neighborhood points
% best_indexs - Indices of the p_neighbors


d = size(p_ref,2);

k = find(ismember(obj.X ,p_ref,'rows'));



%             X_P = norm(p_ref.*ones(size(obj.X)) , obj.X);

for i=1:size(obj.X,1)
    X_P(i,1) = norm(p_ref - obj.X(i,:));
    if X_P(i,1) == 0
        X_P(i,1) =100;
    end
end

index_close = [];
a = 0.15;
while numel(index_close) < no_neighbors
    index_close = find(X_P < a*d);
    a = a+0.05;
    
end


C = nchoosek(index_close,no_neighbors);

C_wo_k = C;



Smax = -inf;
best_indexs = 0;
for i=1:size(C_wo_k,1)
    C = 0;
    for j=1:size(C_wo_k,2)
        C = C + norm(obj.X(C_wo_k(i,j),:));
    end
    C = (1/no_neighbors) * C;
    
    if d ==1
        pr1 = obj.X(C_wo_k(i,1),:);
        pr2 = obj.X(C_wo_k(i,2),:);
        R_val = 1 - (abs(pr1+pr2)/(abs(pr1)+abs(pr2)+abs(pr1 - pr2)));
    else
        A = 0;
        for ii=1:size(C_wo_k,2)
            min_distance = inf;
            for jj=1:size(C_wo_k,2)
                if ~ (ii==jj)
                    distance = norm(obj.X(C_wo_k(i,ii),:) - obj.X(C_wo_k(i,jj),:));
                    if distance < min_distance
                        min_distance = distance;
                    end
                end
            end
            A = A + min_distance;
            
            
        end
        A = (1/no_neighbors) * A;
        R_val = A/(sqrt(2) * C);
    end
    
    S = R_val/C;
    if S > Smax
        Smax = S;
        best_indexs = C_wo_k(i,:);
    end
end
p_neighbors = obj.X([best_indexs],:);

end