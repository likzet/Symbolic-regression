function [ modVal ] = calcMod(model, var)
%CALCMOD calculates values for given model and variables
% 
% [ modVal ] = calcMod(model.parameter, model, var)
% 
% output model.parameters:
% modVal [n, 1] - responses vector
%
% input model.parameters:
% model - model structure (see detail explanation in report)
% var [n, m] - variables

m = size(model.parent, 2);
n = size(var, 1);

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
levMax = max(level);

% calculate responses
varTree = zeros(n, m);
for i = 1:levMax % for each level
    if (i == 1) % for first level we load variables from initial variables set
        level1 = find(level == 1);
        varInd = zeros(1, size(level1, 2));
        for j = 1:size(level1, 1);
            levJ = level1(j);
            varInd(j) = model.function{levJ};
            varTree(:, level1(j)) = var(:, varInd(j)) * model.parameter{level1(j)};
        end 
        % varTree(:, level1) = var(:, varInd) * diag(model.parameter{level1});
    elseif (i == levMax) % for last level we calculate responses
        levelLast = find(level == levMax);
        levLastChild = find(model.parent == levelLast);
        sizeChild = size(levLastChild, 2);
        if sizeChild == 1
            modVal = feval(model.function{levelLast}, ...
                           varTree(:, levLastChild), model.parameter{levelLast});
        elseif sizeChild == 2
            modVal = feval(model.function{levelLast}, ...
                           varTree(:, levLastChild(1)), ... 
                           varTree(:, levLastChild(2)), ...
                           model.parameter{levelLast});  
        else
            disp('Wrong number of inputs for evaluation')
        end    
    else % for another levels we calculate variables   
        levelI = find(level == i);
        for j = 1:size(levelI, 1) % for each element from this level
           jInd = levelI(j);
           levIChild = find(model.parent == jInd); % select children
           sizeChild = size(levIChild, 2);
           if sizeChild == 1
               varTree(:, jInd) = feval(model.function{jInd}, ...
                                        varTree(:, levIChild), ...
                                        model.parameter{jInd});
           elseif sizeChild == 2
               varTree(:, jInd) = feval(model.function{jInd}, ...
                                        varTree(:, levIChild(1)), ...
                                        varTree(:, levIChild(2)), ...
                                        model.parameter{jInd});  
           else
               disp('Wrong number of inputs for evaluation')
           end    
        end
    end    
end   

modVal = real(modVal);
modVal = min(1, max(0, modVal));


end

