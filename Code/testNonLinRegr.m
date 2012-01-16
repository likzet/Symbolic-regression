%% test for nonlinear regression models generation

clear all;
warning('off');
%% load data set

clear all
load traffic.mat

%% prepare data set

% initialize data sets
varSize = 30;
respStart = 10;
respSize = 10;
objSize = 20000;


training = training(randperm(objSize),:);

% create control and learning sample
% first way

X = [training(:,1:varSize)];
y = sum(training(:,varSize + respStart + (1:10)),2);

contrSize = 5000;
randInd = randperm(20000);
learnInd = randInd(contrSize+1:end);
contrInd = randInd(1:contrSize);

learnX = X(learnInd,:);
learnY = y(learnInd);
contrX = X(contrInd,:);
contrY = y(contrInd);

testX = [test(:,1:varSize)];

%% apply nonlinear regression models generation

functList(1).function = '.*';
functList(1).size = 2;
functList(2).function = '+';
functList(2).size = 2;
functList(3).function = './';
functList(3).size = 2;



bSize = 100;
k(1) = 50;
k(2) = 200;

[ bestModel ] = getMod( learnX, learnY, functList, bSize, k  );


%% unit test

% calcMod, calcQual, get parameters
var = [ones(1,6); 1:6; 2:7]';
resp = [10, 20, 30, 40, 50, 60]';
model.parent = [0,1,1,3,3,5];
model.function = {'+','2','.*','1','sin','3'};
model.parameter = [1,1,1,1,1,1];
parameter = [1,1,1,1,1,1];

[ modVal ] = calcMod( model, var );
[ qualFun ] = calcQual( model, var, resp, parameter );
[par, fval] = fminsearch(@(param)(calcQual(model,var,resp,param)),zeros(6,1));
disp(par);
disp(fval);

% selMod
var = [ones(1,6); 1:6; 2:7]';
resp = [10, 20, 30, 40, 55, 60]';
model1.parent = [0,1,1,3,3,5];
model1.function = {'+','2','.*','1','sin','3'};
model1.parameter = [1,1,1,1,1,1];
model2(1).parent = [0,1,1,3];
model2(1).function = {'.*','3','sin','2'};
model2(1).parameter = [1,1,1,1,1,1];
model2(2).parent = [0,1,1,3];
model2(2).function = {'+','3','exp','2'};
model2(2).parameter = [1,1,1,1,1,1];


[par, fval] = fminsearch(@(param)(calcQual(model1,var,resp,param)),zeros(6,1));
disp(par)
disp(fval);
model1.parameter = par;
[par, fval] = fminsearch(@(param)(calcQual(model2(1),var,resp,param)),zeros(6,1));
disp(fval)
model2(1).parameter = par;
[par, fval] = fminsearch(@(param)(calcQual(model2(2),var,resp,param)),zeros(6,1));
disp(fval)
model2(2).parameter = par;

selMod( model1, model2, resp, var );
[ bestModel,qualFun ] = selMod( model1, model2, resp, var );

% select subtree
tree = [ 0,1,2,1,4,4,6,3,7];
k = 4;
[ subTree, newTree ] = selSubTree( tree, k )

% insert submodel

model1.parent = [0,1,1,3,3,5];
model1.function = {'+','2','.*','1','sin','3'};
model1.parameter = [1,1,1,1,1,1];
model2.parent = [0,1,1,3];
model2.function = {'.*','3','sin','2'};
model2.parameter = [1,1,1,1,1,1];
k = 4;
[ newModel ] = insertSubModel(model1,model2,k)

% exchange models

model2(1).parent = [0,1,1,3];
model2(1).function = {'.*','3','sin','2'};
model2(1).parameter = [1,1,1,1,1,1];
model2(2).parent = [0,1,1,3];
model2(2).function = {'+','3','exp','2'};
model2(2).parameter = [1,1,1,1,1,1];

k = 4;
[ model ] = exchangeMod( model2, k );

% modify model

functList(1).function = '.*';
functList(1).size = 2;
functList(2).function = './';
functList(2).size = 2;
functList(3).function = '+';
functList(3).size = 2;
functList(4).function = 'exp';
functList(4).size = 1;
functList(5).function = 'sin';
functList(5).size = 1;

model2(1).parent = [0,1,1];
model2(1).function = {'+','1','2'};
model2(1).parameter = [1,1,1];
model2(2).parent = [0,1,1];
model2(2).function = {'.*','1','exp','3'};
model2(2).parameter = [1,1,1];

k = 6;
n = 3;

[ model ] = modifyMod( model2, functList,k, n )


% test main function
m = 40;
n = 3;
var = randn(m,n);
resp = (var*[1 2 3]') + 0.1*randn(m,1);

functList(1).function = '.*';
functList(1).size = 2;
functList(2).function = './';
functList(2).size = 2;
functList(3).function = '+';
functList(3).size = 2;
functList(4).function = 'exp';
functList(4).size = 1;
functList(5).function = 'sin';
functList(5).size = 1;

bSize = 50;
k(1) = 50;
k(2) = 200;

[ bestModel ] = getMod( var, resp, functList, bSize, k  );

%% plot results

x = 0;
y = 0; 
z = ((1:100)/100 - 0.5)';
var = repmat([x],100,1);
var = [z,var,var]; 
plot(calcMod( bestModel(1), var), z);

str = 'a';
for i=1:100000
    c = strcmp((str),(str));
end    

