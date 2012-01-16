function [ qualFun ] = calcQualVect(  model, var, resp, parameter)
%CALCQUALVECT calculates vector of quality functionals for given model, variables and
% responses
%
% [ qualFun ] = calcQual( model, var, resp )
%
% output parameters:
% qualFun - quality functional  
%
% input parameters:
% model - model structure (see detail explanation in report)
% var [n,m] - variables
% resp [n,1] - responses

model.parameter = parameter;
qualFun = resp - calcMod2(parameter,model, var);


end

