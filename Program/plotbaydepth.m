function plotbaydepth(a,b,c) %(Run1, LastRun, #time steps)


% Modified by IR 8-May-2017


d = c + 2;
results = zeros(1000,d);
ii = 1;

time = [1:c]*10;

for U = a:b
    filethread = U;
    filename = ['C:/GEOMBEST+/Output' num2str(filethread) '/surface.mat'];
    load(filename)

    filename2 = ['C:/GEOMBEST+/Output' num2str(filethread) '/xcentroids.mat'];
    load(filename2)

    filename3 = ['C:/GEOMBEST+/Output' num2str(filethread) '/SL.mat'];
    load(filename3)

    avg_bay_depth = zeros(1,c);

    for t = [2:c+1] 
        x = xcentroids(1,:); % x location of each cell
        y = surface(t,:); %elevation of surface at timestep
        numcell = numel(y); %number of surface cells

        for n = 1:numcell
            if y(n) >= SL(t-1)
                x_island = n; %first cell above sea level is island edge
                break
            else
                n = n + 1;
            end
        end

        x_rbay = numel(x);

        for n = x_island:numcell
            if y(n) < SL(t-1)
                x_rbay = n; %x location of first estuarine cell (below SL)
                break
            else
                n = n + 1;
            end
        end

        x_lbay = numel(x);

        for n = x_rbay:numcell
            if y(n) >= SL(t-1) %other edge of bay
                x_lbay = n - 1;
                break
            else
                n = n + 1;
            end
        end

        if x_rbay == numel(x)
            bay_width = 0; % no cells below sea level
        else
            bay_width = (x_lbay) - (x_rbay) +1;
        end


        %%average bay depth

        surf = surface(t,x_rbay:x_lbay);
        depth = surf - SL(t-1);
        depthsum = sum(depth);
        avg_bay_depth(t-1) = depthsum/bay_width;


        %save the results
%         results(ii,:) = [U bay_width avg_bay_depth];

    end
  
%     fh=figure;
    plot(time(10:end),avg_bay_depth(10:end),'LineWidth',2)
    
    hold all
    
    % saveas(fh,['C:/GEOMBEST+/Output' num2str(filethread) '/plot bay depth' num2str(filethread) '.fig']); 
    % 
    % outputfilename = ['C:/GEOMBEST+/Output' num2str(filethread) '/plot bay depth num2str(filethread)']; 
    % print('-djpeg',outputfilename)

    ii = ii + 1;

end

set(gca,'fontsize',13);
xlabel('Time (years)','FontSize',14);
ylabel('Average elevation below MSL (m)','FontSize',14);
legend('Seagrass','No Seagrass');

% %write results to spreadsheet
% xlswrite('C:/GEOMBEST+/Bay widths.xls', results, 'Sheet1','A2')

    
end