  function [tempgrid,redepvol,targetDepth,icrest] = erodemarsh (icrest,tempgrid,t,j,tt,TP,targetDepth)
% erodemarsh - Erodes the edges of the marsh based on wave power. Seagrass meadow in the bay reduces
% the wave to power reaching the marsh edges and thus reduces the volume of marsh eroded. 50% of marsh
% sediment eroded is organic matter and is lost from the system when eroded. Sand is redeposited in same location. The remaining eroded 
% sediment will be used to rebuild the marsh.

% Modified for seagrass from RL version 

% Ian Reeves
% 24-Jan-2017
% Version of 21-July-2017


global celldim;
global fetch;
global zcentroids;
global xcentroids;
global SL;
global dunelimit;
global L;
global bay;
global seagrass;
global mvol; % Meadow volume statistic for each time step
global evol; % Volume of fine and organic sed eroded from marsh edge for each time step
global ovol; % Volume of organic sed eroded in each time step
global RerosionDist; % Width of marsh after erodemarsh but before growmarsh
global depthB; % Average bare depth
global erodecell;
global eroderesid;

fillkeep = 0;
ovol = 0;

% Grow new seagrass in suitable parts of the bay
seagrass = growseagrass(icrest,tempgrid,t,j);

if ((t == 1 && tt > 1) || t > 1) && length(bay) >= 3 % No marsh erosion on first time step or when bay is tiny
    
    rbay = bay(1); % First cell in bay on right
    lbay = bay(length(bay)); % Last cell in bay on left
    rmarsh = rbay - 1; % Edge of marsh
    lmarsh = lbay + 1; % Edge of marsh
    highwater = SL(t,j) + gethighwater(t,j);
    meadowWidth = nnz(seagrass)*celldim(1,j); % (m) Width of seagrass bed    
    meadowDepth = 0; % Initialize, height of meadow

    %%% Calculate average depth of whole bay
    for i = rbay:lbay % For each cell in the bay
        realratio = sum(tempgrid(i,:,:),3); % Amount of sed in each cell of column i
        topcell = find(realratio == 1);
        topcell = topcell(1) - 1; % Top cell with sediment
        k = topcell;
        realratio = sum(tempgrid(i,k,:),3); % Amount of sediment in topcell
        H = (zcentroids(k)-celldim(3,j)./2)+ realratio*celldim(3,j); % Height
        depth(i+1-rbay) = SL(t,j)-H; % (m)
        if seagrass(i) > 0
            dsg = SL(t,j)-H;
            meadowDepth = dsg; % Depth of the seagrass portion of the bay
        else
            baredepth(i+1-rbay) = SL(t,j)-H; % (m)
        end
    end
    avgdepth = sum(depth)/length(depth); % Average depth of whole bay
    avgbaredepth = sum(baredepth)/(length(baredepth)-nnz(seagrass)); % Depth of the bare portions of the bay
    
    depthB = avgbaredepth;
    
    
    %%% Calculate Wave power 
    
    U = getwindspeed(t,j); % (m/s)
    g = 9.81; % (m/s^2)
    gamma = 9810; % Specific weight of water (N/m^3)
    kerode = geterosioncoeff(t,j); % Varies per site (units m3/W/yr)

    if meadowWidth == 0 | t < 11 % If there is no seagrass in bay
        Hwave = (((U^2)*0.2413)*(tanh(0.493*((g*avgdepth)/(U^2))^0.75)*tanh((0.00313*((g*fetch)/(U^2))^0.57)/tanh(0.493*((g*avgdepth)/(U^2))^0.75)))^0.87)/g; % Wave height of whole bay (m)
        rWpower = (gamma/16)*Hwave.^2*(g*avgdepth).^0.5; % Right wave power
        lWpower = rWpower; % Left wave power, equal to right if no seagrass
        avgRdepth = avgdepth;
        avgLdepth = avgdepth;
    else % If seagrass meadow in bay
        % Attenuate waves, find effective fetches
        [Lfetch_effective,Rfetch_effective,avgLdepth,avgRdepth] = attenuation(tempgrid,t,j);
        
        % Waves propogating towards right (island) side of bay
        rHeff = (((U^2)*0.2413)*(tanh(0.493*((g*avgdepth)/(U^2))^0.75)*tanh((0.00313*((g*Rfetch_effective)/(U^2))^0.57)/tanh(0.493*((g*avgdepth)/(U^2))^0.75)))^0.87)/g; % Re-calculate total wave height using effective fetch
        rWpower = (gamma/16)*rHeff.^2*(g*avgdepth).^0.5; % Re-calculate total wave power using effective fetch
        
        % Waves propogating towards left (mainland) side of bay
        lHeff = (((U^2)*0.2413)*(tanh(0.493*((g*avgdepth)/(U^2))^0.75)*tanh((0.00313*((g*Lfetch_effective)/(U^2))^0.57)/tanh(0.493*((g*avgdepth)/(U^2))^0.75)))^0.87)/g; % Re-calculate total wave height using effective fetch
        lWpower = (gamma/16)*lHeff.^2*(g*avgdepth).^0.5; % Re-calculate total wave power using effective fetch
    end
    
    
    %%% Calculate marsh erosion volumes (amount of sediment to be eroded from each marsh)
    
    Rerodevol = rWpower*kerode*celldim(1,j)*TP(t); % Sediment that can be eroded based on wave power (m^3); right bay
    Lerodevol = lWpower*kerode*celldim(1,j)*TP(t); % Left bay

    evol = Rerodevol; % To save statistic of volume of fine and organic sed eroded from marsh edge for each time step

    
    %%% Erode the Right marsh
    ii = rmarsh; % right edge of marsh
    
    % Find depth of cell next to marsh boundary
    b = rbay; %bay cell adjacent to marsh boundary
    realratio = sum(tempgrid(b,:,:),3);
    topcell = find(realratio == 1);
    topcell = topcell(1) - 1; %partially full boundary cell
    k = topcell;
    cellfill = sum(tempgrid(b,k,:),3); %sed in boundary cell
    H = ((zcentroids(k) - celldim(3,j) ./ 2)) + cellfill*celldim(3,j);
    baydepth = highwater - H; %depth of adjacent bay cell from highwater line (not MSL)
    
    tempevol = Rerodevol;
    fillsand = 0;
    fillkeep = 0;
    
    while tempevol > 0
        %find boundary cell
        realratio = sum(tempgrid(ii,:,:),3); %fraction of sed in each cell of at right edge of marsh
        topcell = find(realratio == 1); %first full cell at right edge of marsh
        topcell = topcell(1)-1; %partially full boundary cell
        
        %find volume of boundary cell
        n = topcell;
        cellfill = sum(tempgrid(ii,n,:),3); %fraction of all sed in topcell
        fillmud = tempgrid(ii,n,3);
        fillmarsh = tempgrid(ii,n,2); %marsh is half organic half mud

        H = ((zcentroids(n) - celldim(3,j)./2)) + cellfill*celldim(3,j); %height to surface
        
