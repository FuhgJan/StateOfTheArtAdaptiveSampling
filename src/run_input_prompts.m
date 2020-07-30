function [ methodID, benchmarkId, numberSamples, numberRepetitions,Vis ] = run_input_prompts()
% Details: Utility function that runs input prompt
%
% inputs:
%
% outputs:
% methodID - ID of sampling strategy
% benchmarkId - ID of benchmark test
% numberSamples - Number of samples to add
% numberRepetitions - Number of repetitions of the sampling procedure
% Vis - Flag for visualization of output (only 1D and 2D)

clc
disp('Choose an adaptive technique.')
prompt = '1.  Smart Sampling Algorithm (SSA) \n2.  Cross-Validation-Voronoi (CVVOR) \n3.  ACcumulative Error (ACE) \n4.  MC-intersite-proj-th (MIPT) \n5.  LOLA-Voronoi (LOLA) \n6.  Adaptive Maximum Entropy (AME) \n7.  Maximizing Expected Prediction Error (MEPE) \n8.  Mixed Adaptive Sampling Algorithm (MASA) \n9.  Weighted Accumulative Error (WAE) \n10. Sampling with Lipschitz Criterion (LIP) \n11. Taylor expansion-based adaptive design (TEAD) \n12. Space-Filling Cross Validation Tradeoff (SFCVT) \n13. Expected improvement (EI) \n14. Expected improvement for global fit (EIGF)   \n \nEnter number and press enter:   ';
methodID = input(prompt);

clc
disp('Choose a dimension for the benchmark.')
prompt = '1.  1D \n2.  2D \n3.  3D \n4.  4D \n5.  5D \n6.  6D \n \nEnter number and press enter:   ';
benchDim = input(prompt);
prompt = '\n \nEnter number and press enter:   ';

clc
disp('We refer to the documentation /docs/Benchmark_Tests.pdf for references for all functions.')
if benchDim==1

    disp('One dimensional benchmark cases are:')
    ST = {' P1 : Single Hump function',' P2 : Hump Function',' P3 : Gramacy & Lee Function',' P4 : Adjusted Gramacy & Lee Function', ' P5 : Perm 0,1 function', ' P6 : Damped Cosinus function', ' P7 : Exploitation function'};
    for i=1:numel(ST)
       StOut = [num2str(i),'.  ',  ST{i}];
       disp(StOut);
    end

    
    benchDim1  = input(prompt);
    benchmarkId = benchDim1;
    
    method = ST{benchDim1};
elseif benchDim == 2

    disp('Two dimensional benchmark cases are:')

    ST = {' P8 : Michalewicz function', ' P9 : Drop-Wave function', ' P10: Booth function', ' P11: Bohachevsky function', ' P12: Branin function', ' P13: Franke function', ' P14: Rosenbrock function', ' P15: Six-Hump Camel function' , ' P16: Rastrigin function', 'P17: Griewank function'};
    for i=1:numel(ST)
       StOut = [num2str(i),'.  ',  ST{i}];
       disp(StOut);
    end    
    benchDim2  = input(prompt);
    benchmarkId = benchDim2 + 7;  
    
    method = ST{benchDim2};
elseif benchDim == 3
 
    disp('Three dimensional benchmark cases are:')
    
    ST = {' P18: Sphere 3D function', ' P19: Hartman 3D function', ' P20: Ishigami function'};
    for i=1:numel(ST)
       StOut = [num2str(i),'.  ',  ST{i}];
       disp(StOut);
    end   
    benchDim3  = input(prompt);
    benchmarkId = benchDim3 + 17; 
    
    method = ST{benchDim3};
elseif benchDim == 4

    disp('Four dimensional benchmark cases are:')
    ST = {' P21: Sphere 4D function',' P22: Dixon-Price function'};
    for i=1:numel(ST)
       StOut = [num2str(i),'.  ',  ST{i}];
       disp(StOut);
    end   
    
    benchDim4  = input(prompt);
    benchmarkId = benchDim4 + 20; 
    
    method = ST{benchDim4};
elseif benchDim == 5

    disp('Five dimensional benchmark cases are:')
    ST = {' P23: Sphere 5D function'};
    for i=1:numel(ST)
       StOut = [num2str(i),'.  ',  ST{i}];
       disp(StOut);
    end   
    
    benchDim5  = input(prompt);
    benchmarkId = benchDim5 + 22;   
    
    method = ST{benchDim5};
elseif benchDim == 6

    disp('Six dimensional benchmark cases are:')

    ST = {'Hartmann 6D function'};
    for i=1:numel(ST)
       StOut = [num2str(i),'.  ',  ST{i}];
       disp(StOut);
    end   
    benchDim6  = input(prompt);
    benchmarkId = benchDim6 + 23;  
    
    method = ST{benchDim6};
end

if benchmarkId<=17
 clc
ST = ['Do you want to see a visualization of the sampling process (y/n)?'];
disp(ST);
prompt = '\n \nEnter yes or no (y/n):   ';
Vis = input(prompt,'s');   
else
    Vis = 'n';
end

[ ~, ~, ~ ,init_x, ~  ] = call_benchmarkFunctions( benchmarkId );
numberInit = size(init_x,1);
clc
ST = ['How many samples do you want to add from an intial: ', num2str(numberInit)];
disp(ST);
prompt = '\n \nEnter number and press enter:   ';
numberSamples = input(prompt);

clc
disp('How many repitions of the sampling process would you like to run.');
prompt = '\n \nEnter number and press enter:   ';
numberRepetitions = input(prompt);
clc

ST = ['Running benchmark test: ', method];
disp(ST);
end

