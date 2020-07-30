function seed = reshapeSeed(seed , ns, npStar, ndStar, nv)
% inputs: seed - initial seed design (points within 1 and ns)
% ns - number of points in the seed design
% npStar - number of points of the Latin hypercube (LH)
% nd - number of divisions of the LH
% nv - number of variables in the LH
% outputs: seed - seed design properly scaled
if ns == 1
    seed = ones(1, nv); % arbitrarily put at the origin
else
    uf = ns*ones(1, nv);
    ut = ( (npStar / ndStar) - ndStar*(nv - 1) + 1 )*ones(1, nv);
    rf = uf - 1;
    rt = ut - 1;
    a = rt./rf;
    b = ut - a.*uf;
    for c1 = 1 : ns
        seed(c1,:) = a.*seed(c1,:) + b;
    end
    seed = round(seed); % to make sure that the numbers are integer
end
return

