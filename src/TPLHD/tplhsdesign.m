function X = tplhsdesign(np, nv, seed, ns)
% inputs: np - number of points of the desired Latin hypercube (LH)
% nv - number of variables in the LH
% seed - initial seed design (points within 1 and ns)
% ns - number of points in the seed design
% outputs: X - Latin hypercube created using the translational
% propagation algorithm
% define the size of the TPLHD to be created first
nd = ( np/ns)^( 1/nv ); % number of divisions, nd
ndStar = ceil( nd );
if (ndStar > nd)
    nb = ndStar^nv; % it is necessary to create a bigger TPLHD
else
    nb = np/ns; % it is NOT necessary to create a bigger TPLHD
end
npStar = nb*ns; % size of the TPLHD to be created first
% reshape seed to properly create the first design
seed = reshapeSeed(seed , ns, npStar, ndStar, nv);
% create TPLHD with npStar points
X = createTPLHD(seed, ns, npStar, ndStar, nv);
% resize TPLH if necessary
npStar > np;
if (npStar > np)
    X = resizeTPLHD(X, npStar, np, nv);
end
return

