function slopemeters = plotcomparemarshedge(filethread,step,modelrun)

filename = ['C:/GEOMBEST+/Output' num2str(filethread) '/marshboundary.mat']; 
filename2 = ['C:/GEOMBEST+/Output' num2str(filethread+1) '/marshboundary.mat']; 


load(filename)

x = marshboundary ./1000; %load marshboundary data file and put in km
n = numel(marshboundary);
y = [1:n]*step;

load(filename2)

x2 = marshboundary ./1000; %load marshboundary data file and put in km
n2 = numel(marshboundary);
y2 = [1:n]*step;

% temp=polyfit(y(10:end),x(10:end),1);
% slope =temp(1);
% slopemeters = slope*1000; %put migration rate into meters
% intercept=temp(2);
% 
% temp=polyfit(y2(10:end),x2(10:end),1);
% slope =temp(1);
% slopemeters = slope*1000; %put migration rate into meters
% intercept=temp(2);


% %%%%%% Find migration rate of 2 different time periods in same run
% temp=polyfit(y(11:20),x(11:20),1);
% slope =temp(1);
% slopemeters = slope*1000
% intercept=temp(2);
% 
% temp2=polyfit(y(21:30),x(21:30),1);
% slope2 =temp2(1);
% slopemeters2 = slope2*1000
% intercept2 = temp2(2);
% %%%%%%


% p = polyfit(y(11:end),x(11:end),3);
% x1 = 110:1100;
% y1 = polyval(p,x1);
plot(y(11:end),x(11:end));
hold on;
% plot(x1,y1);
% 
% p2 = polyfit(y2(11:end),x2(11:end),3);
% x22 = 110:1100;
% y22 = polyval(p2,x22);
plot(y2(11:end),x2(11:end),'Color',[1,0,0]);
% plot(x22,y22,'Color',[1,0,0]);

% legend('Seagrass','Fit Seagrass','No Seagrass', 'Fit No Seagrass')
legend('Seagrass 1st half','Seagrass 2nd half')

%%%%%%
%text(30,.32,['Progradation Rate = ' num2str(slopemeters, 2) ' m/yr'],'fontsize',15)
%%%%%%


xlabel('Time (years)','FontSize',15);
ylabel('Marsh edge position (km)','FontSize',15);
title(modelrun);

end

