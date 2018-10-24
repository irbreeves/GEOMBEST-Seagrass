function plotmarshvs(step,b,e,axislabel)

%Function to compare marsh progradation rates rates from multiple runs

for filethread = 1:3 

    %cross platform file loading of shorelines.mat file
    if(ispc)
       filename = ['../Output' num2str(filethread) '/marshboundary.mat']; 
    elseif(isunix)
       filename = ['../Output' num2str(filethread) '/marshboundary.mat']; 
    else
        error('Not Unix, Not PC!')
    end

    load(filename)

    mx = marshboundary(10:20) ./1000; %load shorelines data file and put in km
    num = numel(marshboundary(10:20));
    t = [1:num]*step;
    
    temp=polyfit(t,mx,1);
    slope =temp(1);
    slopemeters = slope*1000; %put migration rate into meters
    intercept=temp(2);
    
    n = filethread - 1 + 1;
    y(n) = slopemeters;
end
x = [2 4 6];
fh = figure(1);
plot(x,y,'-or');
hold on

xlabel((axislabel),'FontSize',15);
ylabel('Marsh progradation rate (m/yr)','FontSize',15);    


for filethread = 4:6 

    %cross platform file loading of shorelines.mat file
    if(ispc)
       filename = ['../Output' num2str(filethread) '/marshboundary.mat']; 
    elseif(isunix)
       filename = ['../Output' num2str(filethread) '/marshboundary.mat']; 
    else
        error('Not Unix, Not PC!')
    end

    load(filename)

    mx = marshboundary(10:20) ./1000; %load shorelines data file and put in km
    num = numel(marshboundary(10:20));
    t = [1:num]*step;
    
    temp=polyfit(t,mx,1);
    slope =temp(1);
    slopemeters = slope*1000; %put migration rate into meters
    intercept=temp(2);
    
    n = filethread - 4 + 1;
    y(n) = slopemeters;
end
x = [2 4 6];
plot(x,y,'--ob');


for filethread = 7:9 

    %cross platform file loading of shorelines.mat file
    if(ispc)
       filename = ['../Output' num2str(filethread) '/marshboundary.mat']; 
    elseif(isunix)
       filename = ['../Output' num2str(filethread) '/marshboundary.mat']; 
    else
        error('Not Unix, Not PC!')
    end

    load(filename)

    mx = marshboundary(10:20) ./1000; %load shorelines data file and put in km
    num = numel(marshboundary(10:20));
    t = [1:num]*step;
    
    temp=polyfit(t,mx,1);
    slope =temp(1);
    slopemeters = slope*1000; %put migration rate into meters
    intercept=temp(2);
    
    n = filethread - 7 + 1;
    y(n) = slopemeters;
end
x = [2 4 6];
plot(x,y,'-ob');


for filethread = 10:12 

    %cross platform file loading of shorelines.mat file
    if(ispc)
       filename = ['../Output' num2str(filethread) '/marshboundary.mat']; 
    elseif(isunix)
       filename = ['../Output' num2str(filethread) '/marshboundary.mat']; 
    else
        error('Not Unix, Not PC!')
    end

    load(filename)

    mx = marshboundary(10:20) ./1000; %load shorelines data file and put in km
    num = numel(marshboundary(10:20));
    t = [1:num]*step;
    
    temp=polyfit(t,mx,1);
    slope =temp(1);
    slopemeters = slope*1000; %put migration rate into meters
    intercept=temp(2);
    
    n = filethread - 10 + 1;
    y(n) = slopemeters;
end
x = [2 4 6];
plot(x,y,'--or');

% title((modelrun), 'fontsize', 18) ;
% 
% saveas(fh, ['../Output' num2str(filethread1) '/pmarshvs' (axislabel) '.fig'])
% 
% outputfilename = ['../Output' num2str(filethread1) '/pmarshvs' (axislabel)];
% 
% %print('-dill',outputfilename)
% print('-dpdf',outputfilename)
% print('-djpeg',outputfilename)
% print('-dpng',outputfilename)

