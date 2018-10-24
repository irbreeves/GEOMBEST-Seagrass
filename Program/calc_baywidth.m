function calc_baywidth(a,b)

results = zeros(1000,3);
ii = 1;

for U = a:b
filethread = U;
filename = ['C:/GEOMBEST+/Output' num2str(filethread) '/surface.mat'];
load(filename)

filename2 = ['C:/GEOMBEST+/Output' num2str(filethread) '/xcentroids.mat'];
load(filename2)

filename3 = ['C:/GEOMBEST+/Output' num2str(filethread) '/SL.mat'];
load(filename3)

x = xcentroids(1,:); % x location of each cell
y_final = surface(end,:); %elevation of surface at final timestep
numcell = numel(y_final); %number of surface cells

for n = 1:numcell
    if y_final(n) >= SL(end)
        x_island = n; %first cell above sea level is island edge
        break
    else
        n = n + 1;
    end
end

x_rbay = numel(x);

for n = x_island:numcell
    if y_final(n) < SL(end)
        x_rbay = n; %x location of first estuarine cell (below SL)
        break
    else
        n = n + 1;
    end
end

%residualr = ((y_final(x_rbay) - (SL(end) - 0.4))/0.9)*50

x_lbay = numel(x);

for n = x_rbay:numcell
    if y_final(n) >= SL(end) %other edge of bay
        x_lbay = n - 1;
        break
    else
        n = n + 1;
    end
end
        
%residual? account for not full cells?

if x_rbay == numel(x)
    bay_width = 0; % no cells below sea level
else
    bay_width = x(x_lbay) - x(x_rbay);
end


%%average bay depth

avg_bay_depth = sum(surface(x_rbay:x_lbay))/bay_width;



%save the results
results(ii,:) = [U bay_width avg_bay_depth];

ii = ii + 1;

end

%write results to spreadsheet
xlswrite('C:/GEOMBEST+/Bay widths.xls', results, 'Sheet1','A2')
    
    
end