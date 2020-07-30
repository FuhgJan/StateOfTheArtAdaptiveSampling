function scaled_value = scale_vector_from_unity(lb,ub,x)
% lb lower, ub upper
n = size(x,1);
d = size(x,2);
scaled_value = zeros(n,d);
if (numel(lb) ~= d) || (numel(ub) ~= d)
    error('Scaling to unity not possible.')
end
for i=1:n
    for j=1:d
scaled_value(i,j) = lb(j) + (ub(j)-lb(j)) * x(i,j);
    end
end
end


