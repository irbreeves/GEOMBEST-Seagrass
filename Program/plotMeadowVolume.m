function plotMeadowVolume(filethread,step)
%plotMeadowVolume Plots the voume of the seagrass meadow over time

% Step = number of years in each time step

% Ian Reeves 9-April-2017

% Load seagrass
filename = ['C:\GEOMBEST+\Output' num2str(filethread) '\meadowvolume.mat'];
meadow = load(filename);

volume = [0 meadow.meadowvolume];
n = numel(volume);
t = [1:n]*step-100;

temp = polyfit(t(11:end),volume(11:end),1);
slope = temp(1);
intercept = temp(2);

% %%%%%
% temp = polyfit(t(11:20),volume(11:20),1);
% slope = temp(1)
% intercept = temp(2);
% 
% temp2 = polyfit(t(21:30),volume(21:30),1);
% slope2 = temp2(1)
% intercept2 = temp2(2);
% %%%%%%



plot(t(11:end),volume(11:end))
xlabel('Time (years)','FontSize',15);
ylabel('Seagrass meadow volume (m^3)','FontSize',15);


% text(20,400,['Meadow Volumetric Change Rate = ' num2str(slope, 2) ' m^3/yr'],'fontsize',10)

end

