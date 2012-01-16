function [ modelResponses ] = calcMod2(parameters, model, variables)
%CALCMOD calculates values for given model and variables
% 
% [ modelResponses ] = calcMod(parameter, model, var)
% 
% output parameters:
% modelResponses [n, 1] - responses vector
%
% input parameters:
% model - model structure (see detail explanation in report)
% var [n, m] - variables

if isfield(model, 'distribution')
  for j = 1:size(model.distribution, 2)
    if (j ~= 1)
      model.parameter{j} = parameters((model.distribution(j - 1) + 1):model.distribution(j));
    else
      model.parameter{j} = parameters(1:model.distribution(j));
    end    
  end
end

m = size(model.parent, 2);
n = size(variables, 1);

% select inner level for each tree node
level = ones(m, 1); % level
flag = 1; % flag for changes in level
while flag % level for each node hasn't changed for last step
    flag = 0; 
    for i = m:-1:2
        parentI = model.parent(i);
        if level(i) >= level(parentI) % select node where child has bigger level then parent 
            level(parentI) = level(parentI) + 1; % increase level for parents
            flag = 1; % we ahve changed level somewhere
        end
    end    
end    
maxLevel = max(level);

% calculate responses
variablesTree = zeros(n, m);
for i = 1:maxLevel % for each level
  if (i == 1) % for first level we load variables from initial variables set
      firstLevel = find(level == 1);
      variablesTree(:, firstLevel) = variables(:, cell2mat(model.function(firstLevel))) .* ...
                                     repmat(cell2mat(model.parameter(firstLevel)), n, 1);
  elseif (i == maxLevel) % for last level we calculate responses
    lastLevel = find(level == maxLevel);
    levLastChild = find(model.parent == lastLevel);
    sizeChild = size(levLastChild, 2);
    if sizeChild == 1
      modelResponses = feval(model.function{lastLevel}, ...
                     variablesTree(:, levLastChild), ...
                     model.parameter{lastLevel});
    elseif sizeChild == 2
      modelResponses = feval(model.function{lastLevel}, ...
                     variablesTree(:, levLastChild(1)), ... 
                     variablesTree(:, levLastChild(2)), ...
                     model.parameter{lastLevel});  
    else
      disp('Wrong number of inputs for evaluation');
    end    
  else % for another levels we calculate variables   
    iLevel = find(level == i);
    for j = 1:size(iLevel, 1) % for each element from this level
     jIndex = iLevel(j);
     iLevelChild = find(model.parent == jIndex); % select children
     sizeChild = size(iLevelChild, 2);
     if sizeChild == 1
       variablesTree(:, jIndex) = feval(model.function{jIndex}, ...
                                        variablesTree(:, iLevelChild), ...
                                        model.parameter{jIndex});
     elseif sizeChild == 2
       variablesTree(:, jIndex) = feval(model.function{jIndex}, ...
                                        variablesTree(:, iLevelChild(1)), ...
                                        variablesTree(:, iLevelChild(2)), ...
                                        model.parameter{jIndex});  
     else
       disp('Wrong number of inputs for evaluation')
     end    
    end
  end    
end   

if any(isnan(modelResponses)) || any(isinf(modelResponses))
  modelResponses = 10^10 * ones(n, 1);
  warning('Infs or NaNs are in function returns');
end

modelResponses = real(modelResponses);

% modelResponses = min(1, max(0, modelResponses));


end

