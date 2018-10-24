function PhaseSpace_Movie(RI1,RI2,RSLR1,RSLR2,maxTS,Title)
% Min RivInput, Max RivInput, Min RSLR, Max RSLR, Time Steps, Movie Title

% Run mainstring for a range of RivInput (Bay sediment flux) values while 
% varying RSLR. Runs to a maximum of 1 m RSLR.

% Records the difference in marsh width between the identical seagrass and 
% no seagrass runs at each time step, stores that information in an Array, 
% plots the interpolated phase space of those differences at each step, and 
% makes a movie that progresses through time.

% Ian Reeves 9-May-2017


% Stop if no data file is in folder - need spreadsheet named data.xls to record data to
if exist('C:/GEOMBEST+/Data.xls') == 0
    fprintf('\nError: No data.xls file is in GEOMBEST+ folder!\n');
    return
end

message = strcat(['\nRiv Input: ',num2str(RI1),'-',num2str(RI2),', RSLR: ',num2str(RSLR1),'-',num2str(RSLR2),'\n']);
fprintf(2,message);
fprintf('__________________________\n');
warning('off','MATLAB:MKDIR:DirectoryExists');

dataRow = 2;
dataRowNoSG = 2;

TS = maxTS;

% Initialize array to hold data
Array = zeros((numel(RSLR1:RSLR2)),(numel(RI1:6:RI2)),TS); %# HARD WIRED!!


%%% Loop through RSLR values - Make directories each with unique RSLR values

% No Seagrass
for RSLR = RSLR1:RSLR2
    sg = 0;

    initial = 13; % Allow for consistent initial conditions to form in time steps 1-10 (rows 3-12)
    maxSL = 1; % (m) Height of SL each run will end at
    Tsteps = ceil(maxSL/(RSLR/100)); % Number of time steps to reach MaxSl of sea level rise
    t(1:Tsteps) = 1:Tsteps; % Create a vector containing all of the time steps
    ts = t' * 10; % Convert vector to column, and multiply by the length of time step
    SL = (ts)*RSLR/1000; % Create a vector of sea level height values in mm
    
    
    
    % Write the RSLR values to the runfile
    runfile = RSLR; 
    InName = strcat('C:/GEOMBEST+/Input',num2str(runfile));
    OutName = strcat('Output',num2str(runfile));
    copyfile ('C:/GEOMBEST+/BaseFile', InName) % Create new Input folder
    mkdir ('C:/GEOMBEST+', OutName) % Create new Output folder
    xlswrite(['../Input' num2str(runfile) '/run1'],SL,'Sheet1',strcat('B',num2str(initial),':B',num2str(initial+Tsteps-1)))
    xlswrite(['../Input' num2str(runfile) '/run1'],sg,'Sheet1',strcat('M',num2str(initial),':M',num2str(initial+Tsteps-1)))
    delete = repmat({''},150,13); % Create array of empty strings 150row by 13column (number of columns in Run files)
    xlswrite(['../Input' num2str(runfile) '/run1'],delete,'Sheet1',strcat('A',num2str(initial+Tsteps))) % Delete remaining entries in Input table left over from copy of BaseFile
end

% Seagrass
for RSLR = (RSLR2+1):(RSLR2+numel(RSLR1:RSLR2))
    sg = 1;
    initial = 13; % Allow for consistent initial conditions to form in time steps 1-10 (rows 3-12)
    maxSL = 1; % (m) Height of SL each run will end at
    Tsteps = ceil(maxSL/((RSLR-(numel(RSLR1:RSLR2)))/100)); % Number of time steps to reach MaxSl of sea level rise
    t(1:Tsteps) = 1:Tsteps; % Create a vector containing all of the time steps
    ts = t' * 10; % Convert vector to column, and multiply by the length of time step
    SL = (ts)*(RSLR-(numel(RSLR1:RSLR2)))/1000; % Create a vector of sea level height values in mm

    % Write the RSLR values to the runfile
    runfile = RSLR; 
    InName = strcat('C:/GEOMBEST+/Input',num2str(runfile));
    OutName = strcat('Output',num2str(runfile));
    copyfile ('C:/GEOMBEST+/BaseFile', InName) % Create new Input folder
    mkdir ('C:/GEOMBEST+', OutName) % Create new Output folder
    xlswrite(['../Input' num2str(runfile) '/run1'],SL,'Sheet1',strcat('B',num2str(initial),':B',num2str(initial+Tsteps-1)))
    xlswrite(['../Input' num2str(runfile) '/run1'],sg,'Sheet1',strcat('M',num2str(initial-10),':M',num2str(initial+Tsteps-1))) %# For setting initial widths equal with pre-established meadow
%     xlswrite(['../Input' num2str(runfile) '/run1'],sg,'Sheet1',strcat('M',num2str(initial),':M',num2str(initial+Tsteps-1)))
    xlswrite(['../Input' num2str(runfile) '/run1'],56.85,'Sheet1',strcat('C',num2str(initial-10),':C',num2str(initial-1))) %# HARD-WIRED!! Sets intitial widths equal with pre-established meadow
