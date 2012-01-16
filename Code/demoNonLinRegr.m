%% Demo for nonlinear regression models generation

clear all;
warning('off');

%% Load data

clear all;
load Data/dati_l.mat;

%% Prepare data

[n, m] = size(dati_l);
responses = reshape(dati_l(:, 2:end), n*(m-1), 1);
variables(:,1) = ones(n*(m-1),1);
variables(:,2) = repmat(dati_l(:, 1), m-1, 1);
variables(:,3) = repmat((1:(m-1))', n , 1);

%% select subset from the whole set 
[n, m] = size(dati_l);
i = 50;
select = 60;
m2 = size(select,2);
responses = reshape(dati_l(:, select), n*m2, 1);
variables(:,1) = ones(n*m2,1);
variables(:,2) = repmat(dati_l(:, 1), m2, 1);
variables(:,3) = repmat((1:(m2))', n, 1);



%% Apply algorithm

functList(1).function = '.*';
functList(1).size = 2;
functList(2).function = 'cos';
functList(2).size = 1;
functList(3).function = '+';
functList(3).size = 2;
functList(4).function = 'exp';
functList(4).size = 1;
functList(5).function = 'sin';
functList(5).size = 1;

bestModelSetSize = 50;
newModelSetSize(1) = 100;
newModelSetSize(2) = 200;

[ bestModel ] = getMod(variables, responses, functList, ...
                       bestModelSetSize, newModelSetSize);

%% Plot results

j = 50;
for i = 1:j
    hold off;
    h = figure;
    hold on;
    plot(responses(1:j:n),'r')
    plot(calcMod(bestModel(i),variables(1:j:n,:)));
    strFigName = sprintf('Images/Model %d.eps',i);
    saveas(h,strFigName,'psc2');
    pause(1);
    close all;
    disp(sum((calcMod(bestModel(2),variables(1:j:n,:)) - calcMod(bestModel(i),variables(1:j:n,:))).^2));
end    
    

