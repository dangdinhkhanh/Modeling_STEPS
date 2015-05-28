classdef Walkers < handle
    % Implements all the walkers moving on a torrus according STEPS
    % mobility model
    
    properties
        walkers_positions
        d_cdf
        attachment_zone
        alpha
        nb_walkers
        grid_size
        d_max
    end
    
    methods
        
        function self = Walkers(nb_walkers, grid_size, alpha, attachment_zone)
            % Parameters initialisation
            self.nb_walkers = nb_walkers;
            self.grid_size = grid_size;
            self.alpha = alpha;
            self.attachment_zone = attachment_zone;
            
            % Uniform initialisation for walkers positions
            self.walkers_positions = randi(self.grid_size,self.nb_walkers,2)-1;
            
            % Matrix d_cdf (culmulative probability distribution of distance) serves for the calculation of new zone
            self.d_max = floor(self.grid_size/2);
            for i=1:length(self.nb_walkers)
                beta = sum((1 + (0:self.d_max)).^(-self.alpha(i)))^-1;
                aux = beta*((0:self.d_max)' + 1).^(-self.alpha(i));
                C = sum(triu(repmat(aux,1,self.d_max+1)));
                self.d_cdf = cat(1,self.d_cdf,repmat(C,self.nb_walkers(i),1));
            end
        end
        
        %------------------------------------------------------------------
        % Function generating new random zone coords following the power law 
        %                 P(x) = beta*x^(-alpha)
        %------------------------------------------------------------------
        function new_coords = move(self)
            R = rand(self.nb_walkers,1);
            RR = repmat(R,1,self.d_max+1);
            
            distance = self.d_max + 1 - sum(RR <= self.d_cdf,2);
            r = [randi(4,self.nb_walkers,1);-1]; % padding -1 for the case where there is 1 node, the right hand element of equation D(r==x,:) has size (0,2) when distance(r==x) is empty
            r(distance == 0) = 0; % the following process is wrong for d=0

            D = zeros(self.nb_walkers,2);
            D(r==1,:) = [-distance(r==1).*ones(size(distance(r==1))) floor(rand(size(distance(r==1)))*2.*distance(r==1))-distance(r==1)];
            D(r==2,:) = [floor(rand(size(distance(r==2)))*2.*distance(r==2))-distance(r==2) distance(r==2).*ones(size(distance(r==2)))];
            D(r==3,:) = [distance(r==3).*ones(size(distance(r==3))) floor(rand(size(distance(r==3)))*2.*distance(r==3))-distance(r==3)+1];
            D(r==4,:) = [floor(rand(size(distance(r==4)))*2.*distance(r==4))-distance(r==4)+1 -distance(r==4).*ones(size(distance(r==4)))];

            new_coords(:,1) = self.attachment_zone(:,1) + D(:,1);
            new_coords(:,2) = self.attachment_zone(:,2) + D(:,2);

            new_coords(new_coords < 0) = new_coords(new_coords < 0) + self.grid_size;
            new_coords(new_coords >= self.grid_size) = new_coords(new_coords >= self.grid_size) - self.grid_size;
        end       
        
        %% Tools and test methods
        
        %------------------------------------------------------------------
        % Function returning the shortest distance between 2 points X, Y in
        % a torus and the angle created by the line XY and axe Ox. 
        %  - X,Y : matrix containing the coordinates of points 
        %  - Z : a filter, only X(Z,:) and Y(Z,:) are useful
        %------------------------------------------------------------------
        function [direction, distance] = shortest_distance_torus(self, X, Y)
            dX = Y(:,1) - X(:,1);
            dY = Y(:,2) - X(:,2);
            
            field_size = self.grid_size;
           
            C1 = [X(:,1) + dX X(:,2) + dY];
            C2 = [X(:,1) + dX X(:,2) + (-dY./abs(dY)).*(field_size - abs(dY))];
            C3 = [X(:,1) + (-dX./abs(dX)).*(field_size - abs(dX)) X(:,2) + (-dY./abs(dY)).*(field_size - abs(dY))];
            C4 = [X(:,1) + (-dX./abs(dX)).*(field_size - abs(dX)) X(:,2) + dY];
            
            C = zeros(size(X));
            C(abs(dX) < field_size - abs(dX) & abs(dY) < field_size - abs(dY),:) = C1(abs(dX) < field_size - abs(dX) & abs(dY) < field_size - abs(dY),:);
            C(abs(dX) < field_size - abs(dX) & abs(dY) >= field_size - abs(dY),:) = C2(abs(dX) < field_size - abs(dX) & abs(dY) >= field_size - abs(dY),:);
            C(abs(dX) >= field_size - abs(dX) & abs(dY) >= field_size - abs(dY),:) = C3(abs(dX) >= field_size - abs(dX) & abs(dY) >= field_size - abs(dY),:);
            C(abs(dX) >= field_size - abs(dX) & abs(dY) < field_size - abs(dY),:) = C4(abs(dX) >= field_size - abs(dX) & abs(dY) < field_size - abs(dY),:);
            
            distance = ones(size(X,1),1)*-1;
            direction = ones(size(X))*-1;
            
            distance = sqrt(sum((C - X).^2,2));
            direction = [(C(:,1) - X(:,1))./distance (C(:,2) - X(:,2))./distance];
        end
        
    end
    
    methods (Static)
        function d = testPowerLaw
            
            number_of_nodes = 1000;
            grid_size = 10000;
            alpha = 1;
            attachment_zone = repmat([2 2],number_of_nodes,1);
       
            group = Walkers(number_of_nodes, grid_size, alpha, attachment_zone);
            new_zone = group.move()
            
            [Z d] = group.shortest_distance_torus(new_zone,attachment_zone);
            
            figure(1)
            hist(d,max(d)+1)
        end
    end
    
end

