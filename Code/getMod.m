function [bestModelsSet] = getMod(variables, responses, ...
                                functionList, bestSetSize, newModelsSetSize, ...
                                initialModelsSet, options)
%GETMOD creates a set of nonlinear regression models
% 
% [ bestModel ] = getMod( variables, responses, ...
%                         functList, bestSetSize, newModelsSetSize, ...
%                         initialModel)
% 
% input parameters:
% variables  [m, n] - variables
% responses [m, 1] - responses
% functionList - avialable functions
% bestSetSize - size of best models set
% newModelsSetSize - sizes for set of models to generate
% initialModelsSet - set of initial models
% options - run options
%
% output parameters:
% bestModelsSet - set of best models

% RandStream.setDefaultStream(RandStream('mt19937ar', 'seed', sum(100 * clock)));

% initialize default options
if ~exist('options', 'var')
  options = struct();
end

if ~isfield(options, 'saveModels')
  options.saveModels = 1;
end

[sampleSize, variablesNumber] = size(variables);

% create initial set of models
if exist('initialModelsSet', 'var')
  bestModelsSet = getInitialModels(bestSetSize, functionList, variablesNumber, initialModelsSet);
else 
  bestModelsSet = getInitialModels(bestSetSize, functionList, variablesNumber);
end    

% run algorithm

% algoritm parameters
differenceQualityFunctional = 0;
oldQualityFunctional = 10^15;
iterationNumber = 10;
controlSampleSize = min(100000, size(variables, 1) - 100);

for iteration = 1:iterationNumber
  % split sample to control and learning
  randomPermutationSample = randperm(sampleSize);
  controlResponses = responses;
  controlVariables = variables;
  learningResponses = responses(randomPermutationSample((1 + controlSampleSize) : end), :);
  learningVariables = variables(randomPermutationSample((1 + controlSampleSize) : end), :);

  % generate new models
  newModelsSet = generateModels(learningVariables, learningResponses, ...
                                bestModelsSet, functionList, newModelsSetSize, variablesNumber);

  % get new models' parameters
  newModelsSet = getModelParameters(newModelsSet, learningVariables, learningResponses);

  % select best models
  [bestModelsSet, qualityFunctional] = selectModels(newModelsSet, bestModelsSet, ...
                                        controlVariables, controlResponses);
  
  % quality functional estimation
  differenceQualityFunctional = 0.1 * differenceQualityFunctional + ...
                                0.9 * abs(oldQualityFunctional - qualityFunctional);
  oldQualityFunctional = qualityFunctional;
  disp(iteration);
  disp(qualityFunctional);
  if options.saveModels
    save 'Algorithm/Best models/bestModel0925.mat' bestModelsSet;   
  end
end


end

