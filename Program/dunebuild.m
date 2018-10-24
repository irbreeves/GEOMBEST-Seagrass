function [dunevol,tempgrid] = dunebuild (tempgrid,icrest,t,j,shorewidth)

% Dunebuild -- Infills the backbarrier via dunebuilding
% processes, updating tempgrid accordingly 

% Dr David Stolper dstolper@usgs.gov

% Version of 02-Jan-2003 10:47
% Updated    08-Apr-2003 4:47
% DW - Updated 22-Jun-2012

global celldim;
global N;
global equil;
global zcentroids;
global dunelimit;

[bbwidth] = getbbwidth(t,j);
remainingwidth = bbwidth; % the unfilled proportion of the bacbarrier width
dunevol = 0; % initialize volume of sand added to dune behind the crest
% endmarinecellwidth = 0; % width of backbarrier deposits in the most landwards marine cell   

%%%%%%%%%%%%%%% Update the icrest cell %%%%%%%%%%%%%%%

% find the cell housing the equilibrium horizon    
for k = 1:N
    if (zcentroids(k) - celldim(3,j) ./ 2) < equil(icrest)  
        newsurfcell = k;
        break
    end
end 
           
% update the cells below the equilibrium cell and dunevol    

for k = N:-1:newsurfcell + 1   
    cellstrat = squeeze(tempgrid(icrest,k,:));
    realratio = sum(cellstrat);
    if realratio ~= 1
        tempgrid(icrest,k,1) = tempgrid(icrest,k,1) + (1 - realratio);
        dunevol = dunevol + (1 - realratio) .* celldim(1,j) .* celldim(2,j) .* celldim(3,j); 
    end
end
    
% update the equilibrium cell   
    
targetratio = (equil(icrest) - (zcentroids(newsurfcell) - celldim(3,j) ./2)) ./ celldim(3,j);
    
% calculate how full the equilibrium cell is    
cellstrat = squeeze(tempgrid(icrest,newsurfcell,:));
realratio = sum(cellstrat);
    
% update the equilibrium cell and dunevol
tempgrid(icrest,newsurfcell,1) = tempgrid(icrest,newsurfcell,1) + (targetratio - realratio); % updates the holocene stratigraphic constituent
dunevol = dunevol + (targetratio - realratio) .* celldim(1,j) .* celldim(2,j) .* celldim(3,j);

remainingwidth = remainingwidth - (celldim(1,j) - shorewidth);


%%%%%%%%%%%%%%% Update remaining i cells %%%%%%%%%%%%%%% 

cellproportion = 1;
i = icrest + 1;

while remainingwidth > 0 
    
    % find the cell housing the equilibrium horizon    
    for k = 1:N
        if (zcentroids(k) - celldim(3,j) ./ 2) < equil(i)  
            newsurfcell = k;
            break
        end
    end    

    if remainingwidth < celldim(1,j)
        cellproportion = remainingwidth ./ celldim(1,j);
    end
    
    % update the cells below the equilibrium cell and dunevol    
    for k = N:-1:newsurfcell + 1   
        cellstrat = squeeze(tempgrid(i,k,:));
        realratio = sum(cellstrat);
        if realratio < cellproportion
            tempgrid(i,k,1) = tempgrid(i,k,1) + (cellproportion - realratio);
            dunevol = dunevol + (cellproportion - realratio) .* celldim(1,j) .* celldim(2,j) .* celldim(3,j); 
        end        
    end
    
    % update the equilibrium cell   
    
    targetratio = (equil(i) - (zcentroids(newsurfcell) - celldim(3,j) ./2)) ./ celldim(3,j) .* cellproportion;
    
    % calculate how full the equilibrium cell is    
    cellstrat = squeeze(tempgrid(i,newsurfcell,:));
    realratio = sum(cellstrat);
    
    % update the equilibrium cell and dunevol
    
    if realratio < targetratio
        tempgrid(i,newsurfcell,1) = tempgrid(i,newsurfcell,1) + (targetratio - realratio); % updates the holocene stratigraphic constituent
        dunevol = dunevol + (targetratio - realratio) .* celldim(1,j) .* celldim(2,j) .* celldim(3,j);
    end
        
    remainingwidth = remainingwidth - celldim(1,j);     
    
    i = i + 1;    
end
dunelimit = i;
%     for ii = icrest:L;
%         if equil(ii) > SL(t,j) + 0.5
%         dunelimit = ii + 1;
%         end
%     end