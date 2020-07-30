function [output] = chooseSamplingMethod(M, x, y,A_sampling, number_of_adaptive_iterations,max_iteration, opti_strategy,methodID)
%%
% Details: Defines the chosen adaptive sampling techniques
%
% inputs:
% M - response function
% x - samples in parametric space
% y - observations
% A_sampling - parameter space
% number_of_adaptive_iterations - maximum number of iterations
% max_iteration - number of repetitions
% class_limit - Sets limit value to distinguish classes in 2d
%
% outputs:
% output - adaptive method, stored metamodels, final errors, single error

%% Choose autocorrelation function
%addpath('Autocorrelation_functions')
% Matern 3/2 Autocorrelation
af = @Matern32_matrix;

%% Smart Sampling Algorithm (SSA)
% Garud, Sushant Suhas, Iftekhar A. Karimi, and Markus Kraft.
%  "Smart sampling algorithm for surrogate model development." Computers & Chemical Engineering 96 (2017): 103-114
adaptive_methods{1} ='SSA';

%% Cross-Validation-Voronoi (CVVOR)
% Xu, Shengli, et al. "A robust error-pursuing sequential sampling approach for global metamodeling based on voronoi diagram and cross validation."
% Journal of Mechanical Design 136.7 (2014): 071009.
adaptive_methods{2} ='CVVor';

%% ACcumulative Error (ACE)
% Li, Genzi, Vikrant Aute, and Shapour Azarm. "An accumulative error based adaptive design of experiments for offline metamodeling."
% Structural and Multidisciplinary Optimization 40.1-6 (2010): 137.
adaptive_methods{3} ='ACE';

%% MC-intersite-proj-th (MIPT)
% Crombecq, Karel, Eric Laermans, and Tom Dhaene. "Efficient space-filling and non-collapsing sequential design strategies for simulation-based modeling."
% European Journal of Operational Research 214.3 (2011): 683-696.
adaptive_methods{4} ='MIPT';

%% LOLA-Voronoi (LOLA)
% Crombecq, Karel, et al. "A novel hybrid sequential design strategy for global surrogate modeling of computer experiments."
% SIAM Journal on Scientific Computing 33.4 (2011): 1948-1974.
adaptive_methods{5} ='LOLA';

%% Adaptive Maximum Entropy (AME)
% Liu, Haitao, et al. "An adaptive Bayesian sequential sampling approach for global metamodeling."
% Journal of Mechanical Design 138.1 (2016): 011404.
adaptive_methods{6} ='AME';

%% Maximizing Expected Prediction Error (MEPE)
%Liu, Haitao, Jianfei Cai, and Yew-Soon Ong. "An adaptive sampling approach for kriging metamodeling by maximizing expected prediction error."
%Computers & Chemical Engineering 106 (2017): 171-182.
adaptive_methods{7} ='MEPE';

%% Mixed  Adaptive  Sampling  Algorithm (MASA)
% Eason, John, and Selen Cremaschi. "Adaptive sequential sampling for surrogate model generation with artificial neural networks."
% Computers & Chemical Engineering 68 (2014): 220-232.
adaptive_methods{8} ='MASA';

%% Weighted Accumulative Error (WAE)
% Jiang, Ping, et al. "A novel sequential exploration-exploitation sampling strategy for global metamodeling."
% IFAC-PapersOnLine 48.28 (2015): 532-537.
adaptive_methods{9} ='WAE';

%% Sampling with Lipschitz Criterion (LIP)
% Lovison, Alberto, and Enrico Rigoni. "Adaptive sampling with a Lipschitz criterion for accurate metamodeling."
% Communications in Applied and Industrial Mathematics 1.2 (2011): 110-126.
adaptive_methods{10} ='LIP';

%% Taylor expansion-based adaptive design (TEAD)
% Mo, Shaoxing, et al. "A Taylor expansion‐based adaptive design strategy for global surrogate modeling with applications in groundwater modeling."
% Water Resources Research 53.12 (2017): 10802-10823.
adaptive_methods{11} ='TEAD';

%% Space-Filling Cross Validation Tradeoff (SFCVT)
% Aute, Vikrant, et al. "Cross-validation based single response adaptive design of experiments for Kriging metamodeling of deterministic computer simulations."
% Structural and Multidisciplinary Optimization 48.3 (2013): 581-605.
adaptive_methods{12} ='SFVCT';

%% Expected improvement (EI)
% Jones, Donald R., Matthias Schonlau, and William J. Welch. "Efficient global optimization of expensive black-box functions."
% Journal of Global optimization 13.4 (1998): 455-492.
adaptive_methods{13} ='EI';

%% Expected improvement for global fit (EIGF)
% Lam, Chen Quin. "Sequential adaptive designs in computer experiments for response surface model fit."
% Diss. The Ohio State University, 2008.
adaptive_methods{14} ='EIGF';



%% TPLHD
% Liao, Xiaoping, et al. "A fast optimal latin hypercube design for Gaussian process regression modeling."
% Third International Workshop on Advanced Computational Intelligence. IEEE, 2010.
adaptive_methods{15} ='TPLHD';

%% Obtains the error from the initial samples
adaptive_methods{16} ='Initial_error';

%% Jin's Cross validation approach (CVA)
% Jin, Ruichen, Wei Chen, and Agus Sudjianto. "On sequential sampling for global metamodeling in engineering design."
% ASME 2002 International Design Engineering Technical Conferences and Computers and Information in Engineering Conference. American Society of Mechanical Engineers, 2002.
adaptive_methods{17} ='Jin_CV';

%% Maximin Distance design (MSD)
% Johnson, Mark E., Leslie M. Moore, and Donald Ylvisaker. "Minimax and maximin distance designs."
% Journal of statistical planning and inference 26.2 (1990): 131-148.
adaptive_methods{18} ='MSD';

%% Weighted expected improvement (WEI)
% Jones, Donald R., Matthias Schonlau, and William J. Welch. "Efficient global optimization of expensive black-box functions."
% Journal of Global optimization 13.4 (1998): 455-492.
adaptive_methods{19} ='WEI';

% Choose one or multiple sampling techniques by setting j value. Can be
% parallelized via parfor.
for j=methodID:methodID
    mean_errors = zeros(number_of_adaptive_iterations,5);
    stored_metamodels = {};
    final_errors = {};
    single_errors = {};
    for i=1:max_iteration
        warning('off','all')
        St = ['Computation of ', adaptive_methods{j},'   Iteration number: ', num2str(i), ' of ', num2str(max_iteration)];
        disp(St)
        
        [stored_metamodels{i}, final_errors{i}, single_errors{i}] = initial_metamodel(M,A_sampling,adaptive_methods{j}, x, y,number_of_adaptive_iterations, opti_strategy,i, af);
        temp = single_errors{i}(2);
        mean_errors = mean_errors + temp{1}.error_data.Variables;
        
    end
    mean_errors = mean_errors/max_iteration;
    output{j,1}= {adaptive_methods{j}, stored_metamodels, final_errors,single_errors, mean_errors};
    
    result = output{j,1};
    ST = ['Sol_', adaptive_methods{j},'.mat'];
    save(ST,'result');
    
end


end

