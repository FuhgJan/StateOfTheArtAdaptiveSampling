function S = scale_rand(n,lb,ub)


S = rand(n,numel(lb));
for i=1:numel(lb)
    c = lb(i);
    d = ub(i);
    
    S(:,i) = scale(c,d,S(:,i));
end
end