%     xlswrite(['../Input' num2str(runfile) '/run1'],0,'Sheet1',strcat('C',num2str(initial-10),':C',num2str(initial-1))) %# HARD-WIRED!! 
    delete = repmat({''},150,13); % Create array of empty strings 150row by 13column (number of columns in Run files)
    xlswrite(['../Input' num2str(runfile) '/run1'],delete,'Sheet1',strcat('A',num2str(initial+Tsteps))) % Delete remaining entries in Input table left over from copy of BaseFile
end

%%% Loop through RI values
for RivInput = RI1:6:RI2

    %%% Write RI values to the RSLR input files
    for file = RSLR1:RSLR2 
        file2 = file+(numel(RSLR1:RSLR2));
        Tsteps = ceil(maxSL/(file/100)); % Number of time steps to reach MaxSl of sea level rise
        x(1:Tsteps) = RivInput; % Create vector repeating RI values
        x0 = x';
        xlswrite(['../Input' num2str(file) '/run1'],x0,'Sheet1',strcat('C',num2str(initial),':C',num2str(initial+Tsteps-1)))
        xlswrite(['../Input' num2str(file2) '/run1'],x0,'Sheet1',strcat('C',num2str(initial),':C',num2str(initial+Tsteps-1))) 
    end
    
    %%% Run a string of simulations for a given RI value, varying RSLR
    message2 = strcat(['\nRivInput = ',num2str(RivInput)]);
    fprintf(2,message2);
    mainstring(RSLR1,(RSLR2+(numel(RSLR1:RSLR2))));

    %%% Store width difference for each coupled model simulation from the string in Array
    
    % No Seagrass
    for filethread = RSLR1:RSLR2
        % No Seagrass
        sg = 0;
        filename = ['C:\GEOMBEST+\Output' num2str(filethread) '\shorelines.mat'];
        temp = load(filename);
        Ts = numel(temp.shorelines); % Number of time steps in the run
        [X,finalwidth] = evalc('MarshWidth(filethread,filethread)');
        shore_migrationrate = plotshore(filethread,10,['RSLR = ' num2str(filethread) '   RI = ' num2str(RivInput)]);

        widths_NoSG = MarshWidthOverTime(filethread,filethread,TS+10);
        
        % Save results to spreadsheet - No seagrass
        xlswrite(['C:/GEOMBEST+/Data'],sg,'Sheet1',strcat('G',num2str(dataRowNoSG)))
        xlswrite(['C:/GEOMBEST+/Data'],finalwidth,'Sheet1',strcat('H',num2str(dataRowNoSG)))
        xlswrite(['C:/GEOMBEST+/Data'],shore_migrationrate,'Sheet1',strcat('I',num2str(dataRowNoSG)))

        dataRowNoSG = dataRowNoSG+1; % Increment NoSG data row
    
        % Seagrass
        sg = 1;
        filethread2 = filethread+(numel(RSLR1:RSLR2));
        filename2 = ['C:\GEOMBEST+\Output' num2str(filethread2) '\shorelines.mat'];
        temp2 = load(filename2);
        Ts = numel(temp2.shorelines); % Number of time steps in the run
        [X,finalwidth] = evalc('MarshWidth(filethread2,filethread)');
        shore_migrationrate = plotshore(filethread,10,['RSLR = ' num2str(filethread) '   RI = ' num2str(RivInput)]);

        widths_SG = MarshWidthOverTime(filethread2,filethread,TS+10);
        
        % Save results to spreadsheet - Seagrass
        xlswrite(['C:/GEOMBEST+/Data'],filethread,'Sheet1',strcat('A',num2str(dataRow)))
        xlswrite(['C:/GEOMBEST+/Data'],RivInput,'Sheet1',strcat('B',num2str(dataRow)))
        xlswrite(['C:/GEOMBEST+/Data'],sg,'Sheet1',strcat('C',num2str(dataRow)))
        xlswrite(['C:/GEOMBEST+/Data'],finalwidth,'Sheet1',strcat('D',num2str(dataRow)))
        xlswrite(['C:/GEOMBEST+/Data'],shore_migrationrate,'Sheet1',strcat('E',num2str(dataRow)))

        dataRow = dataRow+1; % Increment data row
        
        % Calc difference in width at each time step, seagrass vs no seagrass for this simulation
        WidthDifference = widths_SG - widths_NoSG;
        
        % Store width difference in 3-D array (RSLR, RivInput, Time Step)
        
        slr = filethread -1;    %# HARD-WIRED!! Change for different phase space dimensions
        ri = RivInput/6;        %# HARD-WIRED!!
        for step = 1:TS+10
            Array(slr,ri,step) = WidthDifference(step);
        end       
    end
    
    
    %%% Copy the files from the model run to the Rivinput Experiments folder
    for file1 = RSLR1:(RSLR2+(numel(RSLR1:RSLR2)))
        copyfile(['C:/GEOMBEST+/Input' num2str(file1)],['C:/GEOMBEST+/RI-RSLR_PhaseSpace' date '/RI' num2str(RivInput) '/Input' num2str(file1)],'f')
        copyfile(['C:/GEOMBEST+/Output' num2str(file1)],['C:/GEOMBEST+/RI-RSLR_PhaseSpace' date '/RI' num2str(RivInput) '/Output' num2str(file1)],'f')    
    end
end
 
% Save Array
save(['C:/GEOMBEST+/PSArray_' date '.mat'],'Array')




end





