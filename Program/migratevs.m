function migratevs(filethread1,filethread2,step,b,e,axislabel)

% Plots migration rate for marsh and shoreline together for comparison

for filethread = filethread1:filethread2 

    %cross platform file loading of shorelines.mat file
    if(ispc)
       filename = ['../Output' num2str(filethread) '/marshboundary.mat']; 
    elseif(isunix)
       filename = ['../Output' num2str(filethread) '/marshboundary.mat']; 
    else
        error('Not Unix, Not PC!')
    end

    load(filename)

    mx = marshboundary ./1000; %load marshboundary positions and put in km
    num = numel(marshboundary);
    t = [1:num]*step;
    
    temp=polyfit(t,mx,1);
    slope =temp(1);
    slopemeters = slope*1000; %put migration rate into meters
    intercept=temp(2);
    
    n = filethread - filethread1 + 1;
    y(n) = slopemeters;
end
x = b:e;
fh = figure;
plot(x,y,'-ob');

hold on

for filethread = filethread1:filethread2 

    %cross platform file loading of shorelines.mat file
    if(ispc)
       filename = ['../Output' num2str(filethread) '/shorelines.mat']; 
    elseif(isunix)
       filename = ['../Output' num2str(filethread) '/shorelines.mat']; 
    else
        error('Not Unix, Not PC!')
    end

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
    n = filethread - filethread1 + 1;
    y(n) = slopemeters;
end
x = b:e;

plot(x,y,'-or');

xlabel((axislabel),'FontSize',15);
ylabel('Migration rate (m/yr)','FontSize',15);    

RSLR = xlsread(['../Input' num2str(filethread1) '/run1'],'Sheet1','B3');
RSLR = RSLR*100;

text(1,3.1,'Marsh Boundary','color','b','FontSize',15)
text(1,2.8,'Shoreline','color','r','FontSize',15)
text(1,2.5,['RSLR = ' num2str(RSLR) ' mm/yr'],'FontSize',15)

ylim([0 4.5])

saveas(fh, ['../Output' num2str(filethread1) '/migratevs' (axislabel) '.fig'])

outputfilename = ['../Output' num2str(filethread1) '/migratevs' (axislabel)];

%print('-dill',outputfilename)
print('-dpdf',outputfilename)
print('-djpeg',outputfilename)
print('-dpng',outputfilename)
