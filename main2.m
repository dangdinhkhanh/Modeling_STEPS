alpha = 1.6;
grid_size = 20;

%P = compute_distrib(alpha,grid_size);

k= 1:15;
Pos = ones(length(k),2);
for i = 1:length(k)
    Pos(i,1) = i;
    Pos(i,2) = i;
end
ct = zeros(length(k),1);
for i = 1:length(k)
    ct(i) = CoveringTime2(grid_size,alpha,Pos(1:i,:));
end
hold on;
plot(k,ct,'r-');