%         targete = baydepth - (highwater-H); %amount that one column can be eroded
        targete = avgbaredepth - (highwater - H);                                            
%         targete = targetDepth - (highwater - H); 
        
        while targete > 0
            if tempgrid(ii,n,4) == 1
                tempevol = 0;
            end
            if tempevol > (fillmarsh+fillmud)*celldim(3,j)*celldim(1,j) %if there is enough erosion potential, empty the cell
                fillsand = fillsand + tempgrid(ii,n,1);
                tempgrid(ii,n,1:3) = 0; %empties cell by setting equal to zero
                fillkeep = fillkeep + (fillmud + (fillmarsh/2))*celldim(3,j)*celldim(1,j); % Divide by 2 --> 50% of marsh sed (organic fraction) lost from system
                ovol = ovol + (fillmarsh*celldim(3,j)*celldim(1,j));
                tempevol = tempevol - (fillmud+fillmarsh)*celldim(3,j)*celldim(1,j);
                n = n + 1; %proceed to cell below
                fillmud = tempgrid(ii,n,3);
                fillmarsh = tempgrid(ii,n,2);
                H = (zcentroids(n) + celldim(3,j)./2); %update height of sed surface
                
%                 targete = baydepth - (highwater - H);
                targete = avgbaredepth - (highwater - H); %update amount left to erode                     
