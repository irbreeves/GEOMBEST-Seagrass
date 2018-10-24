function [tempgrid] = growmarsh (tempgrid,marshvol,t,j,tt,redepvol,maxDeq,icrest)


% Growmarsh -- fills the left and right-most shallow cells in the bay
% with marsh. Above MSL, organic growth helps the marsh reach its
% equilibirum elevation at mean high water.

% Ian Reeves 
%12/13/17

%%% %%% In this version, THERE IS NO AUGMENTATION FROM ORGANIC MATTER!

global marshboundary;
global lmarshboundary;
global marshedge;
global celldim;
global SL;
global zcentroids;
global xcentroids;
global dunelimit;
global L;
global limits;
global temprmarshedge;
global templmarshedge;
global RprogradeDist;
global bay;
global pvol; % Volume of sediment available to prograde marsh after erosion
global erodecell;
global eroderesid;

%Fill the right marsh

[highwater] = SL(t,j) + gethighwater(t,j);
mwl = SL(t,j); % Mean Water Level - the minimum depth at which the marsh will grow
potmarshht = gethighwater(t,j) + maxDeq; % The depth below which the estuary can no longer be eroded

k = 0;

ii = dunelimit;
limits(t,tt) = dunelimit;
dunelimit;
L;


tempvol = marshvol+redepvol; % the volume of fine grain sediments eroded from the bay available to grow the marsh (marshvol) and leftover from marsh edge erosion (redepvol)

pvol = tempvol;


% %%% Lose a percentage of sediment from system (i.e. out of inlet)
% if t > 10
%     tempvol = tempvol * 0.85; 
% end


while tempvol > 0
    realratio = sum(tempgrid(ii,:,:),3); % the fraction of sediment in each cell of the column at the limit of the dune
    topcell = find(realratio == 1); % find the first full cell
    topcell = topcell(1) - 1; % the boundary cell that is partially filled or empty

    k=topcell;
    cellfill = sum(tempgrid(ii,k,:),3); % fraction of sediment in the topcell
    H =((zcentroids(k) - celldim(3,j) ./ 2)) + cellfill*celldim(3,j); % height to the topcell
    
    targetf = highwater-H; % the height of empty cells that can be filled by marsh/bay
    
%     if t > 10 & ii > erodecell
%         pvol = [pvol tempvol];
%     end
    
    
    while targetf > 0

        subtarg1 = mwl - H; % the height of empty cells that can be filled with bay
        
        % First fill the lower part (part of column below MSL) with %100 fine grain sediments, no organic
        
        while subtarg1 > 0

            s = 3; % fill using bay sediment
            if tempvol > (1 - cellfill) * celldim(3,j) * celldim(1,j) % if there is enough available sediment, fill the topcell
                cellfill = sum(tempgrid(ii,k,:),3);
                tempgrid(ii,k,s) = tempgrid(ii,k,s) + (1 - cellfill);

                k = k - 1; % Proceed to the cell above
                H =((zcentroids(k) - celldim(3,j) ./ 2)); % Update the height of the sediment surface
                subtarg1 = mwl-H; % Update the subtarget
                targetf = highwater-H; % update the height left to fill with marsh

                tempvol = tempvol - (1 - cellfill) * celldim(3,j) * celldim(1,j); % subtract the volume added to the topcell from the available sediment

                cellfill = 0;
                
            else
               
                tempgrid(ii,k,s) = tempgrid(ii,k,s) + tempvol /(celldim(3,j) * celldim(1,j)); % if not enough sediment available, fill the topcell with as much as you have

                tempvol = 0; % there is no available sediment left
                break;
                
            end
        end        
        
        % Fill the marsh above Mean Sea Level using 50% organic and 50% fine grained sediments
                
         s = 2; % fill using marsh sediment
            if tempvol > (1 - cellfill) * celldim(3,j) * celldim(1,j) % if there is enough inorganic sediment, fill the topcell  % REMOVED AUGMENTATION 3/13/18     <-------------
                cellfill = sum(tempgrid(ii,k,:),3);
                tempgrid(ii,k,s) = tempgrid(ii,k,s) + (1 - cellfill);  

                k = k - 1;
                H =((zcentroids(k) - celldim(3,j) ./ 2)); 
                targetf = highwater-H; % Update the height of empty cells that can be filled with marsh
         
                tempvol = tempvol - (1 - cellfill) * celldim(3,j) * celldim(1,j); % Update the volume of available sediment     % REMOVED AUGMENTATION 12/12/17     <-------------

                cellfill = 0; % the first marsh cell is filled
                
            else
               
                tempgrid(ii,k,s) = tempgrid(ii,k,s) + 2 * tempvol /(celldim(3,j) * celldim(1,j)); % if there isn't enough available sediment, fill with as much as you have

                tempvol = 0;    % exit big loop
                break;          % exit column loop
                
            end
    end

    if ii < L
        ii = ii + 1; % Continue to the next column to the left
    else
       ii=ii;
        break
    end
    
