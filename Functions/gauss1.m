function [y] = gauss1(x, w)
%GAUSS1 Summary of this function goes here
%   Detailed explanation goes here
y = exp( - (x - w(1)).^2 / (w(2)^2));

end

