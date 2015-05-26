alpha = 1.6;
grid_size = 20;

%P = compute_distrib(alpha,grid_size);

k=1:20;
% Pos = ones(length(k),2);
% for i = 1:length(k)
%     Pos(i,1) = i;
%     Pos(i,2) = i;
% end

load('more_realistic_STEPS/all_attach_zones_k.mat');

ct = zeros(length(k),1);
for i = 1:length(k)
	disp(i);
        
    Pos = all_attach_zones_k{i,1} + 1;
    ct(i) = CoveringTime2(grid_size,alpha,Pos);
end
hold on;

figure(1);
hold all
plot(k,ct,'r-');
grid on