end


if marshvol > 0
    temprmarshedge = ii;
else
    temprmarshedge = temprmarshedge;
end

% Save the position of the marsh boundary
if k > 0
    rightmarshedge = ii*celldim(1,j) + ((potmarshht - k*celldim(3,j))/potmarshht)*celldim(1,j);
else
    if t > 1
        rightmarshedge = marshboundary(t-1);
    else
        rightmarshedge = 0;
    end
end

% if t > 10
%     pvol = pvol(1);
% end

progradecell = ii;

realratio = sum(tempgrid(progradecell,:,:),3); % Amount of sed in each cell of column i
topcell = find(realratio == 1);
topcell = topcell(1) - 1; % Top cell with sediment
k = topcell;
realratio = sum(tempgrid(progradecell,k,:),3); % Amount of sediment in topcell
Hback = (zcentroids(k)-celldim(3,j)./2)+ realratio*celldim(3,j); % Height
residual = ((Hback - (SL(t) - 0.4)) / 0.9)*50;
residual = residual * (-1);



% RprogradeDist = (progradecell - erodecell)*celldim(1,j) + residual - eroderesid;
RprogradeDist = (progradecell - erodecell)*celldim(1,j);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% Fill the left marsh

ii = L;
limits(t,tt) = L;
tempvol = marshvol+redepvol; % the volume of fine grain sediments eroded from the bay are available to grow the marsh


while tempvol > 0

    realratio = sum(tempgrid(ii,:,:),3); % the fraction of sediment in each cell of the column at the limit of the dune
    topcell = find(realratio == 1); % find the first full cell
    topcell = topcell(1) - 1; % the boundary cell that is partially filled or empty

    k=topcell;
    cellfill = sum(tempgrid(ii,k,:),3); % fraction of sediment in the topcell
    H =((zcentroids(k) - celldim(3,j) ./ 2)) + cellfill*celldim(3,j);  % height to the topcell
    
    targetf = highwater-H; % the height of empty cells that can be filled by marsh/bay
    
    while targetf > 0

        subtarg1 = mwl - H; % the height of empty cells that can be filled with bay
        
        % First fill the lower part with %100 fine grain sediments
        
        while subtarg1 > 0

            s = 3; % fill using bay sediment
            if tempvol > (1 - cellfill) * celldim(3,j) * celldim(1,j) % if there is enough available sediment, fill the topcell
                
                tempgrid(ii,k,s) = tempgrid(ii,k,s) + (1 - cellfill); 

                k = k - 1;
                H =((zcentroids(k) - celldim(3,j) ./ 2));
                subtarg1 = mwl-H;
                targetf = highwater-H; % update the height left to fill with marsh

                tempvol = tempvol - (1 - cellfill) * celldim(3,j) * celldim(1,j); % subtract the volume added to the topcell from the available sediment

                cellfill = 0; % the topcell is filled to the top
                
            else
               
                tempgrid(ii,k,s) = tempgrid(ii,k,s) + tempvol /(celldim(3,j) * celldim(1,j)); % if not enough sediment available, fill the topcell with as much as you have

                tempvol = 0; % the topcell is filled to the top
                break;
                
            end
        end

        % Fill the marsh above Mean Sea Level using 50% organic and 50% fine grained sediments
                
         s = 2; % fill using marsh sediment
            %if tempvol > (1 - cellfill) * 0.5*(1 - cellfill) * celldim(3,j) * celldim(1,j)
            if tempvol > (1-cellfill)*celldim(3,j)*celldim(1,j)                                                                 % REMOVED AUGMENTATION 3/13/18     <-------------
                
                tempgrid(ii,k,s) = tempgrid(ii,k,s) + (1 - cellfill) ;              

                k = k - 1;
                H =((zcentroids(k) - celldim(3,j) ./ 2));
                targetf = highwater-H; % Update the height of empty cells that can be filled with marsh

                tempvol = tempvol - (1 - cellfill) * celldim(3,j) * celldim(1,j); % Update the volume of available sediment         % REMOVED AUGMENTATION 12/12/17     <-------------

                cellfill = 0;  % the first marsh cell is filled
                
            else
               
                tempgrid(ii,k,s) = tempgrid(ii,k,s) + 2 * tempvol /(celldim(3,j) * celldim(1,j));

                tempvol = 0;    % exit big loop
                break;          % exit column loop
                
            end

        
    end
    
    if ii > dunelimit

    ii = ii - 1; % Continue with the next column to the right
    
    else
        ii = ii;
        break
    end

