function [icrest,shorewidth] = setcrest (tempgrid,t,j,shift)

% setcrest -- updates equil by shifting the x values by the distance
% specified by "shift". Finds the new location of icrest(the cell along  
% the x axis in which the crest resides)   

% the function also returns shorewidth which records the 
% proportion of the equilibrium crest cell that is comprised of 
% the shoreface section of the equilibrium profile 

% Dr David Stolper dstolper@usgs.gov

% Version of 05-Nov-2002 16:48
% Updated    11-Feb-2003 11:14

global strat;
global xcentroids;
global equil;
global SL;
global L;
global celldim;

equilpoints(:,2) = strat(j,1).elevation(:,2);
equilpoints(:,1) = strat(j,1).elevation(:,1) + shift; % shifts the points defining the equilibrial horizon 
equil = interp1(equilpoints(:,1),equilpoints(:,2),xcentroids,'linear','extrap'); % creates a vector of z values located at the centroid of each cell
equil = equil + SL(t,j);

strat(j,1).elevation(:,1) = strat(j,1).elevation(:,1) + shift;

sortedequilpoints = sortrows (equilpoints,2); % sorts rows of equilpoints in ascending order 
equilcrest = sortedequilpoints(end,1); % determines the x value of the crest of the equilibrim profile

% calculate shorewidth and backwidth

% initialise variables to be aligned with landwards cell

icrest = L;
shorewidth = celldim(1,j) ./ 2;
backwidth = celldim(1,j) ./ 2;

for i = 1:L
    if  xcentroids(i) + (celldim(1,j) ./ 2) >= equilcrest % the = is new 
        block = 0;
        backwidth = abs(xcentroids(i) + (celldim(1,j) ./ 2) - equilcrest);
        shorewidth = celldim(1,j) - backwidth;
        icrest = i;
        break
    end
end