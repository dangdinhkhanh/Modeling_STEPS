function plot_results( walkers_time_to_have_complete_vision, walkers_time_to_meet_everybody )

    mat_vision_time = cell2mat(walkers_time_to_have_complete_vision);
    mat_meeting_time = cell2mat(walkers_time_to_meet_everybody);
    
    meanVisionTime = nan(size(walkers_time_to_have_complete_vision,1),1);
    meanMeetingTime = nan(size(walkers_time_to_have_complete_vision,1),1);
    
    % 95% confidence interval
    ci = 0.95;

    first_index = 1;
    last_index = 1;
    
    for k=1:size(walkers_time_to_have_complete_vision,1)
    
        [ allMeanVisionTime, allCiVisionTime ] = computeConfidenceInterval( mat_vision_time(first_index:last_index,:), ci );
        [ allMeanMeetingTime, allCiMeetingTime ] = computeConfidenceInterval( mat_meeting_time(first_index:last_index,:), ci );
        
        first_index = last_index + 1;
        last_index = first_index + k - 1;
        
        avgVisionTime(k) = mean(allMeanVisionTime);
        avgMeetingTime(k) = mean(allMeanMeetingTime);
    end
    
    x=1:size(walkers_time_to_have_complete_vision,1);
    
	theorical_cov_time = avgVisionTime(1) ./ x;
    
	h(1) = figure(1);
    plot(x, avgVisionTime);
	hold all
% 	plot(x, theorical_cov_time);
% 	hold all
	grid on
    xlabel('number of walkers')
    ylabel('All nodes local vision time')
        
	h(2) = figure(2);
    plot(x, avgMeetingTime);
	hold all
	grid on
    xlabel('number of walkers')
    ylabel('Meeting Time')

end

