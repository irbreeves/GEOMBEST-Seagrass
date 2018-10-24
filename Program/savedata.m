function savedata(filethread)

% savedata -- saves shorelines and the global variables required for
% printing   

% Dr David Stolper dstolper@usgs.gov

% Version of 15-Apr-2003 10:49
% Updated    15-Apr-2003 10:49


global marshboundary;
global lmarshboundary;
global shorelines;
global surface;
global strat;
global xcentroids;
global zcentroids;
global celldim;
global SL;
global Seagrass;
global meadowvolume;
global erosionvolume;
global erosiondistance;
global organicvolume;
global bayerosionvolume;
global progradedistance;
global baredepth;
global progradevolume;

marshboundary = marshboundary - marshboundary(1); %normalize marsh progradation to initial position of marsh
lmarshboundary = lmarshboundary - lmarshboundary(1);
save (['../Output' num2str(filethread) '/marshboundary.mat'], 'marshboundary') 
save (['../Output' num2str(filethread) '/lmarshboundary.mat'], 'lmarshboundary') 
save (['../Output' num2str(filethread) '/shorelines.mat'], 'shorelines') 
save (['../Output' num2str(filethread) '/surface.mat'], 'surface')
save (['../Output' num2str(filethread) '/strat.mat'], 'strat')
save (['../Output' num2str(filethread) '/xcentroids.mat'], 'xcentroids')
save (['../Output' num2str(filethread) '/zcentroids.mat'], 'zcentroids')
save (['../Output' num2str(filethread) '/celldim.mat'], 'celldim')
save (['../Output' num2str(filethread) '/SL.mat'], 'SL')
save (['../Output' num2str(filethread) '/meadowvolume.mat'], 'meadowvolume')
save (['../Output' num2str(filethread) '/erosionvolume.mat'], 'erosionvolume')
save (['../Output' num2str(filethread) '/erosiondistance.mat'], 'erosiondistance')
save (['../Output' num2str(filethread) '/organicvolume.mat'], 'organicvolume')
save (['../Output' num2str(filethread) '/bayerosionvolume.mat'], 'bayerosionvolume')
save (['../Output' num2str(filethread) '/progradedistance.mat'], 'progradedistance')
save (['../Output' num2str(filethread) '/baredepth.mat'], 'baredepth')
save (['../Output' num2str(filethread) '/progradevolume.mat'], 'progradevolume')

end

