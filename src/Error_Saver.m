classdef Error_Saver
    % Details: Utility class that defines and saves the error values
    %
    
    properties
        error_data;
    end
    
    methods
        function obj = Error_Saver()
            obj.error_data =  table;
            
        end
        
        function obj = update(obj,it,X,Y)
            nMAE_val = MeanAE(X,Y);
            nRMAE_val = RMAE(X,Y);
            nRMSE_val = RMSE(X,Y);
            R_sq_val = R_sq(X,Y);
            i= size(obj.error_data,1);
            obj.error_data(i+1,:)= {it ,nMAE_val , nRMAE_val, nRMSE_val, R_sq_val };
            if i==0
                obj.error_data.Properties.VariableNames = {'Iterator','MAE','RMAE','RMSE', 'R_sq'};
            end
        end
        
        
        function plot_data(obj)
            data = obj.error_data.Variables;
            Iterator = data(:,1);
            MeanAE = data(:,2);
            RMAE = data(:,3);
            RMSE = data(:,4);
            R_sq = data(:,5);
            
            figure
            plot(Iterator, MeanAE, 'LineWidth', 2.0); hold on;
            plot(Iterator, RMAE, 'LineWidth', 2.0); hold on;
            plot(Iterator, RMSE, 'LineWidth', 2.0); hold on;
            plot(Iterator, R_sq, 'LineWidth', 2.0); hold off;
            legend('MAE','MeanAE','RMSE', 'R^2');
            xlabel('Iterations');
            
        end
        
    end
    
    
end

function error_val = standard(X)
% root mean squared error
m = numel(X);
mean_response = (1/m)*(sum(X));
error_val = sqrt((1/(m))*(sum((X-mean_response).^2)));
end

function error_val = RMAE(X,Y)
% relative maximum absolute error
error_val = max(abs(X-Y)); %/standard(X);

error_val = error_val/(max(Y)-min(Y));
end


function error_val = MeanAE(X,Y)
% mean absolute error
error_val = mean(abs(X-Y));

error_val = error_val/(max(Y)-min(Y));
end


function error_val = RMSE(X,Y)
% root mean squared error
error_val = sqrt(mean(((X-Y).^2)));

error_val = error_val/(max(Y)-min(Y));
end


function error_val = R_sq(X,Y)
% R_sq score
mean_response = mean(X);
MSE_val = (sum((X-Y).^2));

divisor = sum((X-mean_response).^2);

error_val = 1-(MSE_val/divisor);
end