function [tempgrid,ztally] = erode(tempgrid,disequilibrium,t,i,j,shorewidthratio)

% erode -- erodes a single cell(x) within gridstrat. Erosion depth is limited
% by the depth-dependant response rate, the erodibility of the substrate, 
% and the degree to which the cell is out of equilibrium 

% Note: reponseprofile represents a "potential" depth-dependant response rate. 
% Thus the actual erosion depends on the erodibility of the material.
% eg. if reponseprofile = 1 and the substrate erodibility = 0.4, then the 
% substrate will be eroded 0.4 m.

% Dr David Stolper dstolper@usgs.gov

% Version of 20-Jun-2002 16:05
% Updated    10-Jun-2006 19:32

warning off MATLAB:divideByZero

global strat;
global surface;
global S;
global N;
global celldim;
global zcentroids;
global TP;
global zresponseerosion;
global SL;

newsurfcell = N; 
for k = 1:N 
    cellfill = sum(tempgrid(i,k,:));
    if cellfill ~= 0
        newsurfcell = k; % identifies the surface cell which will be eroded 1st
        break
    end
end

ztally = 0; % volume of sand released via erosion
timeremaining = TP(t); % this is the time availible to erode the substrate 

for k = newsurfcell:N -1 % loops from newsurfcell(the top of the substrate) down     
    for s = 1:S % loops through each stratigraphic unit (each cell may be comprised of several stratigraphic units)        
        if tempgrid(i,k,s)>0 %new 
            if timeremaining > 0 %ie there is time availible to erode the substrate  
                if disequilibrium(i) > 0 % ie the cell is out of equilibrium
                    zchange = zresponseerosion(k) .* strat(j,s+1).erodibility .* timeremaining; %zchange = the amount that the cell can be eroded 
                    if zchange > disequilibrium(i);
                        zchange = disequilibrium (i); % limits zchange to disequilibrium if necessary 
                    end
                    if zchange > (tempgrid(i,k,s) .* celldim(3,j));
                        zchange = (tempgrid(i,k,s) .* celldim(3,j)); % limits zchange to the thickness of sediment in the cell if necessary                    
                    end 
                    tempgrid(i,k,s) = tempgrid(i,k,s)-(zchange .*shorewidthratio ./ celldim(3,j));                    
                    if tempgrid(i,k,s) < .00001
                        tempgrid(i,k,s) = 0; %new
                    end                     
                    disequilibrium(i)= disequilibrium(i)-zchange; %    
                    timeremaining = timeremaining - ((zchange .* shorewidthratio)./(zresponseerosion(k).* strat(j,s+1).erodibility));
                    ztally = ztally + (zchange .* celldim(1,j) .* celldim(2,j) .* strat(j,s+1).sand .*shorewidthratio);
                end
            end
        end
        if k>1
            if tempgrid(i,k-1,s)>0,break,end;% ie the cell above the targeted cell has sediment in it
        end
    end     
    if timeremaining <=0,break,end; % breaks down the cells when there is no longer time availible to erode the substrate
    if disequilibrium(i) <=0,break,end; % breaks down the cells if the surface is at equilibrium                
end                 
                