%                 targete = targetDepth - (highwater - H);
                
                
            else
                %subtract marsh first
                %then subtract bay
                %then deposit sand - right now this includes sand from this cell, make sure to account for that
                % if not enough erosion potential to erode whole cell, erode as much as you can
                if tempevol > fillmarsh*celldim(3,j)*celldim(1,j)
                    tempgrid(ii,n,2) = 0;
                    tempevol = tempevol - fillmarsh*celldim(3,j)*celldim(1,j);
                    fillkeep = fillkeep + (fillmarsh/2)*celldim(3,j)*celldim(1,j); % Divide by 2 --> 50% of marsh sed (organic fraction) lost from system
                    ovol = ovol + (fillmarsh*celldim(3,j)*celldim(1,j));
                    fillmarsh = 0;
                    
                else
                    tempgrid(ii,n,2) = tempgrid(ii,n,2) - (tempevol/(celldim(3,j)*celldim(1,j)));
                    fillkeep = fillkeep + (tempevol/2);
                    tempevol = 0;
                end
                if tempevol > fillmud*celldim(3,j)*celldim(1,j)
                    tempgrid(ii,n,3) = 0;
                    fillkeep = fillkeep + fillmud*celldim(3,j)*celldim(1,j);
                    tempevol = tempevol - fillmud*celldim(3,j)*celldim(1,j);
                    fillmud = 0;
                else
                    tempgrid(ii,n,3) = tempgrid(ii,n,3) - (tempevol/(celldim(3,j)*celldim(1,j)));
                    fillkeep = fillkeep + tempevol;
                    tempevol = 0;
                    
                end
                
                fillsand = fillsand + tempgrid(ii,n,1);
                tempgrid(ii,n,1) = 0;
                break
                
            end
    
        end
        %deposit sand before moving over a column
        cellfillnew = sum(tempgrid(ii,n,:),3);
        while fillsand > 0
            if fillsand > 1 - cellfillnew
                tempgrid(ii,n,1) = 1 - cellfillnew;

                fillsand = fillsand - (1 - cellfillnew);
                n = n - 1;
                cellfillnew = 0;
            else
                tempgrid(ii,n,1) = fillsand;
                fillsand = 0;
            end
        end
        
        if ii > dunelimit
            ii = ii - 1; %continue to next column on right
            fillsand = 0;
        else
            break
        end

        
        
    end
    
    fillkeepright = fillkeep;
    erodecell = ii;
    
    realratio = sum(tempgrid(erodecell,:,:),3); % Amount of sed in each cell of column i
    topcell = find(realratio == 1);
    topcell = topcell(1) - 1; % Top cell with sediment
    k = topcell;
    realratio = sum(tempgrid(erodecell,k,:),3); % Amount of sediment in topcell
    Hback = (zcentroids(k)-celldim(3,j)./2)+ realratio*celldim(3,j); % Height
    residual = ((Hback - (SL(t-1) - 0.4)) / 0.9)*50;
    eroderesid = residual * (-1);
    
%     RerosionDist = (rmarsh - erodecell)*celldim(1,j) + eroderesid;
    RerosionDist = (rmarsh - erodecell)*celldim(1,j);
    
    %%% Erode the Left marsh
    
    ii = lmarsh;
    
    %find depth of cell next to marsh boundary
    b = ii-1; %bay cell adjacent to marsh boundary; what about when bay is full?
    realratio = sum(tempgrid(b,:,:),3);
    %topcell = find(realratio == 0,1,'last');
    %topcell = topcell + 1; %partially full boundary cell
    topcell = find(realratio == 1);
    topcell = topcell(1) - 1;
    k = topcell;
    cellfill = sum(tempgrid(b,k,:),3); %sed in boundary cell
    H = (zcentroids(k)-celldim(3,j)./2)+cellfill*celldim(3,j);
    lbaydepth = highwater - H; %depth of adjacent bay cell from highwater line (not MSL)
    
    tempevol = Lerodevol;
    fillsand = 0;
    
    while tempevol > 0
        %find boundary cell
        realratio = sum(tempgrid(ii,:,:),3); %fraction of sed in each cell
        topcell = find(realratio == 1); %first full cell
        topcell = topcell(1)-1; %partially full boundary cell
        
        %find volume of boundary cell
        n = topcell;
        cellfill = sum(tempgrid(ii,n,:),3); %fraction of sed in topcell
        %     fillsand = fillsand + tempgrid(ii,n,1);
        fillmud = tempgrid(ii,n,3);
        fillmarsh = tempgrid(ii,n,3);
        %     fillkeep = fillkeep + fillmud+(fillmarsh/2);
        
        H = ((zcentroids(n) - celldim(3,j)./2)) + cellfill*celldim(3,j); %height to surface
        
