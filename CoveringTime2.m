function [ ct ] = CoveringTime2( n,alpha,Pos )
% n is the size of torus
% Pos is the k*2 vector of attachment zone of k walkers
k = size(Pos,1);
% make a 3 dimensional matrix n*n*k
P = zeros(n,n,k);
for i =1:k
    distrb = compute_distrib2(n,alpha,Pos(i,1),Pos(i,2));
    P(:,:,i) = distrb;
end
Q = zeros(n^2,1);
for i =1:n
    for j = 1:n
        index = (i-1)*n+j;
        val = 1;
        for h = 1:k
            val = val*(1-P(i,j,h));
        end
        Q(index) = 1-val;
    end
end
ct = MinMaxFunction(Q);
end