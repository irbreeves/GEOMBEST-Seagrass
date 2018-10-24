function [tempgrid,ztally] = accrete(tempgrid,disequilibrium,t,i,j)

% accrete -- accretes a single cell(x) within tempgrid. 

% Dr David Stolper dstolper@usgs.gov

% Version of 20-Jun-2003 15:00
% Updated    20-Mar-2003 15:00

global celldim;
global N;
global TP;
global zresponseaccretion;

ztally = 0; % volume of sand required for accretion (expressed as -ve value) 
timeremaining = TP(t); % The time availible to accrete successive cells 

% Find newsurfcell

disequilibrium(i) = disequilibrium(i) .* -1; % makes disequilibrium a positive value 

newsurfcell = N; % new addition 

for k = 1:N
    cellfill = sum(tempgrid(i,k,:));
    if cellfill ~= 0
        newsurfcell = k;
        break
    end
end
    
for k = newsurfcell:-1:1    
        
    cellaccomm = (1 - sum(tempgrid(i,k,:))) .* celldim(3,j); % height of the accomodation space in the cell
    if cellaccomm > disequilibrium(i)
        cellaccomm = disequilibrium(i); % limits height of the accomodation space to the disequilibrium height
    end       
    
    if disequilibrium(i) > 0 % the surface is out of equilibrium
        if timeremaining > 0 % there is availible time to accrete the substrate
            if zresponseaccretion(k) .* timeremaining >= cellaccomm % accretion is not limited by the response rate 
                disequilibrium(i) = disequilibrium(i) - cellaccomm;
                timeremaining = timeremaining - (cellaccomm ./ zresponseaccretion(k));
                %tempgrid(i,k,1) = tempgrid(i,k,1) + cellaccomm; % old line
                tempgrid(i,k,1) = tempgrid(i,k,1) + cellaccomm ./ celldim(3,j); % new line
                ztally = ztally + cellaccomm .* celldim(1,j) .* celldim(2,j) .* -1;
            else % accretion is limited by the response rate
                disequilibrium(i) = disequilibrium(i) - zresponseaccretion(k) .* timeremaining;
                timeremaining = 0;
                tempgrid(i,k,1) = tempgrid(i,k,1) + zresponseaccretion(k) .* timeremaining;
                ztally = ztally + zresponseaccretion(k) .* timeremaining .* celldim(1,j) .* celldim(2,j) .* -1;
            end
        else
            break
        end
    else
        break        
    end    
    
end