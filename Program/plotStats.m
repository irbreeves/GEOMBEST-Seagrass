function plotStats(filethread1,filethread2,SLR,TS)


%%%%% ORGANIC ERODED %%%%%

% Load organiclost SG
filename = ['C:\GEOMBEST+\Output' num2str(filethread1) '\organicvolume.mat'];
lost = load(filename);

% Load organiclost No SG
filename2 = ['C:\GEOMBEST+\Output' num2str(filethread2) '\organicvolume.mat'];
lost2 = load(filename2);

ovolSG = lost.organicvolume; 
ovolNSG = lost2.organicvolume; 
n = numel(ovolSG);
% t = [1:n]*10;
t = [1:TS-10]*10;
widthSG = MarshWidthOverTime(filethread1,SLR,TS);
widthNoSG = MarshWidthOverTime(filethread2,SLR,TS);

widthDiffSG = [0 diff(widthSG)];
widthDiffNoSG = [0 diff(widthNoSG)];

widthDiff = widthSG-widthNoSG;

% % Plot Organic lost and marsh width over time
% figure
% [hAx,hLine1,hLine2] = plotyy(t,organiclostSG(11:TS),t,widthSG(11:TS));
% legend('Organic Volume Lost','Marsh Width (m)');
% 
% xlabel('Time (yrs)');
% ylabel(hAx(2),'MarshWidth (m)');
% ylabel(hAx(1),'Organic Volume Lost (m^3)');

% % Plot organic lost - seagrass and no seagrass
% figure
% plot(t,ovolSG,'LineWidth',2,'Color',[0 1 0]);
% hold on
% plot(t,ovolNSG,'LineWidth',2,'Color',[0 0 1]);
% legend('Seagrass','No Seagrass');
% xlabel('Time (yrs)');
% ylabel('Organic Volume Eroded (m^3)');


%%%%% VOLUMES %%%%%


% Load total MARSH eroded SG
filename_evol = ['C:\GEOMBEST+\Output' num2str(filethread1) '\erosionvolume.mat'];
evol = load(filename_evol);

% Load total MARSH eroded No SG
filename_evol2 = ['C:\GEOMBEST+\Output' num2str(filethread2) '\erosionvolume.mat'];
evol2 = load(filename_evol2);

evolSG = [0 evol.erosionvolume]; 
evolNSG = [0 evol2.erosionvolume];


% Load total BAY eroded SG
filename_bvol = ['C:\GEOMBEST+\Output' num2str(filethread1) '\bayerosionvolume.mat'];
bvol = load(filename_bvol);

% Load total BAY eroded No SG
filename_bvol2 = ['C:\GEOMBEST+\Output' num2str(filethread2) '\bayerosionvolume.mat'];
bvol2 = load(filename_bvol2);

bvolSG = bvol.bayerosionvolume; 
bvolNSG = bvol2.bayerosionvolume;


totalerodeSG = evolSG + bvolSG/2;
totalerodeNSG = evolNSG + bvolNSG/2; % Half of bvol goes to each marsh


%%% PROGRADE VOLUME

% Load total MARSH prograde volume SG
filename_pvol = ['C:\GEOMBEST+\Output' num2str(filethread1) '\progradevolume.mat'];
pvol = load(filename_pvol);

% Load total MARSH prograde volume No SG
filename_pvol2 = ['C:\GEOMBEST+\Output' num2str(filethread2) '\progradevolume.mat'];
pvol2 = load(filename_pvol2);

pvolSG = [pvol.progradevolume]; 
pvolNSG = [pvol2.progradevolume];

%%% PLOT PROPORTION OF ERODED SED LEFTOVER FOR PROGRADATION PHASE

progpropSG = pvolSG(11:TS)./totalerodeSG(11:TS);
progpropNSG = pvolSG(11:TS)./totalerodeNSG(11:TS);

figure
plot(t,progpropSG,'LineWidth',2,'Color',[0 1 0]);
hold on
plot(t,progpropNSG,'LineWidth',2,'Color',[0 0 1]);



% Plot organic lost and erosion volume - seagrass and no seagrass
figure
plot(t,ovolSG(11:TS),'LineWidth',2,'Color',[0 1 0]);
hold on
plot(t,ovolNSG(11:TS),'LineWidth',2,'Color',[0 0 1]);
plot(t,evolSG(11:TS),':','LineWidth',2,'Color',[0 1 0]);
plot(t,evolNSG(11:TS),':','LineWidth',2,'Color',[0 0 1]);
legend('Organic Volume SG','Organic Volume No SG','Total Volume SG','Total Volume No SG');
xlabel('Time (yrs)');
ylabel('Marsh Volume Eroded (m^3)');


