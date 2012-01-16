function [functList, initialModel, ...
          bestModelSize, newModelSize] = ...
          initializeAlgParam(loadModel)
%INITIALIZEALGPARAM initializes algorithm parameters
%
% [funcList, initialModel, bestModelSize, newModelSize] = ...
%          initializeAlgParam()
%
% output parameters:
% funcList - list of basis functions
% initialModel - set of initial models
% bestModelSetSize - size of best model set size
% newModelSize - size of generated models size
% newModelSize(1) - half of crossover model set size
% newModelSize(2) - mutation model set size
% newModelSize(3) - basis model set size

clear functList;
functList(1).function = 'times2';
functList(1).size = 2;
functList(1).parameterNum = 0;

functList(2).function = 'sin1';
functList(2).size = 1;
functList(2).parameterNum = 1;

functList(3).function = 'times2';
functList(3).size = 2;
functList(3).parameterNum = 0;

functList(4).function = 'exp1';
functList(4).size = 1;
functList(4).parameterNum = 1;

functList(5).function = 'power2';
functList(5).size = 1;
functList(5).parameterNum = 0;

functList(6).function = 'divide2';
functList(6).size = 2;
functList(6).parameterNum = 0;

functList(7).function = 'abs1';
functList(7).size = 1;
functList(7).parameterNum = 0;

functList(8).function = 'sigm1';
functList(8).size = 1;
functList(8).parameterNum = 1;

functList(9).function = 'gauss1';
functList(9).size = 1;
functList(9).parameterNum = 2;

if nargin == 0
    initialModel(1).parent = [0, 1, 1, 2, 2, 3, 3, 4, 4, 6, 6]; 
    initialModel(1).function = {'divide2', 'plus2', 'plus2', 'times2', 2, ...
                                'times2', 7, 8, 6, 5, 4};
    initialModel(1).parameter = {[], [], [], [], 100, [], 1/0.11, 1, ...
                                    1, 1, 1};

    initialModel(2).parent = [0, 1, 1];
    initialModel(2).function = {'divide2', 1, 2};
    initialModel(2).parameter = {[], 1, 1};

    initialModel(2).parent = [0, 1, 1];
    initialModel(2).function = {'plus2', 1, 2};
    initialModel(2).parameter = {[], 1, 1};
else
    initialModel = loadModel;
end
bestModelSize = 200;
newModelSize(1) = 50;
newModelSize(2) = 50;
newModelSize(3) = 50;

end

