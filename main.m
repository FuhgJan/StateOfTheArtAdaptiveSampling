% State-of-the-art and Comparative Review on Adaptive
% Sampling Methods for Ordinary Kriging
clear all;
close all;
%% Essential imports
addpath(genpath('src'))
warning('off', 'all')
global plotFlag

%% Start input prompt
[ methodID, benchmarkId, numberSamples, numberRepetitions, Vis ]= run_input_prompts();

if strcmp(Vis,'y')
    plotFlag =1;
elseif strcmp(Vis,'n')
    plotFlag = 0;
end

%% Call benchmark function 
[ y, lb, ub ,x, M  ] = call_benchmarkFunctions( benchmarkId );

%%
A_sampling =[lb';ub'];
% Scale parameter samples to unity
x = scale_vector_to_unity(lb, ub, x);

% Number of adaptive samples
Number_of_benchmark_iterations = numberSamples;

% Optimization strategy for sampling: 
% 'AN': Simulated annealing
% 'GA': Genetic algorithm
% 'fmincon': MATLAB fmincon
% 'patternsearch': MATLAB patternsearch algorithm
% 'MS': Multistart algorithm
Sampling_optimization_strategy = 'MS';

% Number of repetitive iterations
max_iteration = numberRepetitions;




%% Start process
[output] = chooseSamplingMethod(M,x, y, A_sampling, Number_of_benchmark_iterations,max_iteration,Sampling_optimization_strategy,methodID);

save('OutputData.mat','output')
