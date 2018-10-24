function slopemeters = plotshore(filethread,step,modelrun)

%Function to create, plot and output an array of time step and shoreline
%position.
%Filethread specifies the output file folder in which the shoreline.mat
%file is located, e.g., output1, output2, etc. 
%Created by L. Moore 2/11/06

%cross platform file loading of shorelines.mat file
filename = ['../Output' num2str(filethread) '/shorelines.mat']; 

load(filename)

x = shorelines(:,1)./1000; %load shorelines data file and put in km
% x(1,:)=[];

%step through shorelines and create new vector of corresponding time steps
last_time_step=((length(x))*step);% figure out the last time step value

t= [step:step:last_time_step]';%create a vector with time steps from 1 to last time step

temp=polyfit(t(10:end),x(10:end),1);
slope =temp(1);
slopemeters = slope*1000; %put migration rate into meters
intercept=temp(2);

fh = figure;
hold off;
plot(t(1:end-11),x(12:end));%plot all but first element
% set (gca, 'XLim', [0 200], 'YLim', [39.8 41.2])
set (gca,  'yminortick','on',...
    'xminortick','on',...
    'TickDir','out')
xlabel('Time (years)','FontSize',15);
ylabel('Shoreline Position (km)','FontSize',15);    
title((modelrun), 'fontsize', 18) 

hold on;

% text(30,40.4,['Migration Rate = ' num2str(slopemeters, 2) ' m/yr'],'fontsize',15)
% text(30,40.7,['Final Shore Position = ' num2str(x(end), 3) ' km'], 'fontsize', 15)
text(t(3),max(x)*1.2,['Migration Rate =' num2str(slopemeters, 2) ' m/yr'], 'fontsize', 15);
text(t(3),max(x)*1.1,['Final Shore Position =' num2str(x(end), 3) ' km'], 'fontsize', 15);

%create matrix A containing time steps and shoreline position for output
%later

A = [t,x];

% save x t
% 
% % saveas(fh, ['../Walters/1Modern runs/OW_' num2str(OW) '/RI_' num2str(RI) '/Output' num2str(filethread) '/pshore' num2str(modelrun) '.fig'])
% saveas(fh, ['../Output' num2str(filethread) '/pshore' num2str(modelrun) '.fig'])
% 
% % outputfilename = ['../Walters/1Modern runs/OW_' num2str(OW) '/RI_' num2str(RI) '/Output' num2str(filethread) '/pshore' num2str(modelrun)];
% outputfilename = ['../Output' num2str(filethread) '/pshore' num2str(modelrun)];
% 
% %print('-dill',outputfilename)
% %print('-dpdf',outputfilename)
% %print('-djpeg',outputfilename)
% print('-dpng',outputfilename)