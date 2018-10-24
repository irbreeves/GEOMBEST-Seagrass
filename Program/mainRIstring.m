function mainRIstring(RI1,RI2,RSLR1,RSLR2,SG)
% Min RivInput, Max RivInput, Min RSLR, Max RSLR, Seagrass (0 or 1)

% Run mainstring for a range of RivInput (bay sediment flux) values, while varying
% RSLR

% SG = 0 - runs with seagrass both turned off and then turned on
% SG = 1 - only runs with seagrass turned on


% Originally from   David Walters
% Modified by       Ian Reeves 18-March-2017


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

% Loop through seagrass on vs seagrass off 
for sg = SG:1 
    % Loop through RSLR values
    for RSLR = RSLR1:RSLR2

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

    % Loop through RI values
    for RivInput = RI1:2:RI2

        % Write RI values to the input files
        for file = RSLR1:RSLR2 
            Tsteps = ceil(maxSL/(file/100)); % Number of time steps to reach MaxSl of sea level rise
            x(1:Tsteps) = RivInput; % Create vector repeating RI values
            x0 = x';
            xlswrite(['../Input' num2str(file) '/run1'],x0,'Sheet1',strcat('C',num2str(initial),':C',num2str(initial+Tsteps-1)))
        end

        % Run a string of simulations for a given RI value, varying RSLR
        message2 = strcat(['\nRivInput = ',num2str(RivInput)]);
        fprintf(2,message2);
        mainstring(RSLR1,RSLR2)

        % Create plots for each model run from the string            
        for filethread = RSLR1:RSLR2
            filename = ['C:\GEOMBEST+\Output' num2str(filethread) '\shorelines.mat'];
            temp = load(filename);
            Ts = numel(temp.shorelines); % Number of time steps in the run
            plottractcolour(filethread,Ts,1,Ts,1,['RSLR = ' num2str(filethread) '   RI = ' num2str(RivInput)])
            marsh_migrationrate = plotmarshedge(filethread,10,['RSLR = ' num2str(filethread) '   RI = ' num2str(RivInput)]);
            shore_migrationrate = plotshore(filethread,10,['RSLR = ' num2str(filethread) '   RI = ' num2str(RivInput)]);
            [X,width] = evalc('MarshWidth(filethread,filethread)');

            % Save results to spreadsheet
            if sg == 1
                xlswrite(['C:/GEOMBEST+/Data'],filethread,'Sheet1',strcat('A',num2str(dataRow)))
                xlswrite(['C:/GEOMBEST+/Data'],RivInput,'Sheet1',strcat('B',num2str(dataRow)))
                xlswrite(['C:/GEOMBEST+/Data'],sg,'Sheet1',strcat('C',num2str(dataRow)))
                xlswrite(['C:/GEOMBEST+/Data'],width,'Sheet1',strcat('D',num2str(dataRow)))
                xlswrite(['C:/GEOMBEST+/Data'],shore_migrationrate,'Sheet1',strcat('E',num2str(dataRow)))
                xlswrite(['C:/GEOMBEST+/Data'],marsh_migrationrate,'Sheet1',strcat('F',num2str(dataRow)))
        
                dataRow = dataRow+1; % Increment data row
            elseif sg == 0
                xlswrite(['C:/GEOMBEST+/Data'],sg,'Sheet1',strcat('G',num2str(dataRowNoSG)))
                xlswrite(['C:/GEOMBEST+/Data'],width,'Sheet1',strcat('H',num2str(dataRowNoSG)))
                xlswrite(['C:/GEOMBEST+/Data'],shore_migrationrate,'Sheet1',strcat('I',num2str(dataRowNoSG)))
                xlswrite(['C:/GEOMBEST+/Data'],marsh_migrationrate,'Sheet1',strcat('J',num2str(dataRowNoSG)))
        
                dataRowNoSG = dataRowNoSG+1; % Increment NoSG data row
            end
        end

        % Copy the files from the model run to the Rivinput Experiments folder
        for file1 = RSLR1:RSLR2
            if sg == 1
            copyfile(['C:/GEOMBEST+/Input' num2str(file1)],['C:/GEOMBEST+/RI-RSLR_Experiments_' date '/RI' num2str(RivInput) '/Input' num2str(file1)],'f')
            copyfile(['C:/GEOMBEST+/Output' num2str(file1)],['C:/GEOMBEST+/RI-RSLR_Experiments_' date '/RI' num2str(RivInput) '/Output' num2str(file1)],'f')
            else
            copyfile(['C:/GEOMBEST+/Input' num2str(file1)],['C:/GEOMBEST+/RI-RSLR_Experiments_NoSG_' date '/RI' num2str(RivInput) '/Input' num2str(file1)],'f')
            copyfile(['C:/GEOMBEST+/Output' num2str(file1)],['C:/GEOMBEST+/RI-RSLR_Experiments_NoSG_' date '/RI' num2str(RivInput) '/Output' num2str(file1)],'f')   
            end
        end
    end
end    

end
