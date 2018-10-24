function [tempgrid] = deposition(tempgrid,t,i,j,estrate)
% Deposit sediment with a height = estrate onto the bay surface


global celldim;
global SL;
global zcentroids;
global N;

    % update surface  
        for k = 1:N
            celltotal = sum(tempgrid(i,k,:));
            if celltotal ~= 0
                tempsurface = zcentroids(k) - (celldim(3,j) ./ 2) + (celltotal .* celldim(3,j));            
                break
            end
        end       
    
% Accrete using bay sediment
s = 3;

    % find the elevation for bay surface 
    newsurfval = tempsurface + estrate;
    
    if newsurfval > SL(t)
        newsurfval = SL(t);
    end
    

    if newsurfval > tempsurface;     
        % find the cell housing the elevation of the top bay horizon        
        for k = 1:N
            if newsurfval > zcentroids(k) - celldim(3,j) ./ 2
                newsurfcell = k;
                break
            end
        end        
        
        % calculate how full the top cell should be
        targetratio = (newsurfval - (zcentroids(newsurfcell) - celldim(3,j) ./ 2)) ./ celldim(3,j);

        %calculate how full the top cell is
        cellstrat = squeeze(tempgrid(i,newsurfcell,:));
        realratio = sum(cellstrat); 
          
        % update the cell housing the top elevation        
        tempgrid(i,k,s) = tempgrid(i,newsurfcell,s) + (targetratio - realratio); % updates the holocene stratigraphic constituent
        
        % update the cells below the top elevation        
        for k = newsurfcell + 1:N
            cellstrat = squeeze(tempgrid(i,k,:));
            realratio = sum(cellstrat);
            if realratio ~= 1
                tempgrid(i,k,s) = tempgrid(i,k,s) + (1 - realratio);
            else
                break
            end
        end
    end

