function [ glob_ct, best_ct,avg_ct, worst_ct ] = RandomWalk( k, n, pos )
%RANDOMWALK Summary of this function goes here
%   Detailed explanation goes here
% k: a number of random walkers
% n: a size of torus
% pos: initial position of all k nodes
total_states = zeros(n,n,k);
% array of k positions 
total_pos = zeros(k,2);
% initial states
total_pos(:,1) = total_pos(:,1) + pos(1);
total_pos(:,2) = total_pos(:,2) + pos(2);
global_state = zeros(n,n);
MAX = 10^5;
glob_ct = MAX;
best_ct = MAX;
avt_ct = MAX;
worst_ct = MAX;
%inital steps
i = 0;
%array of cover time (initially, set all ct are huge)
ct = ones(k,1)*MAX;
flag = 1;
while flag==1
    i = i +1;
    %current information
    current_info = zeros(k,1);
    for j = 1:k
        current_info(j) = sum(sum(total_states(:,:,j)));
    end
    %consider k random walkers moving
    for j = 1:k
        [total_pos(j,:), total_states(:,:,j)] = Step(total_pos(j,:), total_states(:,:,j));
    end
    
    %update local states
    for j = 1:(k-1)
        for h = (j+1):k
            %two random walkers at the same position
            if (sum(total_pos(j,:)==total_pos(h,:))==2)
                total_states(:,:,j) = bitor(total_states(:,:,j),total_states(:,:,h));
                total_states(:,:,h) = total_states(:,:,j);
            end
        end
    end
    %update global state
    if (sum(sum(global_state))<n*n)
        for j = 1:k
            global_state = bitor(global_state,total_states(:,:,j));
        end
        if (sum(sum(global_state))==n*n)
            glob_ct = i;
        end
    end
    
    
    %current information
    new_info = zeros(k,1);
    for j = 1:k
        new_info(j) = sum(sum(total_states(:,:,j)));
    end
    % check cover time of each random walk
    for j = 1:k
        if (current_info(j)<new_info(j)) && (new_info(j)==n^2)
            ct(j) = i;
        end
    end
    % update worst, best, avg
    best_ct = min(ct);
    avg_ct = mean(ct);
    worst_ct = max(ct);
    
    if (sum(sum(sum(total_states)))==n*n*k)
        flag = 0;
    end
end

% disp(sprintf('i=%d',i));
% disp(ct);
end

