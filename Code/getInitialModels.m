function [genModel] = getInitialModels(genSetSize, functList, varNum, ...
                                       initialModel)
% GETINITIALMODELS generates initial model set for genetic algorithm
%
% [ genModel ] = getInitialModels( genSetSize, funcList, n)
%
% input parameters:
% genSetSize - size for models to generate
% funcList - list of aviable functions
% varNum -  number of variables
% initialModel - set of initial models to insert in our initial models set
%
% output parameters:
% genModel - array of generated models

if exist('initialModel', 'var')
    genModel = initialModel;
    sizeInitialModel = size(initialModel, 2);
else
    genModel = [];
    sizeInitialModel = 0;
end

% define varSet
varSet = 1:varNum;
% varSet = [8, 18, 35, 36, 44];
varNum = length(varSet);

for i = (sizeInitialModel + 1):genSetSize
    functSize = size(functList, 2);
    functNum = randi(functSize);
    if functList(functNum).size == 0 % for variables number
%         bestModel(i).parent = 0;
%         bestModel(i).function = functList(functNum).function;
%         bestModel(i).parameter = 1;
        genSetSize = genSetSize + 1;
    elseif functList(functNum).size == 1 % for one-parameter function
        genModel(i).parent = [0, 1];
        var1 = varSet(randi(varNum));
        genModel(i).function = {functList(functNum).function, var1};
        if functList(functNum).parameterNum ~= 0
            genModel(i).parameter = {ones(1, functList(functNum).parameterNum), ...
                                 1, 1};
        else                      
           genModel(i).parameter = {[], ...
                                 1, 1};
        end    
    elseif functList(functNum).size == 2 % for two parameter function
        genModel(i).parent = [0, 1, 1];
        var1 = varSet(randi(varNum));
        var2 = varSet(randi(varNum));
        genModel(i).function = {functList(functNum).function, var1, var2};
        if functList(functNum).parameterNum ~= 0
            genModel(i).parameter = {ones(1, functList(functNum).parameterNum), ...
                                 1, 1};
        else                      
           genModel(i).parameter = {[], ...
                                 1, 1};
        end    
    end
end  

end

