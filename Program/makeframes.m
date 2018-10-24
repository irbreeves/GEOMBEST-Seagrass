function makeframes(filethread,tractnumber,first,last,increment)

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

plottractcolour (filethread,1,tractnumber,1,1)

set(gca,'PlotBoxAspectRatio',[2.5 1 1])

% save the figure as a .png file

print ('-dpng', '-f1', filename)

test = 1

% delete the figure 

% make the increments 

% make the last frame 

% rootname = ['c:\GEOMBEST+\input' num2str(filethread) '\run']; % directory containing runfiles
% flag = 1; % indicates the existence of a run# file 
% M = 0; % number of run# files (and therefore tracts) in the rootname directory
% cols = 6; % number of columns in the excel files
% 
% while flag == 1
%     filename = [rootname int2str(M + 1) '.xls']
%     
% global shorelines;
% global surface;
% global strat;
% global xcentroids;
% global zcentroids;
% global celldim;
% global SL;

