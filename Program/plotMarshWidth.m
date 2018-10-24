function plotMarshWidth(filethread,RSLR) 
% Run number, RSLR (mm/yr)

% Plots marsh width over time

% Ian Reeves    17-April-2017



% Load files
filename = ['C:/GEOMBEST+/Output' num2str(filethread) '/surface.mat'];
load(filename);

filename2 = ['C:/GEOMBEST+/Output' num2str(filethread) '/xcentroids.mat'];
load(filename2);

filename3 = ['C:/GEOMBEST+/Output' num2str(filethread) '/SL.mat'];
load(filename3)

filename4 = ['C:/GEOMBEST+/Output' num2str(filethread) '/marshboundary.mat']; 
load(filename4)


% Extract from files
total_SLR = 10*RSLR*(numel(surface(:,1))-11); % Total sea level rise, in mm
T = numel(marshboundary);
t = [1:T]*10;
x = xcentroids(1,:); % X location of each cell

%Initialize widths array
widths = zeros(1,T);

% Set width of island
island_width = 400; % 400 for Hog, 150 for Metompkin(?)

for ii = 1:T
    
    y_final = surface(ii,:); % Surface elevation from each time step
    numcell = numel(y_final); % Number of surface cells
    
    % Find island front cell
    for n = 1:numcell
        if y_final(n) >= SL(ii)
            x_islandfront = n; % The first cell above sea level gives the X location of the shoreline at the island front
            break
        end
    end

    x_islandback = numel(x);

    % Find island back cell
    for n = x_islandfront:numcell
        if y_final(n) < SL(ii) - 0.25
            x_islandback = n - 1; % The first cell past the island front that is below sea level gives the X location of the first estuarine cell
            break
        else
            n = n + 1;
        end
    end

    residual = ((y_final(x_islandback) - (SL(ii) - 0.4)) / 0.9)*50; 


    % Find width of all subaerial cells
    if x_islandback == numel(x)
        marsh_width = 12000; % If there are no cells below sea level behind the island, the total width is at its maximum, 12000 meters (Hog tract)
    else
        subaerial_width = x(x_islandback - 1) + residual - x(x_islandfront); % The total subaerial width is equal to the distance from the island front to the first estuarine cell 

        % Calculate marsh width
        marsh_width = subaerial_width - island_width; % The marsh width is the total subaerial width minus the island width

        if marsh_width < 0
            marsh_width = 0; % If the islandwidth has narrowed, marsh width is zero
        end      
    end       
        widths(1,ii) = marsh_width;
end

% %%%%%% Find erosion rate of run
% temp = polyfit(t(11:end),widths(11:end),1);
% slope = temp(1);
% erosionrate = slope
% intercept = temp(2);
% %%%%%%

% %%%%%% Find erosion rate of 2 different time periods in same run
% temp = polyfit(t(11:60),widths(11:60),1);
% slope = temp(1);
% erosionrate1 = slope
% intercept = temp(2);
% 
% temp2 = polyfit(t(61:110),widths(61:110),1);
% slope2 = temp2(1);
% erosionrate2 = slope2
% intercept2 = temp2(2);
% %%%%%%

% Plot
plot(t(11:end),widths(11:end));
xlabel('Time (years)','FontSize',15);
ylabel('Marsh width (m)','FontSize',15);


end
            