function [ new_pos, new_map_state ] = Step( pos, map_state )
    %STEP Summary of this function goes here
    %   Detailed explanation goes here
    % pos: the current position [x,y]
    % map_state: a matrix n*n representint a torus where each element is 0 or 1
    % 0: vertex has not been visited
    % 1: vertex has been visisted 
    x_mov = 0;
    y_mov = 0;
    % random x_move (-1 or 1)
    if round(rand)==1
        x_mov = round(rand)*2 -1;
    else
        y_mov = round(rand)*2 -1;
    end

    % size of map_state
    n = size(map_state,1);
    new_pos = zeros(1,2);
    new_pos(1) = pos(1)+x_mov;
    new_pos(2) = pos(2) + y_mov;
    for i = 1:2
        if new_pos(i)<1
            new_pos(i) = n;
        elseif new_pos(i)>n
            new_pos(i) = 1; 
        end
    end
    new_map_state = map_state; 
    new_map_state(new_pos(1),new_pos(2))=1;
end

