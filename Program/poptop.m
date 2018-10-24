function poptop(i,j,k,s,overallmaxz,horizon) 

% poptop -- populates cells within the grid which are intersected by the stratigraphic horizons 
% by updating the sediment ratios of the target cell. Removes the correct proportion of the 
% non-target stratigraphic units from the target cell if the ratio total exceeds 1

% Dr David Stolper dstolper@usgs.gov

% Version of 27-Dec-2002 09:28
% Updated    14-Jan-2003 15:22

global gridstrat;
global celldim;
global S;

if i == 151
    block = 9;
end


cellfill = sum(gridstrat(1,i,j,k,:)); % proportion of the targetted cell that is filled with sediment
bottomelev = overallmaxz - (k .* celldim(3,j));
gridstrat(1,i,j,k,s) = (horizon(i) - bottomelev) ./ celldim(3,j); % fill cell with proportion of targetted stratigraphic unit
totalfill = cellfill + gridstrat(1,i,j,k,s); % proportion of targetted cell that is filled with sediment after addition target unit sediment
overfill = totalfill - 1; % excess cell sediment volume

% Removes proportions of non-target stratigraphic units such that the ratios sum to 1
if totalfill > 1 & cellfill > 0
    for unit = 1:S
        if unit ~= s
            gridstrat(1,i,j,k,unit) = gridstrat(1,i,j,k,unit) - (overfill .* (gridstrat(1,i,j,k,unit) ./ cellfill)); 
        end
    end
end