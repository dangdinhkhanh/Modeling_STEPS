function vector_base = compute_distrib(alpha,grid_size)


    d_max = floor(grid_size/2);
    beta = sum((1 + (0:d_max)).^(-alpha))^-1;

    %vector_base = 1:grid_size^2;
    vector_base = zeros(grid_size^2,1);
    vector_base(1) = beta;

    if mod(grid_size,2)==1
        for i=1:d_max

            for j=((2*i-1)^2+1):(2*i+1)^2

                vector_base(j) = beta / (8 * i * (i+1)^alpha);

            end

        end
    else
        for i=1:(d_max-1)

            for j=((2*i-1)^2+1):(2*i+1)^2

                vector_base(j) = beta / (8 * i * (i+1)^alpha);

            end

        end
        %furthest zones number
        zones_number = (2*d_max)^2-(2*d_max-1)^2;
        for j= ((2*d_max-1)^2+1):(2*d_max)^2
            vector_base(j) = beta / (zones_number * (d_max+1)^alpha);
        end
    end
end
% disp(sum(vector_base));