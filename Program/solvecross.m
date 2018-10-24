function solvecross(t,j)

% solvecross -- searches for the location of the shoreface profile that satisfies all paramater values 
% whilst conserving sediment volume. Updates gridstrat accordingly

% Dr David Stolper dstolper@usgs.gov

% Version of 31-Dec-2002 11:03
% Updated    30-Jun-2003 11:42
% Updated       Jun-2012   by David Walters

global lmarshboundary;
global marshedge;
global marshboundary;
global gridstrat;
global surface;
global celldim;
global zcentroids;
global equil;
global TP;
global residual;
global L;
global N;

[q_ow] = getoverwashflux(t,j); % fixed volume of overwash over time
sweptvolume = 0; % temporary location
tolerance = 10; % precision (in m3) for the search algorithm  
shift = 1000; % x distance (m) that the equilibrial crest is shifted during the search algorithm
totaltally = 0; % volume of sand that the tract is out of equilibrium +ve value signifies erosion
direction = 'transgress'; % direction that the crest will be shifted
tempgrid(:,:,:) = squeeze(gridstrat(2,:,j,:,:)); % copies gridstrat
[exovol] = getexovol(t,j);
exovol = exovol .* TP(t) .* celldim(2,j); % volume of sand added to the tract from artificial or longshore sources
[equil,icrest,shorewidth] = initcrest (tempgrid,t,j); % finds highest point of island, icrest
[sweptvolume,tempgrid] = Sweepshoreface (tempgrid,icrest,t,j); % fills partially filled cells on the shoreface
[shorefacetally,tempgrid] = shorefacedisequilibrium (tempgrid,t,j,icrest,shorewidth); % erodes and accretes the shoreface until its in equilibrium
[dunevol,tempgrid,ii] = backbarrierinfill (tempgrid,t,j,icrest,shorewidth); % 
totaltally = shorefacetally - dunevol + residual(j) + exovol - sweptvolume - q_ow*TP(t); % disequilibrium (m3) for the tract for given crest location

% start of the search algorithm

while totaltally > tolerance || totaltally < tolerance * -1
       
    tempgrid(:,:,:) = squeeze(gridstrat(2,:,j,:,:)); % copies gridstrat
        
    if totaltally < tolerance .* -1 % transgress the barrier        
        if strcmp (direction,'prograde'), shift = shift ./ -2; end
        [icrest,shorewidth] = setcrest (tempgrid,t,j,shift);
        direction = 'transgress';        
    end
    
    if totaltally > tolerance % prograde the barrier       
        if strcmp (direction,'transgress'), shift = shift ./ -2; end
        [icrest,shorewidth] = setcrest (tempgrid,t,j,shift);
        direction = 'prograde';        
    end 
    
    totaltally = 0;    
    [sweptvolume,tempgrid] = Sweepshoreface (tempgrid,icrest,t,j);
    [shorefacetally,tempgrid] = shorefacedisequilibrium (tempgrid,t,j,icrest,shorewidth);
    [dunevol,tempgrid] = backbarrierinfill (tempgrid,t,j,icrest,shorewidth);
    totaltally = shorefacetally - dunevol + residual(j) + exovol - sweptvolume - q_ow*TP(t); % disequilibrium (m3) for the tract for given crest location
end

gridstrat(2,:,j,:,:) = tempgrid(:,:,:);
residual(j) = totaltally; % the residual volume from the search algorithm

% update surface
for i = 1:L        
    for k = 1:N
       celltotal = sum(gridstrat(2,i,j,k,:));

        if celltotal ~= 0
            surface(t + 1,i,j) = zcentroids(k) - (celldim(3,j) ./ 2) + (celltotal .* celldim(3,j));            
            break
        end
    end       
end

% update shorelines
findshoreline(t,j);
% update marshedge
marshboundary(t) = marshedge(2);
lmarshboundary(t) = marshedge(1);
