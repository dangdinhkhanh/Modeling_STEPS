function [ ct ] = CoveringTime( P,k )
%COVERINGTIME Summary of this function goes here
%   Detailed explanation goes here

    % P: a vector of distribution
    % k: number of random walkers (or collectors)
    % ct: covering time 

    % size of coupons (number of vertices)
    n = length(P);
    % the new probability applied for k collectors
    Q = zeros(n,1);
    for i = 1:n
        Q(i) = 1-(1-P(i))^k;
    end
    ct = MinMaxFunction(Q);
    
end

