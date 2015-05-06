function [ res ] = MinMaxFunction( P )
%MINMAXFUNCTION Summary of this function goes here
%   Detailed explanation goes here
% P is a set of probabilities
n = length(P);
res = 0;
% for i = 1:n
%     sum = 0;
%     com = combnk(P,i);
%     if i==1
%         com = com';
%     end
%     for j=1:size(com,1)
%         denom = 0;
%         for k =1:size(com,2)
%             denom = denom + com(j,k);
%         end
%         sum = sum + 1/denom;
%         
%     end
%     %disp(sprintf('sum %f',sum));
%     res = res + (-1)^(i+1)*sum;
% end
    fun = @(x) 1;
    for i =1:n
        f = @(x) 1-exp(-P(i).*x);
        fun = @(x) fun(x).*f(x);
    end
    fun = @(x) 1-fun(x);
    %ct = integral(fun,0,Inf);
    res = quadgk(@(x) fun(x),0,Inf);

end

