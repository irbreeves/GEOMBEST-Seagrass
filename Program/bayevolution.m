 function [tempgrid,marshvol,icrest,targetDepth] = bayevolution(icrest,tempgrid,t,j,TP)

% Updates the bay surface and calculates the volume of sediment eroded (to
% be added to the marsh). Modified for seagrass. The bay adjusts instantaneously to the equilibrium
% depth as a function of fetch using a lookup table, if there is enough sediment available to do so when accreting.
% If not enough sediment is available to accrete the bay up to its EQ depth, it accretes as much as 
% it can using all the bay sediment flux, with SG meadow cells accreting a maximum of 1.25x more than
% bare bay bottom cells.

% Ian Reeves
% Version of 14-June-2017


global celldim;
global SL;
global zcentroids;
global L;
global fetch;
global seagrass;
global bay;
global depth_lookup;
global bvol;



[q_b] = getbaysedflux(t,j); % Volume of sediment added to the estuary from riverine input
mwl = SL(t,j); % Mean Water Level - the minimum depth at which the marsh will grow
tempvol = q_b * TP(t); 
baycell = 0; % Initiate baycell to count the number of bay cells to be accreted onto
a = 1;
bay = 0;

% Find location and count cells of bay
for ii = icrest : L
    % Find all topcells underneath Sea Level
    realratio = sum(tempgrid(ii,:,:),3); % Fraction of sediment in each cell of the column at the limit of the dune
    topcell = find(realratio == 1); % Find the first full cell

    topcell = topcell(1) - 1; % Boundary cell that is partially filled or empty
    k = topcell;

    cellfill = sum(tempgrid(ii,k,:),3); % Fraction of sediment in the topcell

    H =(zcentroids(k) - celldim(3,j)./ 2) + cellfill*celldim(3,j); % height to the topcell

    if H <= mwl
        baycell = baycell + 1; % Count the number of bay cells below sea level
        bay(a) = ii;   % Store x-axis location of bay cell in bay array
        a = a+1;
    end  
end

% Initialize empty seagrass array for first time step
seagrass = growseagrass(icrest,tempgrid,t,j);


%%% Calculate accretion height (estrate)
targvol = tempvol / baycell; % Distribute the riverine input of sediment over each baycell
estrate = targvol / celldim(1,j); % Maximum height to which each baycell can be accreted
newestrate = estrate;

xtra = [];

% Calculate fetch
fetch = baycell*celldim(1,j); % Number of baycells below sea level * x cell dimension (m)
    
%%% Calculate effective fetch
if seagrass(:) == 0 % If no seagrass, effective fetch = full fetch
    effectiveFetch = fetch;
