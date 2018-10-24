function [shorefacetally,tempgrid] = shorefacedisequilibrium (tempgrid,t,j,icrest,shorewidth)

% shorefacedisequilibrium -- calculates the volume that the shoreface is out of equilibrium
% +ve shorefacesubtally means that the substrate was eroded to produce a surplus of sediment along the profile  
% -ve shorefacaesubtally means that the substrate was accreted to produce a defecit of sediment along the profile

% Dr David Stolper dstolper@usgs.gov

% Version of 31-Dec-2002 11:47
% Updated    30-Jun-2003 11:47

global surface;
global equil;
global celldim; 

shorefacetally = 0;
ztally = 0; % sand lost or gained from a cell along the x axis   
surftract = squeeze(surface(t,:,j));
disequilibrium = surftract - equil; % determines the elevation that the tract is out of equilibrium for each i centroid.
shorewidthratio = 1;

for i = 1:icrest - 1    
    ztally = 0;           
    if disequilibrium(i) > 0 
        [tempgrid,ztally] = erode(tempgrid,disequilibrium,t,i,j,shorewidthratio);        
    end
    if disequilibrium(i) < 0
        [tempgrid,ztally] = accrete(tempgrid,disequilibrium,t,i,j);        
    end
    shorefacetally = shorefacetally + ztally; 
end

% repeat the preceeding loop for icrest (the gridcell housing the crest)  

shorewidthratio = shorewidth ./ celldim(1,j);
ztally = 0;
           
    if disequilibrium(icrest) > 0 
        [tempgrid,ztally] = erode(tempgrid,disequilibrium,t,icrest,j,shorewidthratio);
    end
    if disequilibrium(icrest) < 0
        [tempgrid,ztally] = accrete(tempgrid,disequilibrium,t,icrest,j);
    end
shorefacetally = shorefacetally + ztally; % calcultes ztally for the proportion of the icrest cell that is shoreface