function widths = MarshWidthOverTime(filethread,RSLR,TS) 
% Run number, RSLR, Number of time steps

% Calculates the marsh width at the end of each time step

% Ian Reeves 8-May-2017

% Set width of island
island_width = 400; % 400 for Hog, 150 for Metompkin 
fullwidth = 6000; % Width of back-barrier basin: 6000 for Hog, 2000 for Metompkin

    % Load files
    filename = ['C:/GEOMBEST+/Output' num2str(filethread) '/surface.mat'];
    load(filename);

    filename2 = ['C:/GEOMBEST+/Output' num2str(filethread) '/xcentroids.mat'];
    load(filename2);

    filename3 = ['C:/GEOMBEST+/Output' num2str(filethread) '/SL.mat'];
    load(filename3)

    widths = zeros(1,TS);

    for t = 2:TS+1

        % Extract from files
        total_SLR = 10*RSLR*(numel(surface(:,1))-11); % Total sea level rise, in mm
        x = xcentroids(1,:); % X location of each cell
        y = surface(t,:); % Surface elevation from the final time step
        numcell = numel(y); % Number of surface cells


        % Find island front cell
        for n = 2:numcell
            if y(n) >= SL(t-1)
                x_islandfront = n; % The first cell above sea level gives the X location of the shoreline at the island front
                break
            end
        end
        
        x_islandback = numel(x);

        % Find island back cell
        for n = x_islandfront:numcell
            if y(n) < SL(t-1) - 0.25 & n>2
                x_islandback = n - 1; % The first cell past the island front that is below sea level gives the X location of the first estuarine cell
                break
            else
                n = n + 1;
            end
        end

        residual = ((y(x_islandback) - (SL(t-1) - 0.4)) / 0.9)*50; 

        % Find width of all subaerial cells
        if x_islandback == numel(x)
            marsh_width = fullwidth; % If there are no cells below sea level behind the island, the total width is at its maximum, 12000/2 = 6000 for Hog
        else
            subaerial_width = x(x_islandback - 1) + residual - x(x_islandfront); % The total subaerial width is equal to the distance from the island front to the first estuarine cell 

            % Calculate marsh width
            marsh_width = subaerial_width - island_width; % The marsh width is the total subaerial width minus the island width

            if marsh_width < 0
                marsh_width = 0; % If the islandwidth has narrowed, marsh width is zero
            end     
        end       

        widths(1,t) = marsh_width;

    end
    
    widths = widths(2:end);
     
    
%     T = 0:10:(TS*10);
%     T = T(2:end);
%     
%     plot1 = plot(T, widths,'LineWidth',2);
%     hold all;
%     
%     
% 
% 
% set(gca,'fontsize',13);
% xlabel({'Time (yrs)'},'FontSize',14);
% ylabel({'Marsh Width (m)'},'FontSize',14);

% % Print final width            
% fprintf('\nMarsh widths: %.2f', widths);  


end
            
            
            
            
            