% Plot bay volume erosion - seagrass and no seagrass
figure
plot(t,bvolSG(11:TS),'LineWidth',2,'Color',[0 1 0]);
hold on
plot(t,bvolNSG(11:TS),'LineWidth',2,'Color',[0 0 1]);
legend('Seagrass','No Seagrass');
xlabel('Time (yrs)');
ylabel('Bay Volume Eroded (m^3)');




%%%%% MARSH WIDTH %%%%%

% Plot marsh width over time - seagrass vs no seagrass
figure
plot(t,widthSG(11:TS),'LineWidth',2,'Color',[0 1 0]);
hold on
plot(t,widthNoSG(11:TS),'LineWidth',2);
legend('Seagrass','No Seagrass');
xlabel('Time (yrs)');
ylabel('Marsh Width (m)');

t = [1:TS-10]*10;


%%%%% SEDIMENT LOST VS SEQUESTRATION %%%%%

%%% Calculate total difference in sediment loss/sequestration - seagrass vs no seagrass

filenameSG = ['C:\GEOMBEST+\Output' num2str(filethread1) '\meadowvolume.mat'];
meadow = load(filenameSG);
volume = [0 meadow.meadowvolume];

sequestered = [0 diff(volume)];

%%% Calculate total sediment loss

totallostSG = ovolSG/2 + sequestered;
sequestPercent = sequestered./totallostSG; % Percent of total sediment loss that was sequestered by SG meadow
totallostNoSG = ovolNSG/2;

totalLostDiff = totallostSG - totallostNoSG; 


%%%%% DEPTHS %%%%%

% Depths - seagrass
filename = ['C:/GEOMBEST+/Output' num2str(filethread1) '/surface.mat'];
load(filename)

filename2 = ['C:/GEOMBEST+/Output' num2str(filethread1) '/xcentroids.mat'];
load(filename2)

filename3 = ['C:/GEOMBEST+/Output' num2str(filethread1) '/SL.mat'];
load(filename3)

avg_bay_depth_SG = zeros(1,TS);
scarpheight = zeros(1,TS);

for t = [2:TS+1] 
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
    if depth > 0
        depth = 0;
    end
    depthsum = sum(depth);
    baywidth = numel(surf);
    quarterbay = round(baywidth/8);
    if baywidth < 2
        quarterbay = 1;
    end
    
    avg_bay_depth_SG(t-1) = depthsum/bay_width;
%     scarpheight(t-1) = depth(quarterbay)*(-1);
    
end
    
    

    
% Depths - no seagrass
filename = ['C:/GEOMBEST+/Output' num2str(filethread2) '/surface.mat'];
load(filename)

filename2 = ['C:/GEOMBEST+/Output' num2str(filethread2) '/xcentroids.mat'];
load(filename2)

filename3 = ['C:/GEOMBEST+/Output' num2str(filethread2) '/SL.mat'];
load(filename3)

avg_bay_depth_NoSG = zeros(1,TS);

for t = [2:TS+1] 
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
    avg_bay_depth_NoSG(t-1) = depthsum/bay_width;

end
    
avg_bay_depth_NoSG = avg_bay_depth_NoSG*(-1);
avg_bay_depth_SG = avg_bay_depth_SG*(-1);



n = numel(ovolSG);
t = [1:TS]*10;
% figure
% plot(t,scarpheight,'LineWidth',2,'Color',[0 1 0]);
% hold on
% plot(t,avg_bay_depth_NoSG,'LineWidth',2,'Color',[0 0 1]);
% legend('Seagrass','No Seagrass');
% xlabel('Time (yrs)');
% ylabel('Marsh scarp height (m)');


 
widthDifference = widthSG - widthNoSG;



WidthErosionDiff = widthDiffSG - widthDiffNoSG;