end

if marshvol > 0
    templmarshedge = ii;
else
    templmarshedge = templmarshedge;
end

% Save the position of the marsh boundary
if k > 0
    leftmarshedge = ii*celldim(1,j) + ((potmarshht - k*celldim(3,j))/potmarshht)*celldim(1,j);
else
    if t > 1
        leftmarshedge = lmarshboundary(t-1);
    else
        leftmarshedge = 0;
    end
end
marshedge = [leftmarshedge rightmarshedge];



% %%% Find Marsh Width after growmarsh
% 
% if t > 1
%     
%     island_width = 400; % 400 for Hog, 150 for Metompkin - IR 17Jun17 changed Hog from 275 to 400
%     x = xcentroids(1,:);
%     rmarsh = bay(1)-1;
% 
%     % Get depths of shoreface
%     for i = 2:icrest % For each cell in the bay
%         realratio = sum(tempgrid(i,:,:),3); % Amount of sed in each cell of column i
%         topcell = find(realratio == 1);
%         topcell = topcell(1) - 1; % Top cell with sediment
%         k = topcell;
%         realratio = sum(tempgrid(i,k,:),3); % Amount of sediment in topcell
%         H = (zcentroids(k)-celldim(3,j)./2)+ realratio*celldim(3,j); % Height
%         if H >= SL(t-1)
%             x_islandfront = i; % The first cell above sea level gives the X location of the shoreline at the island front
%             break
%         end
%     end
% 
% 
%     % Find island back cell
%     for n = x_islandfront:L
%         realratio = sum(tempgrid(n,:,:),3); % Amount of sed in each cell of column i
%         topcell = find(realratio == 1);
%         topcell = topcell(1) - 1; % Top cell with sediment
%         k = topcell;
%         realratio = sum(tempgrid(n,k,:),3); % Amount of sediment in topcell
%         Hback = (zcentroids(k)-celldim(3,j)./2)+ realratio*celldim(3,j); % Height
% 
%         if Hback < SL(t-1) - 0.25
%             x_islandback = n - 1; % The first cell past the island front that is below sea level gives the X location of the first estuarine cell
%             break
%         else
%             n = n + 1;
%         end
%     end
% 
% 
%     residual = ((Hback - (SL(t-1) - 0.4)) / 0.9)*50; % -.5 ?? highwater??
% 
%     if exist('x_islandback') == 0
%         marsh_width = 6000; % If there are no cells below sea level behind the island, the total width is at its maximum, 12000/2 = 6000 for Hog
%     else
%         subaerial_width = x(x_islandback - 1) + residual - x(x_islandfront); % The total subaerial width is equal to the distance from the island front to the first estuarine cell 
% 
%         % Calculate marsh width
%         marsh_width = subaerial_width - island_width; % The marsh width is the total subaerial width minus the island width
% 
%         if marsh_width < 0
%             marsh_width = 0; % If the islandwidth has narrowed, marsh width is zero
%         end     
%     end       
% 
%     RprogradeDist = marsh_width;
% 
% else
%     
%     RprogradeDist = 0;
%     
% end



end