else % If seagrass in bay, attenuate wave height and find effective fetch
    [Lfetch_effective,Rfetch_effective] = attenuation(tempgrid,t,j);   
    effectiveFetch = (Lfetch_effective+Rfetch_effective)/2;

    %%% Count seagrass cells that are able to accreate 1.25x more than bare bay bottom cells (don't give extra sed to SG cells that can reach EQ depth without it)
    seagrassloc = find(seagrass); % Array with locations of seagrass cells
    xtracount = 0; % Initialize count

    for xx = seagrassloc(1):seagrassloc(end)
        % Calculate depth
        realratio = sum(tempgrid(xx,:,:),3); % The amount of sediment in a cell
        topcell = max(find(realratio == 0));
        topcell = topcell + 1; % The first cell with sediment
        k = topcell;
        realratio = sum(tempgrid(xx,k,:),3); % The amount of sediment in the topcell
        H =(zcentroids(k) - celldim(3,j) ./ 2) + realratio*celldim(3,j);
        depth = SL(t,j)-H; %(m)

        % Calculate height difference between current depth and new equilibrium depth
        findex = 0:50:40000;
        ef = round(effectiveFetch/50)*50; % Round depth to nearest 0.05
        f = round(fetch/50)*50;
        
        
        targetDepth = depth_lookup(find(findex==ef),3); % Use lookup table for depth as function of fetch - with seagrass        

        accretionHeight = targetDepth - depth; % (m) Height changed needed for cell to be at its equilibrium depth; (+)value = erosion, (-)value = accretion

        % Determine whether cell has room to accomodate extra sediment (don't add extra to cells that can reach EQ depth without it)
        if accretionHeight < estrate*(-1)
            xtracount = xtracount+1; % Count number of cells that get extra 25% sediment
            xtra = [xtra xx]; % Store location of cell that receives extra sediment; these are the seagrass cells that will accrete 1.25x more sediment than bare cells
        end

        % Re-calculate accretion height (estrate), accounting for extra sediment
        targvol = tempvol / (baycell+(xtracount*0.25)); % Distribute the riverine input of sediment over each baycell
        newestrate = targvol / celldim(1,j); % Maximum height to which each baycell can be accreted
    end
end


%%% ACCRETE/ERODE
% Loop through each cell and deposit or erode sed in cell to reach its new
% equilibrium depth 

erodedvol = 0; % Initialize volume eroded 

for ii=icrest :L
    % Find the top horizon of the bay
    realratio = sum(tempgrid(ii,:,:),3); % Amount of sediment in a cell
    topcell = max(find(realratio == 0)); 
    topcell = topcell + 1; % The first cell with sediment
    
    k = topcell;
    realratio = sum(tempgrid(ii,k,:),3); % Amount of sediment in the topcell
    
    % Calculate depth of cell
    H =(zcentroids(k) - celldim(3,j) ./ 2) + realratio*celldim(3,j);
    depth = SL(t,j)-H; %(m)
    
 
    % Calculate height difference between current depth and new equilibrium depth
    findex = 0:50:40000;
    ef = round(effectiveFetch/50)*50; % Round depth to nearest 0.05
    f = round(fetch/50)*50;          
    
    
    if seagrass(ii) > 0 % If there was seagrass in this cell in prior time step (this is still seagrass meadow from  t-1)
        targetDepth = depth_lookup(find(findex==ef),3); % Use lookup table for depth as function of fetch - with seagrass        
    else % If no seagrass meadow in prior time step
        targetDepth = depth_lookup(find(findex==ef),2); % Use lookup table for depth as function of fetch - without seagrass  
    end
    
    
    % Find depth to surface of uppermost sand layer (i.e. maximum erosion depth, b/c sand is not moved in the bay)
    realsandratio = tempgrid(ii,:,1); % Amount of sand in a cell
    topsandcell = max(find(realsandratio ~= 0));
    topsandcell = topsandcell - 1;
    ksand = topsandcell; % Uppermost sand layer
    if ksand ~= 0
        realsandratio = tempgrid(ii,ksand,1); % Amount of sand in topcell
        Hsand = ((zcentroids(ksand) - celldim(3,j)) ./ 2) + realsandratio*celldim(3,j);
        depthsand = SL(t,j) - Hsand; % Depth to surface of sand layer
    end
    
    
    % Increase estrate if cell is in xtra array
    if any(ii==xtra) == 1
        estrate = newestrate*1.25;
    else
        estrate = newestrate; 
    end
    
    
    % Calculate erosion
    if targetDepth > (depth-estrate) | t < 11 % If erosion needed to reach EQ depth   <--- Use '| t < 11'  to allow bay to reach EQ depth by start of simulation (no sed conservation in spin-up); comment out otherwise
        toperosion = targetDepth - (depth-estrate); % Height bay needs to erode to reach EQ depth
        if isempty(toperosion)== 0 & ksand ~= 0
            if toperosion > depthsand - (depth-estrate) % Sand is not moved in the bay; enforce depthsand as the maximum erosion depth
                toperosion = depthsand - (depth-estrate);
            end
        end    
    elseif targetDepth <= (depth-estrate) % No erosion will occur if bay needs to accrete a height greater than estrate to reach EQ depth
        toperosion = 0;
    end

    
    if depth <= 0 % If subaerial, no erosion
        toperosion = 0;
    end
    
    if exist('toperosion') == 0
        toperosion = 0;
    end
   
    temperosion = toperosion;
    
    
    % Calculate height change
    dheight = estrate - toperosion; % Accretion - erosion; (+)value = deposition, (-)value = accretion
    
    if dheight > 0
        tempgrid = deposition(tempgrid,t,ii,j,dheight);
    end
    
    if depth >= 0 % If cell is subaqueous (bay), erode down to equilibrium depth and save eroded sediment
        [erodedvol,tempgrid] = erosion(erodedvol,tempgrid,t,ii,j,k,dheight,temperosion); 
    end 
    
end        



marshvol = erodedvol / 2; % Divide by 2 to distribute eroded sed equally between the 2 marshes

if baycell <= 2
    marshvol = tempvol/2;
end

bvol = erodedvol;

end


