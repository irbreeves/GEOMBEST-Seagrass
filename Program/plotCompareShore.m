function [x1, x2] = plotCompareShore(filethread1,filethread2,step)

% Function to compare shoreline position over time from 2 runs

% IR 12-Jan-18

%%% Filethread1
%cross platform file loading of shorelines.mat file
filename1 = ['../Output' num2str(filethread1) '/shorelines.mat']; 

load(filename1)

x1 = shorelines(:,1)./1000; %load shorelines data file and put in km
A = [0];
t = [A,[1:1:step-10]]*10;

fh = figure;
hold off;

plot(t,x1(11:end),'g');
% set (gca, 'XLim', [0 200], 'YLim', [39.8 41.2])
set (gca,  'yminortick','on',...
    'xminortick','on',...
    'TickDir','out')
xlabel('Time (years)','FontSize',15);
ylabel('Shoreline Position (km)','FontSize',15);    


%%% Filethread2

%cross platform file loading of shorelines.mat file
filename2 = ['../Output' num2str(filethread2) '/shorelines.mat']; 

load(filename2)

x2 = shorelines(:,1)./1000; %load shorelines data file and put in km

hold on
plot(t,x2(11:end));
legend('Seagrass', 'No Seagrass');

end