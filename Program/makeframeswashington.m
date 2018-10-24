function makeframeswashington(filethread,tractnumber,first,last,increment)

% makeframes -- Creates matlab figures from GEOMBEST+ timesteps
% and then saves them as .png files in the "C:/GEOMBSET+/frames" file 
% first = the first step in the frame sequence 
% last = the final step in the frame sequence
% increment = the increment between the timesteps of the frame sequnce  

% Dr David Stolper dstolper@usgs.gov

% Version of 20-Feb-2004 10:30
% Updated    20-Feb-2004 10:30


filename = 'c:\GEOMBEST+\frames\step1';

% make the first frame 

plottractcolour (filethread,first,tractnumber,first,1)
set(gca,'PlotBoxAspectRatio',[2.5 1 1])
set(gca,'XTickLabel',[0 5 10 15 20 30 35 40 45 50])
xlabel('Distance (km)','FontSize',10);
ylabel('Elevation relative to initial sea level (m)','FontSize',10);
print ('-dpng', '-f1', filename);
close;

% make the incremental frames  

framenumber = 2;

for i = first + increment: increment: 99999999    
    
    if i >= last
        break    
    end 
    
    plottractcolour (filethread,i,tractnumber,first,increment);    
    set(gca,'PlotBoxAspectRatio',[2.5 1 1])
    set(gca,'XTickLabel',[0 5 10 15 20 30 35 40 45 50])
    xlabel('Distance (km)','FontSize',10);
    ylabel('Elevation relative to initial sea level (m)','FontSize',10);
    filename = ['c:\GEOMBEST+\frames\step' num2str(framenumber)];     
    print ('-dpng', '-f1', filename);   
    framenumber = framenumber + 1;
    close;
    
end

% make the last frame 

plottractcolour (filethread,last,tractnumber,first,increment);    
set(gca,'PlotBoxAspectRatio',[2.5 1 1])
set(gca,'XTickLabel',[0 5 10 15 20 30 35 40 45 50])
xlabel('Distance (km)','FontSize',10);
ylabel('Elevation relative to initial sea level (m)','FontSize',10);
filename = ['c:\GEOMBEST+\frames\step' num2str(framenumber)];     
print ('-dpng', '-f1', filename); 
close;