function x_opti = optimizationTools(fun,strategy,AA,b,Aeq,beq,lb,ub,nonlcon)
% Details: Utility function that connects to different matlab optimization schemes
%
% inputs:
% fun - Function handler for optimizable function
% strategy - Optimization strategy
% AA - Linear inequality matrix
% b - Right hand side vector of linear inequality
% Aeq - Linear equality matrix
% beq - Linear equality right hand side
% lb - Lower optimization bound
% ub - Uppper optimization bound
% nonlcon - Nonlinear constraint definition
%
% outputs:
% x_opti - Optimized point

addpath('help_functions')

n = numel(lb);

%% FMincon
if strcmp(strategy,'fmincon')
    options = optimoptions('fmincon','Display','none');
    addpath('help_functions')
    x0 = scale_rand(1,lb,ub);
    x_opti = fmincon(fun,x0,AA,b,Aeq,beq,lb,ub,nonlcon,options);
    
    %% Particle Swarm Optimization
elseif strcmp(strategy,'PSO')
    options = optimoptions('particleswarm','SwarmSize',1000*n,'Display','off');
    %options.HybridFcn = @fmincon;
    [x_opti] = particleswarm(fun,n,lb,ub,options);
    
    %% Genetic Algorithm
elseif strcmp(strategy,'GA')
    options = optimoptions('ga','PopulationSize',1000*n, 'Display','off','ConstraintTolerance', 10^(-6));
    %options.HybridFcn = @fmincon;
    x_opti = ga(fun,n,AA,b,Aeq,beq,lb,ub,nonlcon,options);
    
    %% Patternsearch
elseif strcmp(strategy,'patternsearch')
    options = optimoptions('patternsearch','Display','off','ConstraintTolerance', 10^(-8),'MeshTolerance', 10^(-12),'MaxIterations',1000*n);
    %options.HybridFcn = @fmincon;
    
    x_opti = patternsearch(fun,n,AA,b,Aeq,beq,lb,ub,nonlcon,options);
    
    %% Multistart algorithm
elseif strcmp(strategy,'MS')
    
    for i=1:10
        
        x0(i,:) = scale_rand(1,lb,ub);
        opts = optimoptions(@fmincon,'Algorithm','sqp','Display','none');
        
        
        problem = createOptimProblem('fmincon','objective',...
            fun,'x0',x0(i,:),'Aineq',AA,'bineq',b,'Aeq',Aeq,'beq',beq,'lb',lb,'ub',ub,'nonlcon',nonlcon,'options',opts);
        ms = MultiStart('Display', 'off');
        
        [x_opti2(i,:),f(i,1)] = run(ms,problem,20);
    end
    [~,ind] = min(f);
    x_opti = x_opti2(ind,:);
    
    
    %% Simulated annealing
elseif strcmp(strategy,'AN')
    
    options = optimoptions('simulannealbnd','Display','none','FunctionTolerance', 1e-08);
    
    for i=1:10
        x0(i,:) = scale_rand(1,lb,ub);
    
        [x_opti2(i,1), f(i,1), ~, ~]= simulannealbnd(fun,x0,lb,ub,options);
    end
    [~,ind] = min(f);
    x_opti = x_opti2(ind,:);
end
end

