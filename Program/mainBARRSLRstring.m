function mainBARRSLRstring(SG)
% Min RivInput, Max RivInput, Min RSLR, Max RSLR, Seagrass (0 or 1)

% Run mainstring for a range of BAR/RSLR values,  varying
% varying overwash volume 

% SG = 0 - runs with seagrass both turned off and then turned on
% SG = 1 - only runs with seagrass turned on


% Ian Reeves 20-April-2017

% Set values
% OW = [.2,.8,1.4,2];
% RSLR = [1,2,3,5,4,6,10];
% RI = [48,48,36,36,12,12,12];

OW = [.2];
RSLR = [3,4];
RI = [72,48];

% Stop if no data file is in folder - need spreadsheet named data.xls to record data to
if exist('C:/GEOMBEST+/BARData.xls') == 0
    fprintf('\nError: No data.xls file is in GEOMBEST+ folder!\n');
    return
end

message = strcat(['\nOverwash: ',num2str(OW(1)),'-',num2str(OW(end)),', BAR/RSLR: ',num2str(RI(1)/12/RSLR(1)),'-',num2str(RI(end)/12/RSLR(end)),'\n']);
fprintf(2,message);
fprintf('__________________________\n');
warning('off','MATLAB:MKDIR:DirectoryExists');

dataRow = 2;
dataRowNoSG = 2;

% Loop through seagrass on vs seagrass off 
for sg = SG:1 
    % Loop through OW values
    for idx = 1:numel(RSLR)
        rslr = RSLR(idx);
        ri = RI(idx);
        initial = 13; % Allow for consistent initial conditions to form in time steps 1-10 (rows 3-12)
        maxSL = 1; % (m) Height of SL each run will end at

        Tsteps = ceil(maxSL/(rslr/100)); % Number of time steps to reach MaxSl of sea level rise

        t(1:Tsteps) = 1:Tsteps; % Create a vector containing all of the time steps
        ts = t' * 10; % Convert vector to column, and multiply by the length of time step
        SL = (ts)*rslr/1000; % Create a vector of sea level height values in mm

        % Write the RSLR values to the runfile
        runfile = rslr; 
        InName = strcat('C:/GEOMBEST+/Input',num2str(runfile));
        OutName = strcat('Output',num2str(runfile));
        copyfile ('C:/GEOMBEST+/BaseFile', InName) % Create new Input folder
        mkdir ('C:/GEOMBEST+', OutName) % Create new Output folder
        xlswrite(['../Input' num2str(runfile) '/run1'],SL,'Sheet1',strcat('B',num2str(initial),':B',num2str(initial+Tsteps-1)))
        xlswrite(['../Input' num2str(runfile) '/run1'],sg,'Sheet1',strcat('M',num2str(initial),':M',num2str(initial+Tsteps-1)))
        xlswrite(['../Input' num2str(runfile) '/run1'],ri,'Sheet1',strcat('C',num2str(initial),':C',num2str(initial+Tsteps-1)))
        delete = repmat({''},150,13); % Create array of empty strings 150row by 13column (number of columns in Run files)
        xlswrite(['../Input' num2str(runfile) '/run1'],delete,'Sheet1',strcat('A',num2str(initial+Tsteps))) % Delete remaining entries in Input table left over from copy of BaseFile
    end
    
    % Loop through OW values
    for idx = 1:numel(OW)
        ow = OW(idx);

        % Write OW values to the input files
        for fileidx = 1:numel(RSLR)
            file = RSLR(fileidx);
            Tsteps = ceil(maxSL/(file/100)); % Number of time steps to reach MaxSl of sea level rise
            x(1:Tsteps) = ow; % Create vector repeating ow values
            x0 = x';
            xlswrite(['../Input' num2str(file) '/run1'],x0,'Sheet1',strcat('G',num2str(initial),':G',num2str(initial+Tsteps-1)))
        end

        % Run a string of simulations for a given RI value, varying RSLR
        fprintf('\nOverwash = %d', ow);
        for idx = 1:numel(RSLR)
            run = RSLR(idx);
            main(run);
        end
        
        % Create plots for each model run from the string            
        for idx = 1:numel(RSLR)
            filethread = RSLR(idx);
            riv = RI(idx);
            filename = ['C:\GEOMBEST+\Output' num2str(filethread) '\shorelines.mat'];
            temp = load(filename);
            barrslr = (RI(idx)/12)/RSLR(idx);
            Ts = numel(temp.shorelines); % Number of time steps in the run
            plottractcolour(filethread,Ts,1,Ts,1,[''])
            marsh_migrationrate = plotmarshedge(filethread,10,['']);
            [X,width] = evalc('MarshWidth(filethread,filethread)');

            % Save results to spreadsheet
            if sg == 1
                xlswrite(['C:/GEOMBEST+/BARData'],filethread,'Sheet1',strcat('A',num2str(dataRow)))
                xlswrite(['C:/GEOMBEST+/BARData'],riv,'Sheet1',strcat('B',num2str(dataRow)))
                xlswrite(['C:/GEOMBEST+/BARData'],ow,'Sheet1',strcat('D',num2str(dataRow)))
                xlswrite(['C:/GEOMBEST+/BARData'],sg,'Sheet1',strcat('E',num2str(dataRow)))
                xlswrite(['C:/GEOMBEST+/BARData'],width,'Sheet1',strcat('F',num2str(dataRow)))
                xlswrite(['C:/GEOMBEST+/BARData'],barrslr,'Sheet1',strcat('C',num2str(dataRow)))
                xlswrite(['C:/GEOMBEST+/BARData'],marsh_migrationrate,'Sheet1',strcat('G',num2str(dataRow)))
        
                dataRow = dataRow+1; % Increment data row
            elseif sg == 0
                xlswrite(['C:/GEOMBEST+/BARData'],sg,'Sheet1',strcat('H',num2str(dataRowNoSG)))
                xlswrite(['C:/GEOMBEST+/BARData'],width,'Sheet1',strcat('I',num2str(dataRowNoSG)))
                xlswrite(['C:/GEOMBEST+/BARData'],marsh_migrationrate,'Sheet1',strcat('J',num2str(dataRowNoSG)))
   
                dataRowNoSG = dataRowNoSG+1; % Increment NoSG data row
            end
        end

        % Copy the files from the model run to the Rivinput Experiments folder
        for idx = 1:numel(RSLR)
            file1 = RSLR(idx);
            if sg == 1
            copyfile(['C:/GEOMBEST+/Input' num2str(file1)],['C:/GEOMBEST+/BARRSLR_Experiments_' date '/OW' num2str(ow*10) '/Input' num2str(file1)],'f')
            copyfile(['C:/GEOMBEST+/Output' num2str(file1)],['C:/GEOMBEST+/BARRSLR_Experiments_' date '/OW' num2str(ow*10) '/Output' num2str(file1)],'f')
            else
            copyfile(['C:/GEOMBEST+/Input' num2str(file1)],['C:/GEOMBEST+/BARRSLR_Experiments_NoSG_' date '/OW' num2str(ow*10) '/Input' num2str(file1)],'f')
            copyfile(['C:/GEOMBEST+/Output' num2str(file1)],['C:/GEOMBEST+/BARRSLR_Experiments_NoSG_' date '/OW' num2str(ow*10) '/Output' num2str(file1)],'f')   
            end
        end
    end
end    

end
