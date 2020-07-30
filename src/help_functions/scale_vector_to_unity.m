function scaled_value = scale_vector_to_unity(a,b,x)
% b upper bound , a lower bound
n = size(x,1);
d = size(x,2);
scaled_value = zeros(n,d);
if (numel(a) ~= d) || (numel(b) ~= d)
    error('Scaling to unity not possible.')
end
for i=1:n
    for j=1:d
scaled_value(i,j) = (1/(b(j)-a(j))) * (x(i,j)-a(j));
    end
end

end


