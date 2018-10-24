function [stable_range] = plot_marshwidthfreq(run,realistic)

close all

if realistic == 1
    perc = 0.425;
    file = 'Realistic marsh width';
else
    perc = 0.425;
    file = 'Marsh width';
end

% Read and plot marsh widths from modern experiments
no_marsh = xlsread(['../Walters/' num2str(run) 'Modern runs/' file],'A2:G1001');
narrow_marsh = xlsread(['../Walters/' num2str(run) 'Modern runs/' file],'I2:O1001');
wide_marsh = xlsread(['../Walters/' num2str(run) 'Modern runs/' file],'Q2:W1001');
all_widths = [no_marsh ; narrow_marsh ; wide_marsh];

init_widths = [10 400 1925];

%%%%%%%% First, plot the total frequency distribution %%%%%%%%%%
fh2 = figure;
hold on

 % Set x- and y-limits and label the axes on the plot
[nn,x] = hist(all_widths(:,5),100);
upper_y = max(nn) * 1.15;
set(gca,'XLim',[-50 2000])
set(gca,'YLim',[0 upper_y+1.18])
ylabel('Frequency','FontSize',25); 
xlabel('Backbarrier marsh width (m)','FontSize',25);

% Find the location of the peaks and the range of the stable states
pks = findpeaks2(nn,3,perc);

% Plot a grey box for the range of stable widths around each peak
stable_range = zeros(3,2);
for n = 1:3
    xx = [x(pks(n,2))-13 x(pks(n,2))-13 x(pks(n,3))+13 x(pks(n,3))+13];
    yy = [0 upper_y upper_y 0];
    h = fill(xx,yy,[.75 .75 .75]);
    set(h,'edgecolor',[.75 .75 .75])
    stable_range(n,:) = [xx(1) xx(4)];
end

hist(all_widths(:,5),100)

% Plot the location of the initial conditions
for n = 1:3
    plot([init_widths(n) init_widths(n)],[0 upper_y],'--k','LineWidth',1.5)
%     plot([x(pks(n,2)) x(pks(n,2))],[0 upper_y],'--k','LineWidth',1.5)
end

set(gca,'FontSize',16)
set(fh2,'units','normalized','position',[.1 .1 .8 .8], 'PaperPositionMode', 'auto');
box on

% Save the plots
saveas(fh2, ['../Walters/' num2str(run) 'Modern runs/' file ' frequency_all.fig']) 
outputfilename = ['../Walters/' num2str(run) 'Modern runs/' file ' frequency_all'];
print('-dpng',outputfilename)

%%%%%%%%%% Next, plot the freuqnecy distribution for each initial%%%%%%%%%%
%%%%%%%%%% condition, all in the same figure window %%%%%%%%%
fh = figure;
hold on

% Determine the uppermost limit of the three plots
nn = zeros(100,3);
[nn(:,1),x1] = hist(no_marsh(:,5),100);
[nn(:,2),x2] = hist(narrow_marsh(:,5),100);
[nn(:,3),x3] = hist(wide_marsh(:,5),100);

% Set the x- and y-limits and label the plots
titles = {'Initially no marsh' 'Initially narrow marsh' 'Initially wide marsh'};
for ni = 1:3
    upper_y = (max(nn(:,ni)))*1.15;
    subplot(3,1,ni)
    hold on
    text(600,upper_y*2/3,titles(ni),'FontSize',25)
    set(gca,'XLim',[-50 2000],'YLim',[0 upper_y*1.01],'FontSize',16)
    box on
    % Plot a grey box for the range of stable widths around each peak
    for n = 1:3
        xx = [x(pks(n,2))-13 x(pks(n,2))-13 x(pks(n,3))+13 x(pks(n,3))+13];
        yy = [0 upper_y upper_y 0];
        h = fill(xx,yy,[.75 .75 .75]);
        set(h,'edgecolor',[.75 .75 .75])
    end
end

subplot(3,1,1)
hist(no_marsh(:,5),100) % No marsh
subplot(3,1,2)
hist(narrow_marsh(:,5),100) % Narrow marsh
subplot(3,1,3)
hist(wide_marsh(:,5),100) % Wide marsh


subplot(3,1,2)
ylabel('Frequency','FontSize',25);
subplot(3,1,3)
xlabel('Backbarrier marsh width (m)','FontSize',25);

% Plot the location of the initial conditions
for n = 1:3
    subplot(3,1,n)
    hold on
    plot([init_widths(n) init_widths(n)],[0 upper_y],'--k','LineWidth',1.5)
%     plot([x(pks(n,2)) x(pks(n,2))],[0 upper_y],'--r','LineWidth',1.5) % Location of peaks
end

set(fh,'units','normalized','position',[.1 .1 .8 .8])
set(gcf, 'PaperPositionMode', 'auto');

saveas(fh, ['../Walters/' num2str(run) 'Modern runs/' file ' frequency.fig'])
outputfilename = ['../Walters/' num2str(run) 'Modern runs/' file ' frequency'];
print('-dpng',outputfilename)
%%%%%%%%%%%%%
%%%%%%%%%%%%%
%%%%%%%%%%%%%

%%%Use code below to visualize frequency distribution for all widths,
%%%except those with the narrow marsh as the initial condition

% all_widths = [no_marsh ; wide_marsh];
% 
% fh = figure;
% hold on
% 
%  % Set x- and y-limits and label the axes on the plot
% [nn,x] = hist(all_widths(:,5),100);
% upper_y = max(nn) + 25;
% set(gca,'XLim',[-50 2000])
% set(gca,'YLim',[0 upper_y])
% ylabel('Frequency','FontSize',25); 
% xlabel('Backbarrier marsh width (m)','FontSize',25);
% 
% pks = findpeaks(nn,3,perc);
% 
% stable_range = zeros(3,2);
% 
% for n = 1:3
%     xx = [x(pks(n,2)-pks(n,3))-15 x(pks(n,2)-pks(n,3))-15 x(pks(n,2)+pks(n,4))+15 x(pks(n,2)+pks(n,4))+15];
%     yy = [0 upper_y upper_y 0];
%     h = fill(xx,yy,[.75 .75 .75]);
%     set(h,'edgecolor',[.75 .75 .75])
%     stable_range(n,:) = [xx(1) xx(4)];
% end
% 
% hist(all_widths(:,5),100)
% 
% for n = 1:3
%     plot([x(pks(n,2)) x(pks(n,2))],[0 upper_y],'--k','LineWidth',1.5)
% end
% 
% set(gca,'FontSize',16)
% set(fh,'units','normalized','position',[.1 .1 .8 .8])
% set(gcf, 'PaperPositionMode', 'auto');