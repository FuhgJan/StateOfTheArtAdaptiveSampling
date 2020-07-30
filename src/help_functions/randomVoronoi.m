function C = randomVoronoi(X,lb,ub)
% Build Voronoi cells 

addpath('help_functions')

n_of_existing_P = size(X,1);
dimension = size(X,2);
w = 1000;

n = n_of_existing_P * dimension * w;

xn = lhs_scaled(n,lb,ub); 
C = {};

for j=1:size(X,1)
   C{j,1} =  X(j,:);
   C{j,2} =  X(j,:);
end

for i=1:size(xn,1)
        k = dsearchn(X,xn(i,:));
        C{k,2} = [C{k,2}; xn(i,:)];
end
end



