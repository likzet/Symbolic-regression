function [newModelsSet] = modifyModel(bestModelsSet, functionsSet, newModelsNumber, variablesNumber)
  % (copyright Zaytsev A., MIPT, 2010)
  % MODIFYMOD modifies model by adding simple constructions from basis
  % function array
  %
  % newModelsSet = modifyMod(bestModelsSet, functionsSet, newModelsNumber, variablesNumber)
  %
  % input parameters:
  % bestModelsSet - best models set
  % funcList - list of basis functions
  % newModelsNumber - number of generated models
  % variablesNumber - number of variables
  %
  % output parameters:
  % model - list of generated models

  bestModelsNumber = size(bestModelsSet, 2);
  modelsIndexes = randi(bestModelsNumber, newModelsNumber, 1);

  % variablesSet = [8, 18, 35, 36, 44];
  % variablesNumber = length(variablesSet);
  variablesSet = 1:variablesNumber;

  for i = 1:newModelsNumber
    % select model
    model = bestModelsSet(modelsIndexes(i));
    modelSize = numel(model.parent);

    root = randi(modelSize - 1) + 1;
    
    % select basis function to insert
    functionsSetNumber = size(functionsSet, 2);
    functionNumber = randi(functionsSetNumber);
    if functionsSet(functionNumber).size == 1 % for one-parameter function
      primitiveModel.parent = [0, 1];
      variable = variablesSet(randi(variablesNumber));
      primitiveModel.function = {functionsSet(functionNumber).function, variable};
      if functionsSet(functionNumber).parameterNum ~= 0
        primitiveModel.parameter = ...
          {ones(1, functionsSet(functionNumber).parameterNum), 1};
      else                      
        primitiveModel.parameter = {[], 1};
      end
     elseif functionsSet(functionNumber).size == 2 % for two parameter function
        primitiveModel.parent = [0, 1, 1];
        firstVariable = variablesSet(randi(variablesNumber));
        secondVariable =  variablesSet(randi(variablesNumber));
        primitiveModel.function = {functionsSet(functionNumber).function, firstVariable, secondVariable};
        if functionsSet(functionNumber).parameterNum ~= 0
          primitiveModel.parameter = ...
            {ones(1, functionsSet(functionNumber).parameterNum), 1, 1};
        else                      
          primitiveModel.parameter = {[], 1, 1};
        end
    else
      error('Wrong number of function parameters %d', functionsSet(functionNumber).size);
    end
    
    % create new model
    newModelsSet(i) = insertSubModel(model, primitiveModel, root); % FIX IT how to create a struct array
  end
end

