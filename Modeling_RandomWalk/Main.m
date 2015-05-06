%n = 5:20;
n = 20;
k = 1:5;
pos = [1 1];
num_sim = 10;
glob_ct_arr = zeros(1,num_sim);
best_ct_arr = zeros(1,num_sim);
avg_ct_arr = zeros(1,num_sim);
worst_ct_arr = zeros(1,num_sim);
%average value for each value of n
glob_ct = zeros(1,length(n));
best_ct = zeros(1,length(n));
avg_ct = zeros(1,length(n));
worst_ct = zeros(1,length(n));
for i = 1:length(k)
    for j =1:num_sim
        [ glob_ct_arr(j), best_ct_arr(j),avg_ct_arr(j), worst_ct_arr(j) ] = RandomWalk( k(i), n, pos );
    end
    glob_ct(i) = mean(glob_ct_arr);
    best_ct(i) = mean(best_ct_arr);
    avg_ct(i) = mean(avg_ct_arr);
    worst_ct(i) = mean(worst_ct_arr);
end
% disp(sprintf('global cover time %d',glob_ct));
% disp(sprintf('best local cover time %d',best_ct));
% disp(sprintf('avarage local cover time %d',avg_ct));
% disp(sprintf('worst local cover time %d',worst_ct));

%theoretical
% k increasing
theo_ct = zeros(1,length(k));
for i =1:length(k)
    theo_ct(i) = (2/k(i))*(n^2)*2*log(n);
end
clf('reset');
figure('name', 'k is increasing, n = 20');
hold on; 
plot(k,glob_ct,'k+-');
plot(k,best_ct,'b*-');
plot(k,avg_ct,'rs-');
plot(k,worst_ct,'m^-');
plot(k,theo_ct,'bd--','LineWidth',2);
h = legend('glob','best','avg','worst','theo');
set(h,'Location','NorthEast');
xlabel('Number of random walkers');
ylabel('Cover time');


% n increasing
% theo_ct = zeros(1,length(n));
% for i =1:length(n)
%     theo_ct(i) = (n(i)^2)*2*log(n(i));
% end
% clf('reset');
% figure('name', 'k=2, n increasing');
% hold on; 
% plot(n,glob_ct,'k+-');
% plot(n,best_ct,'b*-');
% plot(n,avg_ct,'rs-');
% plot(n,worst_ct,'m^-');
% plot(n,theo_ct,'bd--','LineWidth',2);
% h = legend('glob','best','avg','worst','theo');
% set(h,'Location','NorthWest');
% xlabel('Length of side of torus');
% ylabel('Cover time');
