function [bestModelsSet, qualityFunctional] = ...
  selectModels(newModelsSet, bestModelsSet, variables, responses)
%SELMOD selects the best models from last step models
%
% [bestModelsSet, qualityFunctional] = selectModels(newModelsSet, bestModelsSet, variables, responses)
%
% output parameters:
% bestModelsSet - best models for next step 
% qualityFunctional - quality functional minimum for the best model
%
% input parameters:
% newModelsSet - set of new models
% bestModelsSet - set of current best models
% variables [m, n] - variables matrix
% responses [m, 1] - responses vector

% get structure array size
sampleSize = size(variables, 1);
modelsNumber = size(newModelsSet, 2);
bestModelsNumber = size(bestModelsSet, 2);
complexity = 25;

modelsSet = [newModelsSet, bestModelsSet];
modelsSetSize = size(modelsSet, 2);

qualityFunctional = zeros(modelsSetSize, 1);
for modelIndex = 1:modelsSetSize
  qualityFunctional(modelIndex) = ...
    calcQual(modelsSet(modelIndex), variables, responses, modelsSet(modelIndex).parameter);
end

% sort all models at this step
[qualityFunctional, sortedIndexes] = sort(qualityFunctional); 
modelsSet = modelsSet(sortedIndexes);

% modelResponses = zeros(sampleSize, modelsNumber);
% for modelIndex = 1:modelsSetSize
%   modelResponses(:, modelIndex) = calcMod(modelsSet(modelIndex), variables);
% end

modelIndexes = true(numel(modelsSet), 1);
% check for complexity
for modelIndex = 1:modelsSetSize
  modelSize = size(modelsSet(modelIndex).parent, 2);
  modelIndexes(modelIndex) = modelSize <= complexity;
end    

% check for model similarity
modelIndexes(2:end) = modelIndexes(2:end) & ...
  ((qualityFunctional(2:end) - qualityFunctional(1:end - 1)) >= 10^(-7));

modelsSet = modelsSet(modelIndexes);
qualityFunctional = qualityFunctional(modelIndexes);
modelsSetSize = size(modelsSet, 2);

disp(sum(modelIndexes));

% select best models
bestModelsSet = modelsSet(1:min(bestModelsNumber, modelsSetSize));

qualityFunctional = qualityFunctional(1);
end