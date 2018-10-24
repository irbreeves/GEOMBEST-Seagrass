function savetimestep(g,t,filethread)

% savetimestep -- saves a file called step_'t' which is the stratigraphic data 
% at simulation step t. This data comes from the timestep of gridstrat specified
% by 'g', remembering that g comprises only two timesteps. 

% Dr David Stolper dstolper@usgs.gov

% Version of 09-Apr-2003 11:51
% Updated    09-Apr-2003 17:00

global gridstrat;
global seagrass;

n = int2str(t); while length(n)<4, n = ['0' n]; end
varname = ['step_' n];

filename = ['../Output' num2str(filethread) '/' varname '.mat'];
    
eval ([varname ' = gridstrat(g,:,:,:,:);'])
save(filename,varname)


%%% Save Seagrass file - IR 9-Mar-2017

varname2 = ['seagrass_' n];
filename2 = ['../Output' num2str(filethread) '/' varname2 '.mat'];
save (filename2, 'seagrass')


end