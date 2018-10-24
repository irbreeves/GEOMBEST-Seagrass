function loadrunfiles(filethread) 

% loadrunfiles -- reads data from the run# excel files
% creates runfiles structure array, comprising a series of run# structures
% each run# structure comprises .time, .sealevel, .estrate, .estsand, .bbvol, .exovol, and .resus fields 
% each of these fields is a vector of length T that defines parameter values at each timestep
% the function also creates SL(t) which records the sea level at each
% timestep, relative to the initial time step, and TP(t) which records the
% timeperiod (yrs) of each timestep 

% Dr David Stolper dstolper@usgs.gov

% Version of 26-Dec-2002 10:31
% Updated    10-Apr-2003 13:11

% Updated 3-March-2017 Ian Reeves

global runfiles;
global T;
global M;
global TP; % number of years at each time step
global SL;

rootname = ['C:/GEOMBEST+/Input' num2str(filethread) '/run']; % directory containing runfiles

flag = 1; % indicates the existence of a run# file 
M = 0; % number of run# files (and therefore tracts) in the rootname directory
cols = 6; % number of columns in the excel files

while flag == 1
    filename = [rootname int2str(M + 1) '.xls'];
    
    if exist (filename) == 2 
        M = M + 1;
        numbers = xlsread(filename, 'Sheet1', 'a1:r2000');
        T = size(numbers,1) - 2;         
        
        for row = 1:T                
                runfiles(M).time(row) = numbers(row + 2,1); % yr
                runfiles(M).sealevel(row)= numbers(row + 2,2); % change in sea level (m)
                runfiles(M).baysedflux(row) = numbers(row + 2,3); % sediment flux across the bay
                runfiles(M).bbwidth(row) = numbers(row + 2,4); % backbarrier width (overwash and dlood-tide-delta deposits landwards of the barrier crest
                runfiles(M).exovol(row) = numbers(row + 2,5); % sand volume added to the tract via longshore deposition or sand nourishment (m3)
                runfiles(M).overwashrate(row) = numbers(row + 2,6); % DW - rate of overwash accretion - controls the length of overwash spreading
                runfiles(M).overwashflux(row) = numbers(row + 2,7); % DW - volume of overwash deposited onto the backbarrier from storms
                runfiles(M).highwater(row) = numbers(row + 2,8); % DW - highwater line from the tidal range
                runfiles(M).windspeed(row) = numbers(row + 2,9); % RL - wind speed
                runfiles(M).erosioncoeff(row) = numbers(row + 2,10); % RL - erosion coefficient for marsh edge erosion
                runfiles(M).decaycoeff(row) = numbers(row + 2,11); % IR - coefficient for wave height decay over seagrass meadow
                runfiles(M).seagrass(row) = numbers(row + 2,12); % IR - binary determination for presence or absence of seagrass (1=segrass, 0=no segrass)
%                 runfiles(M).shearcrit(row) = numbers(row + 2,10); % Removed by IR 10/22/18
        end         
    else 
        flag = 0; % the run# file doesn't exist
    end
end

T = T .* numbers(1,3); % updates T to include substeps 

% build TP

for substep = 1:numbers(1,3)
    TP(substep) = runfiles(1).time(1) ./ numbers(1,3);    
end


t = numbers(1,3) + 1;
for fullstep = 2: T ./ numbers(1,3)
    for substep = 1:numbers(1,3)        
        if t ~= 1        
            TP(t) = (runfiles(1).time(fullstep) - runfiles(1).time(fullstep - 1)) ./ numbers(1,3);              
        end  
        t = t + 1;
    end     
end
    
% build SL

for j = 1:M
    cumulativesealevel = 0;    
    for substep = 1:numbers(1,3)
        cumulativesealevel = cumulativesealevel + runfiles(j).sealevel(1) ./ numbers(1,3);
        SL(substep,j) = cumulativesealevel;    
    end

    t = numbers(1,3) + 1;
    for fullstep = 2: T ./ numbers(1,3)
        for substep = 1:numbers(1,3)        
            if t ~= 1        
                cumulativesealevel = cumulativesealevel + (runfiles(j).sealevel(fullstep) - runfiles(j).sealevel(fullstep - 1)) ./ numbers(1,3);
                SL(t,j) = cumulativesealevel;             
            end  
            t = t + 1;
        end     
    end
end