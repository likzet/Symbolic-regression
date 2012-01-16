function [qualFun] = calcQual(model, variables, responses, parameter)
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

model.parameter = parameter;
qualFun = mean((responses - calcMod(model, variables)).^2);


end

