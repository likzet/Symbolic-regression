function [qualFun] = calcQual2(model, variables, responses, parameter)
% CALCQUAL calculates quality functional for given model, variables and
% responses
%
% [qualFun] = calcQual(model, var, resp)
%
% output parameters:
% qualFun - quality functional  
%
% input parameters:
% model - model structure (see detail explanation in report)
% variables [n, m] - variables matrix
% responses [n, 1] - responses vector

qualFun = sum((responses - calcMod2(parameter, model, variables)).^2);
% regularization
lambda = 0;
qualFun = qualFun + lambda * (parameter * parameter');


end

