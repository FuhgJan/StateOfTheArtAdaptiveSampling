classdef OK_model
    % Details: Class that defines an ordinary kriging surrogate model
    properties
        % Autocorrelation function
        auto_correlation_function;
        % Input samples
        X;
        % Output corresponding to inputs values
        Y;
        % Optimization technique to find hyperparamters
        theta_opti_technique;
        % Number of input samples
        m;
        % One-vector definition
        F;
        % Hyperparameter
        theta;
        % Autocorrelation matrix
        R;
    end
    
    
    methods
        %Constructor
        function obj=OK_model(af,x,y,opti, givenTheta)
            % Details: Constructor for ordinary Kriging class
            %
            % inputs:
            % af - Function handle for autocorrelation function
            % x - Input sample values
            % y - Output sample values
            % opti - optimization strategy for hyoeroarameters
            % givenTheta - (optional) Define ordinary Kriging modek with specific 
            % Hyperparameter values 
            %
            % outputs:
            % obj - Ordinary kriging class
            
            obj.auto_correlation_function = af;
            obj.X = x;  % x = [x1 y1 z1; x2 y2 z2]
            obj.Y = y;
            obj.theta_opti_technique = opti;
            
            obj.m = size(x,1);
            obj.F = ones(size(1:obj.m))';
            
            if nargin<5
                obj.theta = optimize_theta(obj);
            else
                obj.theta = givenTheta;
            end
            
            
            
            obj.R = compute_R(obj, obj.theta);
        end
        
        
        
        
        
        function R = compute_R(obj, theta)
            % Details: Obtain autocorrelation matrix
            %
            % inputs:
            % obj - Ordinary kriging class object
            % theta - Hyperparameters
            %
            % outputs:
            % R - Autocorrelation matrix
            
            R =  obj.auto_correlation_function(obj.X,obj.X, theta);
            
            
            if sum(isnan(R(:)))
                disp('NAN values')
            end
 
        end
        
        

        function beta_hat = compute_beta_hat(obj,R)
            % Details: Obtain a priori mean
            %
            % inputs:
            % obj - Ordinary kriging class object
            % R - Autocorrelation matrix
            %
            % outputs:
            % sigma_sq_hat - A priori mean
            beta_hat = ((obj.F'*(R\obj.F))\obj.F') * (R\obj.Y);
        end
        
        function sigma_sq_hat = compute_sigma_sq_hat(obj,R,beta_hat)
            % Details: Obtain a priori variance
            %
            % inputs:
            % obj - Ordinary kriging class object
            % R - Autocorrelation matrix
            % beta_hat - A priori mean 
            %
            % outputs:
            % sigma_sq_hat - A priori variance
            sigma_sq_hat = (1/obj.m) *(obj.Y- obj.F*beta_hat)' * (R\(obj.Y- obj.F*beta_hat));
        end
        
        
        function r0 = compute_r0(obj,theta,x0)
            % Details: Obtain r0 autocorrelation vector
            %
            % inputs:
            % obj - Ordinary kriging class object
            % theta - Hyperparameters
            % x0 - Input value 
            %
            % outputs:
            % r0 - r0 autocorrelation vector
            r0= obj.auto_correlation_function(obj.X,x0,theta);
            
        end
        
        function mu_hat = compute_mu_hat(obj,R,beta_hat,x0,theta)
            % Details: Obtain the prediction mean
            %
            % inputs:
            % obj - Ordinary kriging class object
            % R - Autocorrelation matrix
            % beta_hat - A priori mean
            % x0 - Input value to obtain the mean for
            % theta - Hyperparameters
            %
            % outputs:
            % mu_hat - A posteriori mean prediction
            
            r0 = compute_r0(obj,theta,x0);
            
            mu_hat = beta_hat + r0' * (R\(obj.Y - obj.F*beta_hat));
            
        end
        
        function sigma_Y_sq_hat = compute_sigma_Y_sq_hat(obj,sigma_sq_hat,x0,theta,R)
            % Details: Obtain the prediction variance
            %
            % inputs:
            % obj - Ordinary kriging class object
            % sigma_sq_hat - A priori variance
            % x0 - Input value to obtain variance for
            % theta - Hyperparameter value
            % R - Autocorrelation matrix
            %
            % outputs:
            % sigma_Y_sq_hat - A posteriori variance prediction
            
            r0 = compute_r0(obj,theta,x0);
            u0 = obj.F' * (R\r0) - 1;
            sigma_Y_sq_hat = sigma_sq_hat * (1 - r0' * (R\r0) + u0 * ((obj.F' * (R\obj.F))\u0));
            
            
        end
        
        function theta = optimize_theta(obj)
            % Details: Define the optimization process for the
            % hyperparameters
            %
            % inputs:
            % obj - Ordinary kriging class object
            %
            % outputs:
            % theta - Optimized hyperaparameter vector

            AA = [];
            b = [];
            Aeq = [];
            beq = [];
            n = numel(obj.X(1,:));
            %                 disp(strcat('Dimension:   ',num2str(n)));
            
            
            n = size(obj.X,2);
            
            for k=1:n
                iter =1;
                clear distance
                for i=1:obj.m
                    for j=1:obj.m
                        if ~(i == j)
                            distance(iter) = abs(obj.X(i,k) - obj.X(j,k));
                            iter = iter +1;
                        end
                    end
                end
                max_distance = max(distance);
                min_distance = min(distance);
                
                lb(k) = 0.0005*min_distance;
                if lb(k) == 0.0
                    lb(k) = 10^(-5);
                end
                ub(k) = 10*max_distance;
            end
            
            fun = @obj.computeMLE;
            theta = optimizationTools(fun,obj.theta_opti_technique,AA,b,Aeq,beq,lb,ub,[]);
            
            
        end
        
        
        function Psi = computeMLE(obj,theta)
            % Details: Define the Maximum Likelihood estimation for the
            % hyperparameters
            %
            % inputs:
            % obj - Ordinary kriging class object
            % theta - Hyperparameter input value
            %
            % outputs:
            % Psi - Value to be optimized 

            R_matrix = compute_R(obj, theta);
            beta_hat = compute_beta_hat(obj,R_matrix);
            
            sigma_sq_hat = compute_sigma_sq_hat(obj,R_matrix,beta_hat);
            
            if cond(R_matrix)> 10^7
                Psi = 100000;
            else
                Psi = 0.5 * (obj.m*log(sigma_sq_hat) + log(det(R_matrix)));
            end
        end
        
        
        
        
        function [mu_hat,sigma_Y_sq_hat] = predict(obj,x0)
            % Details: Prediction of the surrogate model for input x0
            %
            % inputs:
            % obj - Ordinary kriging class object
            % x0 - Input value
            %
            % outputs:
            % mu_hat - Mean predition output
            % sigma_Y_sq_hat - Variance prediction output

            
            beta_hat = compute_beta_hat(obj,obj.R);
            sigma_sq_hat = compute_sigma_sq_hat(obj,obj.R,beta_hat);
            for i=1:numel(x0(:,1))
                mu_hat(i) = compute_mu_hat(obj,obj.R,beta_hat,x0(i,:),obj.theta);
                sigma_Y_sq_hat(i) = compute_sigma_Y_sq_hat(obj,sigma_sq_hat,x0(i,:),obj.theta,obj.R);
                
                alpha2 = 0.05;
                z_0p95_u(i) = mu_hat(i) + norminv(1- (alpha2/2)) *sqrt(sigma_Y_sq_hat(i));
                z_0p95_l(i) = mu_hat(i) - norminv(1- (alpha2/2)) *sqrt(sigma_Y_sq_hat(i));
                
            end
            
            
        end
        

        function x_new = adaptive_sampling(obj,method,A,strategy)
            % Details: Choosing the right function to create new sample based on
            % user input
            %
            % inputs:
            % obj - Ordinary kriging class object
            % method - String defining the adaptive technique
            % A - Definition of parametric space
            % strategy - Optimization technique to be used
            %
            % outputs:
            % x_new - New found sample point
            
            addpath('adaptive_techniques')
            if strcmp(method,'SSA')
                x_new = SSA_function(obj,A,strategy);
            elseif strcmp(method,'CVVor')
                x_new = CVVor_function(obj,A);
            elseif strcmp(method,'ACE')
                x_new = ACE_function(obj,A);
            elseif strcmp(method,'MIPT')
                x_new = MIPT_function(obj,A);
            elseif strcmp(method,'LOLA')
                x_new = LOLA_function(obj,A);
            elseif strcmp(method,'AME')
                x_new = AME_function(obj,A,strategy);
            elseif strcmp(method,'MEPE')
                x_new = MEPE_function(obj,A,strategy);
            elseif strcmp(method,'MASA')
                x_new = MASA_function(obj,A);
            elseif strcmp(method,'SFVCT')
                x_new = SFVCT_function(obj,A,strategy);
            elseif strcmp(method,'WAE')
                x_new = WAE_function(obj,A,strategy);
            elseif strcmp(method,'TEAD')
                x_new =TEAD_function(obj,A);
            elseif strcmp(method,'LIP')
                x_new = LIP_function(obj,A,strategy);
            elseif strcmp(method,'EI')
                x_new = EI_function(obj,A,strategy);
            elseif strcmp(method,'EIGF')
                x_new = EIGF_function(obj,A,strategy);
                
            elseif strcmp(method,'WEI')
                x_new = WEI_function(obj,A);
            elseif strcmp(method,'MSD')
                x_new = MSD_function(obj,A);
            elseif strcmp(method,'Jin_CV')
                x_new = Jin_CV_function(obj,A,strategy);
            elseif strcmp(method,'QBC_Jackknifing')
                x_new = QBC_Jackknifing_function(obj,A);
            end
            
        end
        
        
    end
    
    
    
    
end









