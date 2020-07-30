function X = createTPLHD(seed, ns, npStar, ndStar, nv)
% Details: Create TPLHD design
%
% inputs: 
% seed - initial seed design (points within 1 and ns)
% ns - number of points in the seed design
% npStar - number of points of the Latin hypercube (LH)
% nd - number of divisions of the LH
% nv - number of variables in the LH
%
% outputs: 
% X - Latin hypercube design created by the translational
% propagation algorithm
% we warn that this function has to be properly translated to other
% programming languages to avoid problems with memory allocation
X = seed;
d = ones(1, nv); % just for memory allocation
for c1 = 1 : nv % shifting one direction at a time
    seed = X; % update seed with the latest points added
    d(1 : (c1 - 1)) = ndStar^(c1 - 2);
    d(c1) = npStar/ndStar;
    d((c1 + 1) : end) = ndStar^(c1 - 1);
    for c2 = 2 : ndStar % fill each of the divisions
        ns = length(seed(:,1)); % update seed size
        for c3 = 1 : ns
            seed(c3,:) = seed(c3,:) + d;
        end
        X = vertcat(X, seed);
    end
end
return
