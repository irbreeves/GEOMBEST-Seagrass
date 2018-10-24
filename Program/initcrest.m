function [equil,icrest,shorewidth] = initcrest (tempgrid,t,j);

% initcrest -- 
% 1) finds the x location of the active sand body crest (estimated from tempgrid)
% 2) shifts the equilibrium values in strat to be aligned with the new crest
% 3) updates equil accordingly

% Note the active sand body crest and  Equil crest will not align perfectly
% but this is not a problem 

% the function also returns shorewidth which records the 
% "shoreface" proportion of the cell 
% holding the crest of the equilibrium profile


% Dr David Stolper dstolper@usgs.gov

% Version of 03-Jan-2003 14:57
% Updated    11-Feb-2003 11:14

global L;
global N;
global xcentroids;
global SL;
global strat;
global celldim;

% estimate the x location of the active sand body crest 

flag = 0;
for k = 1:N
    for i = 1:L
        if tempgrid(i,k,1) ~= 0
            flag = 1; % the cell has sand in it 
            valcrest = xcentroids(i); % x value(m) of the active sand body crest
            break
        end
        if flag == 1;break;end
    end
end

% find the x location of the equilibrium profile crest

equilpoints = strat(j,1).elevation; 
sortedequilpoints = sortrows (equilpoints,2); % sorts rows of equilpoints in ascending order 
equilcrest = sortedequilpoints(end,1); % determines the x value of the crest of the equilibrim profile

% shift equilpoints to align the active sand body crest and the equilibrium crest

diffcrest = valcrest - equilcrest;
equilpoints(:,1) = equilpoints(:,1) + diffcrest; % shifts the x values of the equilibrium horizon 
equilcrest = equilcrest + diffcrest; % shifts the x value of the equilibrium crest

% update equil for the new crest location  

equil = interp1(equilpoints(:,1),equilpoints(:,2),xcentroids,'linear','extrap');
equil = equil + SL(t,j);

%calculate shorewidth and backwidth

for i = 1:L
    if  xcentroids(i) + (celldim(1,j) ./ 2) >= equilcrest 
        icrest = i;
        backwidth = abs(xcentroids(i) + (celldim(1,j) ./ 2) - equilcrest);
        shorewidth = celldim(1,j) - backwidth;
        break
    end
end