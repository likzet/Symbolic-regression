function [newModel] = insertSubModel(model, subModel, root)
%INSERTSUBMODEL insert submodel to model by replacing submodel with root
%
% [newModel] = insertSubModel(model, subModel, root)
%
% output parameters:
% newModel - new model
%
% input parameters:
% model - old model
% subModel - model to insert
% root - root of subModel in model

% remove submodel from model
subTree = selectSubTree(model.parent, root);
newModelIndexes = setdiff(1:size(model.parent, 2), subTree);
newIndPar = model.parent(newModelIndexes); 
newModelSize = size(newModelIndexes, 2);

newModel.parent = zeros(1, newModelSize);

for i = 1:newModelSize
  newModel.parent(newIndPar == newModelIndexes(i)) = i;
end   
newModel.function = model.function(newModelIndexes);
newModel.parameter = model.parameter(newModelIndexes);

newRootPar = find(newModelIndexes == model.parent(root));

% add submodel to new model
subModel.parent(subModel.parent == 0) = newRootPar - newModelSize;
newModel.parent = [newModel.parent, (subModel.parent + newModelSize)];
newModel.function = [newModel.function, subModel.function];
for i = 1:size(subModel.parameter, 2);
    newModel.parameter{end + 1} = subModel.parameter{i};
end

if (size(newModel.function, 2) ~= size(newModel.parent, 2))
  error('Wrong functions array size for new model');
end    
end

