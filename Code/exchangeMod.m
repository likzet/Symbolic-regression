function [ model ] = exchangeMod(bestModel, k)
%EXCHANGEMOD generates new models by exchanging components in best models

sizeBm = size(bestModel, 2);
firstMod = randi(sizeBm, k, 1);
secMod = randi(sizeBm, k, 1);

for i = 1:k
    % select first model
    modelF = bestModel(firstMod(i));
    sizeModF = size(modelF.parent, 2);
    % select component from first model to exchange
    clear subModelF;
    rootF = randi(sizeModF - 1) + 1;
    [subTreeF, newTreeF] = selectSubTree(modelF.parent, rootF);
    subModelF.parent = newTreeF;
    for j = 1:size(subTreeF, 2)
        subModelF.function{j} = modelF.function{subTreeF(j)};
        subModelF.parameter{j} = modelF.parameter{subTreeF(j)};
    end
    subModelF.parameter = modelF.parameter(subTreeF);
    
    % select second model
    modelS = bestModel(secMod(i));
    sizeModS = size(modelS.parent, 2);
    % select component from second model to exchange
    clear subModelS;
    rootS = randi(sizeModS - 1) + 1;
    [subTreeS, newTreeS] = selectSubTree(modelS.parent, rootS);
    subModelS.parent = newTreeS;
    for j = 1:size(subTreeS, 2)
        subModelS.function{j} = modelS.function{subTreeS(j)};
        subModelS.parameter{j} = modelS.parameter{subTreeS(j)};
    end
     
    % insert selected subtree into first model
    model(2 * i - 1) = insertSubModel(modelF, subModelS, rootF);
    model(2 * i) = insertSubModel(modelS, subModelF, rootS);
end    

end

