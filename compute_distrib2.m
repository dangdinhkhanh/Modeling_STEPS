function [ distrb ] = compute_distrib2( n, alpha, x,y )
%COMPUTE_DISTRIB2 Summary of this function goes here
%   Detailed explanation goes here
% n is the grid size (n*n)
% (x,y) is the position of attachment zone

% the distance form (i,j) to (x,y) is
distrb = zeros(n);
%standard distance to center (k,k) of torus
stan_dist = zeros(n);
%real distance to attachment zone (x,y)
dist = zeros(n);
d_max = floor(n/2);
% check_distance = zeros(d_max+1,1);

beta = sum((1 + (0:d_max)).^(-alpha))^-1;
distrb(x,y) = beta;

if (mod(n,2)==1)
    %center
    k = d_max+1;
else 
    k = d_max;
end

for i=1:n
    for j=1:n
            %center is (d_max,d_max)
            stan_dist(i,j) = max(abs(i-k),abs(j-k));
    end

end



for i=1:n
    for j=1:n
        %shift from (k,k) to (x,y)
        %shift from (i,j) to [i-(k-x),j-(k-y)]
        new_i = mod(i+x-k,n);
        if (new_i==0)
            new_i=n;
        end
        new_j = mod(j+y-k,n);
        if (new_j==0)
            new_j=n;
        end
        dist(new_i,new_j) = stan_dist(i,j);
    end
end

if mod(n,2)==1
    for i=1:n
        for j = 1:n
            if (dist(i,j)>0)
                distrb(i,j) = beta / (8 * dist(i,j) * (dist(i,j)+1)^alpha);
            end
        end
    end
else
    for i=1:n
        for j= 1:n
           if (dist(i,j)>0) &&(dist(i,j)< d_max) 
                distrb(i,j) = beta / (8 * dist(i,j) * (dist(i,j)+1)^alpha);
           elseif (dist(i,j)==d_max)
               distrb(i,j) = beta / ((4 * d_max -1) * (d_max+1)^alpha);
           end

        end

    end
end

% disp(stan_dist);
% disp(dist);
% disp(sum(sum(distrb)));
% disp(beta);

end

