% n = 400;
% P = ones(n,1)/n;
%res = MinMaxFunction(P);
alpha = 1.6;
grid_size = 20;
%grid_size = 21;
%P = vector_base;
P = compute_distrib(alpha,grid_size);
k= 1:20;
ct = zeros(length(k),1);
for i = 1:length(k)
    disp(i);
    ct(i) = CoveringTime(P,i);
end

figure(1);
hold on;
plot(k,ct,'b-');
grid on

%meeting time
%mt = MeetingTime2RWs(P,P);
