function modelsSet = generateModels(variables, responses, bestModel, functionList, newModelsSetSize, n)
%GENMOD generates new models from best models from previous algorithm step
%
% [model] = genMod(var, bestModel, functionList, newModelsSetSize, n)
%
% input parameters:
% variables - variables matrix
% responses - responses vector
% bestModel - set of best models from previous iteration
% functionList - cell array functions of basis functions
% newModelsSetSize - number of models for this step
% n - features number
%
% output parameters:
% modelsSet - set of generated models


%generate new model 
% generate models by exchanging
crossModels = exchangeMod(bestModel, newModelsSetSize(1));

% generate models by mutations
mutModels = modifyModel(bestModel, functionList, newModelsSetSize(2), n);

% generate new basis models
basisModels = getInitialModels(newModelsSetSize(3), functionList, size(variables, 2));

modelsSet = [crossModels, mutModels, basisModels];

modelsSetSize = size(modelsSet, 2);

qualityFunctional = zeros(modelsSetSize, 1);
for i = 1:modelsSetSize
  qualityFunctional(i) = calcQual(modelsSet(i), variables, responses, modelsSet(i).parameter);
end

% sort all models at this step
[~, sortIndexes] = sort(qualityFunctional); % FIX THIS

modelsSet = modelsSet(sortIndexes); 

modelResponses = zeros(length(responses), modelsSetSize);
for i = 1:modelsSetSize
  modelResponses(:, i) = calcMod(modelsSet(i), variables);
end  

complexity = 25; % limit for complexity
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

end

