function [x_scaled]=lhs_scaled(n,lb,ub)
% Create n samples with Matlab's Latin hypercube method within bounds lb and ub 
p=numel(lb);
upper=ub-lb;
lower=lb;
M_upper=ones(n,p);
M_lower=ones(n,p);
for i=1:p
    M_upper(:,i)=ones(n,1).*upper(i);
    M_lower(:,i)=ones(n,1).*lower(i);
end
x_normalized = lhsdesign(n,p,'criterion','maximin');
x_scaled=M_upper.*x_normalized+M_lower;

end
