clc
clear all
%close all

%% STEPS-specific parameters initialisation
alpha = 1.6;
grid_size = 20;
zone_size = 1;
time_step = 1;
rwp_speed = [3 6] / 3.6;
rwp_pause_time = [0 0];
zone_speed = [3 6] / 3.6;
zone_time = [1 1];
radio_range = 10;

%nodes.move;
%disp(floor(nodes.coords ./ simu.zone_size));
    
nb_vertices = grid_size * grid_size;

%% Simulator parameters initialisation

total_nb_simulations = 20;
max_nb_walkers = 20;
walkers_time_to_have_complete_vision = cell(max_nb_walkers, total_nb_simulations);
walkers_time_to_meet_everybody = cell(max_nb_walkers, total_nb_simulations);

% Attach zones storage
all_attach_zones_k = cell(max_nb_walkers,1);

for k=1:max_nb_walkers
    fprintf('**************** %d walker(s) ****************\n', k);
    
    % Walkers creation
    walkers = Group(alpha,k,grid_size,rwp_speed,rwp_pause_time,zone_speed,zone_time,zone_size,time_step,radio_range);
	% The walkers' positions are chose uniformly for t = 0
	walkers_positions = floor(walkers.coords ./ zone_size);
    all_attach_zones_k{k,1} = walkers_positions;

    %% Simulation start

    for num_simu=1:total_nb_simulations
        walkers.coords = all_attach_zones_k{k,1};
        
        fprintf('Simu %d\n', num_simu);

        % A global coverage matrix representing the global vision
        % i.e. all vertices visited by at least one walker
        global_coverage_matrix = zeros(grid_size);

        % Walkers coverage matrices representing the local visions
        % i.e. all vertices visited by a specific walker
        walkers_coverage_matrix = zeros(grid_size,grid_size,k);
        walkers_time_to_have_complete_vision{k, num_simu} = zeros(k,1);
        walkers_time_to_meet_everybody{k, num_simu} = zeros(k,1);
        walkers_cumul_adj_matrix = eye(k);

        % Updating coverage matrices with initial positions
        global_coverage_matrix(sub2ind([grid_size grid_size], walkers_positions(:,1)+1, walkers_positions(:,2)+1)) = 1;

        for n=1:k
            temp_cov_matrix = walkers_coverage_matrix(:,:,n);
            temp_cov_matrix(sub2ind([grid_size grid_size], walkers_positions(n,1)+1, walkers_positions(n,2)+1)) = 1;
            walkers_coverage_matrix(:,:,n) = temp_cov_matrix;
        end

        t = 0;
        % While the local vision is not complete for ALL walkers...
        while (sum(sum(sum(walkers_coverage_matrix))) < nb_vertices * k) | (sum(sum(walkers_cumul_adj_matrix)) < k * k)

            t = t + 1;
            if mod(t,1000) == 0
                fprintf('%d\t',t);
            end

            walkers.move();
            walkers_positions = floor(walkers.coords ./ zone_size);
            global_coverage_matrix(sub2ind([grid_size grid_size], walkers_positions(:,1)+1, walkers_positions(:,2)+1)) = 1;

            for n=1:k
                temp_cov_matrix = walkers_coverage_matrix(:,:,n);
                temp_cov_matrix(sub2ind([grid_size grid_size], walkers_positions(n,1)+1, walkers_positions(n,2)+1)) = 1;
                walkers_coverage_matrix(:,:,n) = temp_cov_matrix;

                % Fusion process
                for neighbourg=1:k
                    if (n~=neighbourg) & ([walkers_positions(neighbourg,1) walkers_positions(neighbourg,2)] == [walkers_positions(n,1) walkers_positions(n,2)])
                        temp_cov_matrix = or(walkers_coverage_matrix(:,:,n),walkers_coverage_matrix(:,:,neighbourg));
                        walkers_coverage_matrix(:,:,n) = temp_cov_matrix;
                        walkers_coverage_matrix(:,:,neighbourg) = temp_cov_matrix;

                        walkers_cumul_adj_matrix(neighbourg,n) = 1;
                        walkers_cumul_adj_matrix(n,neighbourg) = 1;
                    end
                end

                if (walkers_time_to_meet_everybody{k, num_simu}(n) == 0) & (sum(walkers_cumul_adj_matrix(n,:),2) == k)
                    walkers_time_to_meet_everybody{k, num_simu}(n) = t;
                end

                if (walkers_time_to_have_complete_vision{k, num_simu}(n) == 0) & (sum(sum(walkers_coverage_matrix(:,:,n))) == nb_vertices)
                    walkers_time_to_have_complete_vision{k, num_simu}(n) = t;
                end

            end

        end

        fprintf('\n');
    end

end

%% Plots

plot_results(walkers_time_to_have_complete_vision, walkers_time_to_meet_everybody);

%% Save nodes attach position

save('all_attach_zones_k.mat', 'all_attach_zones_k');