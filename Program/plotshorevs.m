function plotshorevs(filethread1,filethread2,step,b,e,axislabel)

%Function to compare shoreline migration rates from multiple runs

for filethread = filethread1:filethread2 

    %cross platform file loading of shorelines.mat file
    filename = ['../Output' num2str(filethread) '/shorelines.mat']; 

    load(filename)

    x = shorelines(:,1)./1000; %load shorelines data file and put in km
    x(1,:)=[];

    %step through shorelines and create new vector of corresponding time steps

    last_time_step=((length(x))*step);% figure out the last time step value

    t= [step:step:last_time_step]';%create a vector with time steps from 1 to last time step

    temp=polyfit(t,x,1);
    slope =temp(1);
    slopemeters = slope*1000; %put migration rate into meters
    intercept=temp(2);
    n = OW - OW1 + 1;
    y(n) = slopemeters;
end
x = (b:e)*2;
fh = figure;
plot(x,y,'-o');

xlabel((axislabel),'FontSize',15);
ylabel('Shoreline migration rate (m/yr)','FontSize',15);    
% title(['Shoreline migration vs ' (axislabel)], 'fontsize', 18) ;

saveas(fh, ['../Walters/2Modern runs/OW_' num2str(OW) '/RI_' num2str(RI) '/Output' num2str(filethread) '/pshorevs' (axislabel) '.fig'])

outputfilename = ['../Walters/2Modern runs/OW_' num2str(OW) '/RI_' num2str(RI) '/Output' num2str(filethread) '/pshorevs' (axislabel)];

%print('-dill',outputfilename)
print('-dpdf',outputfilename)
print('-djpeg',outputfilename)
print('-dpng',outputfilename)