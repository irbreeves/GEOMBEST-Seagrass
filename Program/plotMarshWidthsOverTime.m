function [widths1, widths2, steps] = plotMarshWidthsOverTime(filethread1,filethread2,RSLR,TS) 
% Run number SG, Run number NSG, RSLR, Number of time steps

% Plots the marsh width over time for 2 diferent runs

% Ian Reeves 8-Jan-2018



steps = [1:TS];
widths1 = MarshWidthOverTime(filethread1,RSLR,TS);
widths2 = MarshWidthOverTime(filethread2,RSLR,TS);
time = (steps-10)*10;

% Plot
figure()
plot(time(11:end),widths1(11:end),'LineWidth',2,'Color',[0,1,0]);
xlabel('Time (years)','FontSize',15);
ylabel('Marsh width (m)','FontSize',15);
hold on
plot(time(11:end),widths2(11:end),'LineWidth',2,'Color',[0,0,1]);
legend('Seagrass','No Seagrass');

% figure()
% plot(time,widths1,'LineWidth',2,'Color',[0,1,0]);
% xlabel('Time (years)','FontSize',15);
% ylabel('Marsh width (m)','FontSize',15);
% hold on
% plot(time,widths2,'LineWidth',2,'Color',[0,0,1]);
% legend('Seagrass','No Seagrass');

end

