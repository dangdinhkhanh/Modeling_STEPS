function [ distrb ] = compute_distrib2( n, x,y )
%COMPUTE_DISTRIB2 Summary of this function goes here
%   Detailed explanation goes here
% n is the grid size (n*n)
% (x,y) is the position of attachment zone

% the distance form (i,j) to (x,y) is
d =  min(max(abs(i-x),(j-y)), max(abs(i+n-x,j+n-y)));

end

