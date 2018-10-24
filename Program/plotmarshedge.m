function slopemeters = plotmarshedge(filethread,step,modelrun) %(OW,RI,filethread,step,modelrun)

%Function to create, plot and output an array of time step and marsh edge
%position, for the back-barrier marsh.
%Filethread specifies the output file folder in which the marshboundary.mat
%file is located, e.g., Output1, Output2, etc. 

% if(ispc)
% %    filename = ['../Walters/1Modern runs/OW_' num2str(OW) '/RI_' num2str(RI) '/Output' num2str(filethread) '/marshboundary.mat']; 
   filename = ['C:/GEOMBEST+/Output' num2str(filethread) '/marshboundary.mat']; 
% elseif(isunix)
%    filename = ['../Walters/1Modern runs/OW_' num2str(OW) '/RI_' num2str(RI) '/Output' num2str(filethread) '/marshboundary.mat']; 
%    %    filename = ['../Output' num2str(filethread) '/marshboundary.mat']; 
% else
%     error('Not Unix, Not PC!')
% end

load(filename)

x = marshboundary %./1000; %load marshboundary data file and put in km
n = numel(marshboundary);
y = [1:n]*step;

temp=polyfit(y(11:end),x(11:end),1);
slope =temp(1);
slopemeters = slope*1000; %put migration rate into meters
intercept=temp(2);


% %%%%%% Find migration rate of 2 different time periods in same run
% temp=polyfit(y(11:60),x(11:60),1);
% slope =temp(1);
% slopemeters = slope*1000
% intercept=temp(2);
% 
% temp2=polyfit(y(61:110),x(61:110),1);
% slope2 =temp2(1);
% slopemeters2 = slope2*1000
% intercept2 = temp2(2);
% %%%%%%

fh = figure;
plot(y(11:end),x(11:end));

% yt = marshboundary(4*n/5)./1000;
% xt = (n/5)*step;


%%%%%%
%text(30,.32,['Progradation Rate = ' num2str(slopemeters, 2) ' m/yr'],'fontsize',15)
%%%%%%


xlabel('Time (years)','FontSize',15);
ylabel('Marsh edge position (km)','FontSize',15);

% % saveas(fh, ['../Walters/1Modern runs/OW_' num2str(OW) '/RI_' num2str(RI) '/Output' num2str(filethread) '/pmarsh' num2str(modelrun) '.fig'])
% saveas(fh,['C:/GEOMBEST+/Output' num2str(filethread) '/pmarsh' num2str(modelrun) '.fig']); 
% 
% 
% % outputfilename = ['../Walters/1Modern runs/OW_' num2str(OW) '/RI_' num2str(RI) '/Output' num2str(filethread) '/pmarsh' num2str(modelrun)];
% outputfilename = ['C:/GEOMBEST+/Output' num2str(filethread) '/pmarsh num2str(modelrun)']; 
% 
% 
% %print('-dill',outputfilename)
% %print('-dpdf',outputfilename)
% %print('-djpeg',outputfilename)
% print('-dpng',outputfilename)

end

