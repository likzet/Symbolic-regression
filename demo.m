%% Demo for nonlinear regression toolbox

clear all;

thisFolder = fileparts(mfilename('fullpath'));
addpath (fullfile(thisFolder, 'Code'));
addpath (fullfile(thisFolder, 'Functions'));

%% Create model data
inputSize = 2;
outputSize = 1; % the only output size is supported now

trainSampleSize = 200;
testSampleSize = 1000;

modelFunction = @(x)(sin(sum(x, 2)) + 0.1 * sum(x, 2).^2);
trainX = lhsdesign(trainSampleSize, inputSize);
trainY = modelFunction(trainX);

testX = lhsdesign(testSampleSize, inputSize);
testY = modelFunction(testX);

%% Apply algorithm

[functionList, initialModel, bestModelSize, newModelSize] = initializeAlgParam();
bestModelsSet = getMod(trainX, trainY, functionList, ...
                     bestModelSize, newModelSize);
                     
%% Apply models
responses = zeros(size(testY, 1), numel(bestModelsSet));
errors = zeros(1, numel(bestModelsSet));
for modelIndex = 1:numel(bestModelsSet)
  responses(:, modelIndex) = calcMod2(bestModelsSet(modelIndex).parameter, bestModelsSet(modelIndex), testX);
  errors(modelIndex) = mean((responses(:, modelIndex) - testY).^2);
end    

plot((errors));
