function plotCompareMarshWidth(filethread1, filethread2, RSLR) 
% Run number, RSLR (mm/yr)

% Compares two plots of marsh width over time

% Ian Reeves    17-April-2017

% BUG somewhere - dont use! Use plotMarshWidthsOverTime instead -- IR 8-Jan-18

% Load files
filename = ['C:/GEOMBEST+/Output' num2str(filethread1) '/surface.mat'];
load(filename);

filename2 = ['C:/GEOMBEST+/Output' num2str(filethread1) '/xcentroids.mat'];
load(filename2);

filename3 = ['C:/GEOMBEST+/Output' num2str(filethread1) '/SL.mat'];
load(filename3)

filename4 = ['C:/GEOMBEST+/Output' num2str(filethread1) '/marshboundary.mat']; 
load(filename4)


% Extract from files
total_SLR = 10*RSLR*(numel(surface(:,1))-11); % Total sea level rise, in mm
T = numel(marshboundary);
t = [1:T]*10;
x = xcentroids(1,:); % X location of each cell

% Initialize widths array
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
        marsh_width = 6000; % If there are no cells below sea level behind the island, the total width is at its maximum, 6000 meters (Hog tract)
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

% %%%%% Find erosion rate of 2 different time periods in same run
% temp = polyfit(t(11:60),widths(11:60),1);
% slope = temp(1);
% erosionrate1 = slope
% intercept = temp(2);
% 
% temp2 = polyfit(t(61:110),widths(61:110),1);
% slope2 = temp2(1);
% erosionrate2 = slope2
% intercept2 = temp2(2);
% %%%%%


% Load files
filename = ['C:/GEOMBEST+/Output' num2str(filethread2) '/surface.mat'];
load(filename);

filename2 = ['C:/GEOMBEST+/Output' num2str(filethread2) '/xcentroids.mat'];
load(filename2);

filename3 = ['C:/GEOMBEST+/Output' num2str(filethread2) '/SL.mat'];
load(filename3)

filename4 = ['C:/GEOMBEST+/Output' num2str(filethread2) '/marshboundary.mat']; 
load(filename4)


% Extract from files
total_SLR = 10*RSLR*(numel(surface(:,1))-11); % Total sea level rise, in mm
T = numel(marshboundary);
t = [1:T]*10;
x = xcentroids(1,:); % X location of each cell

%Initialize widths array
widths2 = zeros(1,T);

% Set width of island
island_width = 275; % 275 for Hog, 150 for Metompkin(?)

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
        widths2(1,ii) = marsh_width;
end

% Simple Plot

% Plot
figure()
plot(t(11:end),widths(11:end),'LineWidth',2,'Color',[0,1,0]);
xlabel('Time (years)','FontSize',15);
ylabel('Marsh width (m)','FontSize',15);
hold on
plot(t(11:end),widths2(11:end),'LineWidth',2,'Color',[0,0,1]);
legend('Seagrass','No Seagrass');


figure()
plot(t,widths,'LineWidth',2,'Color',[0,1,0]);
xlabel('Time (years)','FontSize',15);
ylabel('Marsh width (m)','FontSize',15);
hold on
plot(t,widths2,'LineWidth',2,'Color',[0,0,1]);
legend('Seagrass','No Seagrass');



% p = polyfit(t(11:end),widths(11:end),3);
% x1 = 110:1100;
% y1 = polyval(p,x1);
% plot(x1,y1);
% 
% p2 = polyfit(t(11:end),widths2(11:end),3);
% x22 = 110:1100;
% y22 = polyval(p2,x22);
% plot(x22,y22,'Color',[1,0,0]);


% % Constrain fit through origin
% 
% x0 = 110;
% y0 = 3628;
% 
% x = t(:);
% y = widths(:);
% 
% 
% n = 2; % Degree of polynomial
% 
% V(:,n+1) = ones(length(x),1,class(x));
% 
% for j = n:-1:1
%     V(:,j) = x.*V(:,j+1);
% end
% 
% C = V;
% 
% d = y;
% 
% A = [];
% 
% b = [];
% 
% Aeq = x0.^(n:-1:0);
% 
% beq = y0;
% 
% p = lsqlin(C,d,A,b,Aeq,beq);
% 
% yhat = polyval(p,x);
% 
% plot(x(11:110),y(11:110),'b:')
% 
% hold on
% 
% plot(x0,y0,'gx','linewidth',4)
% 
% plot(x,yhat,'b','linewidth',1.5) 
% 
% 
% % Second line
% y2 = widths2(:);
% 
% d = y2;
% 
% A = [];
% 
% b = [];
% 
% Aeq = x0.^(n:-1:0);
% 
% beq = y0;
% 
% p = lsqlin(C,d,A,b,Aeq,beq);
% 
% yhat = polyval(p,x);
% 
% plot(x(11:110),y2(11:110),'r:')
% 
% plot(x0,y0,'gx','linewidth',4)
% 
% plot(x(11:91),yhat(11:91),'r','linewidth',1.5)
% 
% 
% xlabel('Time (years)','FontSize',15);
% ylabel('Marsh width (m)','FontSize',15);

end
            