function [y] = sigm1(x, w)
%SIGM1 Summary of this function goes here
%   Detailed explanation goes here

y = 2 * ((x > w) - 0.5);

end

