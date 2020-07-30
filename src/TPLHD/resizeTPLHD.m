function X = resizeTPLHD(X, npStar, np, nv)
% inputs: X - initial Latin hypercube design
% npStar - number of points in the initial X
% np - number of points in the final X
% nv - number of variables
% outputs: X - final X, properly shrunk
center = npStar*ones(1,nv)/2; % center of the design space
% distance between each point of X and the center of the design space
distance = zeros(npStar, 1);
for c1 = 1 : npStar
    distance(c1) = norm( ( X(c1,:) - center) );
end
[dummy, idx] = sort(distance);
X = X( idx(1:np), : ); % resize X to np points
% re-establish the LH conditions
Xmin = min(X);
for c1 = 1 : nv
    % place X in the origin
    X = sortrows(X, c1);
    X(:,c1) = X(:,c1) - Xmin(c1) + 1;
    % eliminate empty coordinates
    flag = 0;
    while flag == 0;
        mask = (X(:,c1) ~= ([1:np]'));
        flag = isequal(mask,zeros(np,1));
        X(:,c1) = X(:,c1) - (X(:,c1) ~= ([1:np]'));
    end
end
return
