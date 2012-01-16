function [ adjustModelSet ] = getModelParameters(modelSet, variables, responses)
%GETMODPARAM estimates optimal model parameters for given set of models
%
% [ adjustModelSet ] = getModParam( modelSet, variables, responses )
% 
% input parameters:
% modelSet - set of non-adjusted models
% variables [m, n] - variables matrix
% responses [m, 1] - responses vector

adjustModelSet = modelSet; % initialize models
for i = 1:size(modelSet, 2)
    initialParameter = cell2mat(modelSet(i).parameter);
    % initialParameter = rand(size(cell2mat(modelSet(i).parameter)));
    for j = 1:size(modelSet(i).parameter, 2)
        if (j ~= 1)
            modelSet(i).distribution(j) = modelSet(i).distribution(j - 1) ...
                                       + size(modelSet(i).parameter{j}, 2);
        else
            modelSet(i).distribution(j) = size(modelSet(i).parameter{j}, 2);
        end    
    end    
    modelParameter = ...
       nlinfit(variables, responses, ...
               @(parameter, variables)calcMod2(parameter, modelSet(i), variables), ...
               initialParameter);
%     modelParameter = fminsearch(@(parameter)calcQual2(modelSet(i), variables, responses, parameter), ...
%                                 initialParameter);       
%     modelParameter = ...
%        lsqnonlin(@(parameter, variables)calcMod2(parameter, modelSet(i), variables), ...
%                initialParameter, variables, responses);
    for j = 1:size(modelSet(i).distribution, 2)
        if (j ~= 1)
            adjustModelSet(i).parameter{j} = modelParameter(modelSet(i).distribution(j - 1) + 1: ...
                                                            modelSet(i).distribution(j));
        else
            adjustModelSet(i).parameter{j} = modelParameter(1:modelSet(i).distribution(j));
        end    
    end
%     if (mod(i, 10) == 0)
%         disp(i);
%     end    
end



end

