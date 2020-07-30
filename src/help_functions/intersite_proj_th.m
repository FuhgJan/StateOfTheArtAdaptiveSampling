function val = intersite_proj_th(dmin, X,p)
% intersite proj TH method

for i=1:size(X,1)
    if norm((X(i,:) - p),-inf) < dmin
        val =0;
    end
end
val = inf;
for i=1:size(X,1)
    calc = norm(X(i,:) - p);
    if calc < val
        val = calc;
    end
end
end