t = [1:TS-10]*10;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%% EROSION & PROGRADATION DISTANCE %%%%%
% 
% % Load erosion distance
% filename_eSG = ['C:\GEOMBEST+\Output' num2str(filethread1) '\erosiondistance.mat'];
% erosion_SG = load(filename_eSG);
% XerosionSG = [0 erosion_SG.erosiondistance];
% 
% filename_eNSG = ['C:\GEOMBEST+\Output' num2str(filethread2) '\erosiondistance.mat'];
% erosion_NSG = load(filename_eNSG);
% XerosionNSG = [0 erosion_NSG.erosiondistance];
% 
% filename_pSG = ['C:\GEOMBEST+\Output' num2str(filethread1) '\progradedistance.mat'];
% prograde_SG = load(filename_pSG);
% XprogradeSG = [0 prograde_SG.progradedistance];
% 
% filename_pNSG = ['C:\GEOMBEST+\Output' num2str(filethread2) '\progradedistance.mat'];
% prograde_NSG = load(filename_pNSG);
% XprogradeNSG = [0 prograde_NSG.progradedistance];
% 
% widthst1SG = widthSG(10:(end-1)); % Marsh widths at t-1      
% widthst1NSG = widthNoSG(10:(end-1)); % Marsh widths at t-1     
% 
% % Load bare depth
% filename_bDSG = ['C:\GEOMBEST+\Output' num2str(filethread1) '\baredepth.mat'];
% bdepthSG = load(filename_bDSG);
% baredepthSG = [0 bdepthSG.baredepth];
% 
% filename_bDNSG = ['C:\GEOMBEST+\Output' num2str(filethread2) '\baredepth.mat'];
% bdepthNSG = load(filename_bDNSG);
% baredepthNSG = [0 bdepthNSG.baredepth];
% 
% % erosiondistanceSG = widthst1SG-XerosionSG(11:TS);
% % erosiondistanceNSG = widthst1NSG-XerosionNSG(11:TS);
% % 
% % progradedistanceSG = widthSG(11:end)-XerosionSG(11:TS);
% % progradedistanceNSG = widthNoSG(11:end)-XerosionNSG(11:TS);
% 
% 
% 
% 
% erosiondistanceSG = XerosionSG(11:TS);
% erosiondistanceNSG = XerosionNSG(11:TS);
% 
% 
% 
% 
% progradedistanceSG = XprogradeSG(11:TS);
% progradedistanceNSG = XprogradeNSG(11:TS);
% 
% 
% 
% % Plot erosion & progradation distances - SG vs No SG
% figure
% plot(t,erosiondistanceSG,'Linewidth',2,'Color',[0 1 0]);
% hold on
% plot(t,erosiondistanceNSG,'Linewidth',2,'Color',[0 0 1]);
% plot(t,progradedistanceSG,':','Linewidth',2,'Color',[0 1 0]);
% plot(t,progradedistanceNSG,':','Linewidth',2,'Color',[0 0 1]);
% xlabel('Time (yrs)');
% ylabel('Distance');
% legend('Erosion - SG','Erosion - NSG','Progradation - SG','Progradation - NSG');
% 
% 
% % % Plot erosion distances - SG vs No SG
% % figure
% % plot(t,erosiondistanceSG,'Linewidth',2,'Color',[0 1 0]);
% % hold on
% % plot(t,erosiondistanceNSG,'Linewidth',2,'Color',[0 0 1]);
% % xlabel('Time (yrs)');
% % ylabel('Erosion Distance');
% % 
% % % Plot progradation distances - SG vs No SG
% % figure
% % plot(t,progradedistanceSG,'Linewidth',2,'Color',[0 1 0]);
% % hold on
% % plot(t,progradedistanceNSG,'Linewidth',2,'Color',[0 0 1]);
% % xlabel('Time (yrs)');
% % ylabel('Progradation Distance');
% 
% 
% % % Plot progradation widths (width of marsh after growmarsh - should be same as marsh width plot (or very close))
% % figure
% % plot(t,XprogradeSG(11:end),'Linewidth',2,'Color',[0 1 0]);
% % hold on
% % plot(t,XprogradeNSG(11:end),'Linewidth',2,'Color',[0 0 1]);
% % legend('Seagrass','No Seagrass');
% % % plot(t,widthNoSG(11:end),'Linewidth',2,'Color',[0 1 0]);
% % % legend('Prograde width','Final width');
% % ylabel('Progradation Width');
% 
% 
% 
% %%%%% PROGRADATION - EROSION 0VER TIME %%%%%
% 
% PEdiff_SG = progradedistanceSG - erosiondistanceSG;
% PEdiff_NSG = progradedistanceNSG - erosiondistanceNSG;
% 
% % Plot SG vs No SG, (-) = erosion, (+) = progradation
% figure
% plot(t,PEdiff_SG,'Linewidth',2,'Color',[0 1 0]);
% hold on
% plot(t,PEdiff_NSG,'Linewidth',2,'Color',[0 0 1]);
% xlabel('Time (yrs)');
% ylabel('Progradation-Erosion Distance (m)');
% 
% 
% PEdiff = PEdiff_SG - PEdiff_NSG; % (+) value = SG erodes less/progrades more, (-) value = SG erodes more/progrades less
%                                    
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end


