function [actualerosion,tempgrid] = erosion(actualerosion,tempgrid,t,ii,j,k0,dheight,temperosion);

global celldim;
global SL;
global xcentroids;
global zcentroids;
global L;
global S;



k = k0;
realratio = sum(tempgrid(ii,k,:),3) - tempgrid(ii,k,1); % realratio of sediment in cell, except for sand


    % Potential erosion
while temperosion > 0

    if temperosion > realratio*celldim(3,j)
        temperosion = temperosion - realratio*celldim(3,j);

        estratio = tempgrid(ii,k,3);
        actualerosion = actualerosion + estratio*celldim(3,j)* celldim(1,j);
    else 
        cellheight = celldim(3,j);
        cell = tempgrid(ii,k,3);
%             keyboard
        estratio = cell * (temperosion / (cellheight * realratio)); % Why divide by realratio?                    
        temperosion = 0;
        actualerosion = actualerosion + estratio*celldim(3,j)* celldim(1,j);
    end

    k = k + 1;
    realratio = sum(tempgrid(ii,k,:),3);

end

    
    % Actual erosion
    
k = k0;
realratio = sum(tempgrid(ii,k,:),3) - tempgrid(ii,k,1); % realratio of sediment in cell, except for sand
dherosion = -dheight;

while dherosion > 0

    if dherosion > realratio*celldim(3,j)
        tempgrid(ii,k,:) = 0;
        dherosion = dherosion - realratio*celldim(3,j);            
    else

        for s = 1 : S
            tempgrid(ii,k,s) = tempgrid(ii,k,s) * (1 - (dherosion / celldim(3,j)) / realratio);
        end

        dherosion = 0;
    end

    k = k + 1;
    realratio = sum(tempgrid(ii,k,:),3);

end 
    
end