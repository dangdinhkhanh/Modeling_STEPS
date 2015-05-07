% n = 400;
% P = ones(n,1)/n;
%res = MinMaxFunction(P);
alpha = 1.6;
%grid_size = 20;
grid_size = 21;
%P = vector_base;
P = compute_distrib(alpha,grid_size);
k= 1:15;
ct = zeros(length(k),1);
for i = 1:length(k)
    ct(i) = CoveringTime(P,i);
end
hold on;
plot(k,ct,'r-');
%meeting time
%mt = MeetingTime2RWs(P,P);
