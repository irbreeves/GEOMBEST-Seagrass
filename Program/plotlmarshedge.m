function plotlmarshedge(filethread,step,modelrun)

%Function to create, plot and output an array of time step and marsh edge
%position, for the back-barrier marsh.
%Filethread specifies the output file folder in which the marshboundary.mat
%file is located, e.g., output1, output2, etc. 

if(ispc)
   filename = ['C:/GEOMBEST+/Output' num2str(filethread) '/lmarshboundary.mat']; 
elseif(isunix)
   filename = ['C:/GEOMBEST+/Output' num2str(filethread) '/lmarshboundary.mat']; 
else
    error('Not Unix, Not PC!')
end

load(filename)

lmarshboundary = lmarshboundary * -1;
x = lmarshboundary ./1000; %load lmarshboundary data file and put in km
n = numel(lmarshboundary);
y = [1:n]*step;

temp=polyfit(y,x,1);
slope =temp(1);
slopemeters = slope*1000; %put migration rate into meters
intercept=temp(2);

fh = figure;
plot(y,x);

yt = lmarshboundary(4*n/5)./1000;
xt = (n/5)*step;
text(xt,yt,['Progradation Rate = ' num2str(slopemeters, 2) ' m/yr'],'fontsize',15)

xlabel('Time (years)','FontSize',15);
ylabel('Left Marsh edge position (km)','FontSize',15);

saveas(fh, ['C:/GEOMBEST+/Output' num2str(filethread) '/pmarsh' num2str(modelrun) '.fig'])

outputfilename = ['C:/GEOMBEST+/Output' num2str(filethread) '/pmarsh' num2str(modelrun)];

%print('-dill',outputfilename)
print('-dpdf',outputfilename)
print('-djpeg',outputfilename)
print('-dpng',outputfilename)