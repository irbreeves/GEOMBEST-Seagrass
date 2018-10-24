function plotcrosssteps (filethread,t,j,fir,incr)

% plottract -- plots a raster representation of the tract, superimposed with a surface line  
% t = time, j = tract number, fir = the first shadow surface to plot, incr = the number of timesteps 
% between each plotted shadow barrier  

% Dr David Stolper dstolper@usgs.gov

% Version of 27-Dec-2002 16:16
% Updated    15-Apr-2003 11:32

global strat;
global surface;
global xcentroids;
global zcentroids;
global celldim;
global SL;

% load the grid representation of the tract from the hard-drive

n = int2str(t); while length(n)<4, n = ['0' n]; end
varname = ['step_' n];
filename = ['C:\Quicksand\Output' num2str(filethread) '\' varname '.mat'];
temp = load (filename , varname);
eval (['gridtimestep =  temp.' varname ';']);

L = size(gridtimestep,2);
M = size(gridtimestep,3);
N = size(gridtimestep,4);
S = size(gridtimestep,5);

% load global variables from the hard-drive if they exist 

dirname = ['C:\Quicksand\Output' num2str(filethread) '\'];

if exist([dirname 'surface.mat']) == 2
    load ([dirname 'surface.mat'])
end
if exist([dirname 'xcentroids.mat']) == 2
    load ([dirname 'xcentroids.mat'])
end
if exist([dirname 'zcentroids.mat']) == 2
    load ([dirname 'zcentroids.mat'])
end
if exist([dirname 'strat.mat']) == 2
    load ([dirname 'strat.mat'])
end
if exist([dirname 'celldim.mat']) == 2
    load ([dirname 'celldim.mat'])
end
if exist([dirname 'SL.mat']) == 2
    load ([dirname 'SL.mat'])
end
    
    
enteredj = j;

% find the maximum elevation of the gridtimestep 

for j = 1:M
    for s = 2:S+1
        if ~isempty(strat(j,s).elevation) % ensures that only existing horizons are operated on 
            maxz(s) = max(strat(j,s).elevation(:,2)); % determines the maximum z value for each horizon
        end
    end
end

j = enteredj;

overallmaxz = max(maxz); % determines the overall maximum z value 

% create tractcolor colormap

tractcolor(1,:) = [1,1,1]; % white
tractcolor(2,:) = [0.5,0.5,1]; % blue

for s = 2:S + 1
    if strcmp(strat(j,s).name,'active sand body')
        tractcolor(s + 1,:) = [1,1,0]; % yellow
    elseif strcmp(strat(j,s).name,'bay')
        tractcolor(s + 1,:) = [0,1,0]; % green
    elseif strcmp(strat(j,s).name,'strat1')
        tractcolor(s + 1,:) = [1,0,0]; % red    
    elseif strcmp(strat(j,s).name,'strat2')
        tractcolor(s + 1,:) = [1,0,1]; % magenta
    elseif strcmp(strat(j,s).name,'strat3')
        tractcolor(s + 1,:) = [0,1,1]; % cyan
    elseif strcmp(strat(j,s).name,'strat4')
        tractcolor(s + 1,:) = [0.5,0.5,0.5]; % grey
    elseif strcmp(strat(j,s).name,'strat5')
        tractcolor(s + 1,:) = [0.5,0,0]; % dark red
    end
end

colormap(tractcolor);

% create 2-D representation "tract"

if t == 1 
    for i = 1:L
        for k = 1:N
            [val,in] = max(gridtimestep(1,i,j,k,:));
            tract(k,i) = in + 2; % array of indices representing the dominant stratigraphy within each cell
            if val == 0 
                a = GreaterOrEqual(overallmaxz - k .* celldim(3,j),0);
                if a == 1 
                    tract(k,i) = 1; %air
                else
                    tract(k,i) = 2; % water
                end
            end                
        end
    end
else
    for i = 1:L
        for k = 1:N
            [val,in] = max(gridtimestep(1,i,j,k,:));
            tract(k,i) = in + 2; % array of indices representing the dominant stratigraphy within each cell
            if val == 0 
                a = GreaterOrEqual(overallmaxz - k .* celldim(3,j),SL(t-1,j));
                if a == 1;  
                    tract(k,i) = 1; %air
                else
                    tract(k,i) = 2; % water
                end
            end                
        end
    end
    
end

% determines maximum and minimum values for display

xmin = min(xcentroids) - celldim(1,j) ./ 2;
xmax = max(xcentroids) + celldim(1,j) ./ 2;
zmin = min(zcentroids) - celldim(3,j) ./ 2;
zmax = max(zcentroids) + celldim(3,j) ./ 2;

% plot routine 

hold on;
image(xcentroids,zcentroids,tract); % plot colors for the tract at time t
axis([xmin,xmax,zmin,zmax]); % set axis limits

for step = fir:incr:t
    zeds = squeeze(surface(step,:,j));
    plot1 = plot (xcentroids,zeds,'linewidth',0.5); % plot shadow surfaces
    set(plot1,'Color',[0,0,0]);
end

zeds = squeeze(surface(t,:,j));
plot1 = plot (xcentroids,zeds,'linewidth',1.5); % plot surface at step t
    
set(plot1,'Color',[0,0,0]);
xlabel('distance (m)','FontSize',10);
ylabel('elevation relative to initial sea level (m)','FontSize',10);    
    
hold off;