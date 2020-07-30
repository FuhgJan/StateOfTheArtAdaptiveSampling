function S = scaled_TPLHD(n,lb,ub)

S = tplhsdesign(n, numel(lb), 1, 1)./n;
% S = [zeros(size(S(1,:))) ;S];
for i=1:numel(lb)
    c = lb(i);
    d = ub(i);
    
    S(:,i) = scale(c,d,S(:,i));
end

end

