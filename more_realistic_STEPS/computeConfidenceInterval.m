function [ meanY, ci95 ] = computeConfidenceInterval( data, ci )
%COMPUTECONFIDENCEINTERVAL Summary of this function goes here
%   data is a matrix of size [time x nb_nodes]
%   ci is confidence percentage between 0 and 1

meanY = mean(data,2);
s = std(data',[],1)';

alpha = 1 - ci;

%number of elements in the data vector
n = size(data,2);

T_multiplier = tinv(1-alpha/2, n-1);

    if isnan(T_multiplier)
        ci95 = nan(size(meanY,1),1);
    else
        ci95 = T_multiplier.*s/sqrt(n);
    end

end