%         targete = lbaydepth - (highwater-H);
        targete = avgbaredepth - (highwater-H); %amount that one column can be eroded        <------%%%%% Changed from avgRdepth to avgbaredepth - IR 26-May-17
%         targete = targetDepth - (highwater-H);
        
        while targete > 0
            if tempgrid(ii,n,4) == 1
                tempevol = 0;
            end
            if tempevol > (fillmarsh+fillmud)*celldim(3,j)*celldim(1,j) %if there is enough erosion potential, empty the cell -- this does not include sand in erosion potential
                fillsand = fillsand + tempgrid(ii,n,1);
                tempgrid(ii,n,1:3) = 0; %empties cell by setting equal to zero
                fillkeep = fillkeep + (fillmud + (fillmarsh/2))*celldim(3,j)*celldim(1,j);
                tempevol = tempevol - (fillmud+fillmarsh)*celldim(3,j)*celldim(1,j);
                n = n + 1; %proceed to cell below
                fillmud = tempgrid(ii,n,3);
                fillmarsh = tempgrid(ii,n,2);
                H = (zcentroids(n) + celldim(3,j)./2); %update height of sed surface
                
%                 targete = lbaydepth - (highwater-H);
                targete = avgbaredepth - (highwater - H); %update amount left to erodemarsh               
%                 targete = targetDepth - (highwater - H);
                
            else
                %subtract marsh first
                %then subtract bay
                %then deposit sand - right now this includes sand from this cell, make sure to account for that
                % if not enough erosion potential to erode whole cell, erode as much as you can
                if tempevol > fillmarsh*celldim(3,j)*celldim(1,j)
                    tempgrid(ii,n,2) = 0;
                    tempevol = tempevol - fillmarsh*celldim(3,j)*celldim(1,j);
                    fillkeep = fillkeep + (fillmarsh/2)*celldim(3,j)*celldim(1,j); % Divide by 2 --> 50% of marsh sed (organic fraction) lost from system
                    fillmarsh = 0;
                    
                else
                    tempgrid(ii,n,2) = tempgrid(ii,n,2) - (tempevol/(celldim(3,j)*celldim(1,j)));
                    fillkeep = fillkeep + (tempevol/2);
                    tempevol = 0;
                end
                if tempevol > fillmud*celldim(3,j)*celldim(1,j)
                    tempgrid(ii,n,3) = 0;
                    fillkeep = fillkeep + fillmud*celldim(3,j)*celldim(1,j);
                    tempevol = tempevol - fillmud*celldim(3,j)*celldim(1,j);
                    fillmud = 0;
                else
                    tempgrid(ii,n,3) = tempgrid(ii,n,3) - (tempevol/(celldim(3,j)*celldim(1,j)));
                    fillkeep = fillkeep + tempevol;
                    tempevol = 0;
                    
                end
                
                fillsand = fillsand + tempgrid(ii,n,1);
                tempgrid(ii,n,1) = 0;
                break
                
            end
        end
        
        cellfillnew = sum(tempgrid(ii,n,:),3);
        while fillsand > 0
            if fillsand > 1 - cellfillnew
                tempgrid(ii,n,1) = 1 - cellfillnew;
                fillsand = fillsand - (1 - cellfillnew);
                n = n - 1;
                cellfillnew = 0;
            else
                tempgrid(ii,n,1) = fillsand;
                fillsand = 0;
            end
        end
        
        if ii < L
            ii = ii + 1; %continue to next column on left
        else
            break
        end
        
    end

    
else % If in first time step (t=1)
    Rerodevol = 0; % No marsh to erode if in first time step
    Lerodevol = 0;
    avgbaredepth = 0;
end


%%% Calculate amount of sed to use to grow marsh

if Rerodevol > 0 | Lerodevol > 0
	redepvol = (fillkeep/2); % Divided by 2 to distribute evenly between the 2 marshes
else
    redepvol = 0; 
end

ovol = ovol/2; % Half of marsh is organic


end


