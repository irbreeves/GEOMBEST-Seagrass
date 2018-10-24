function [seagrass] = getseagrass(t,j)

% getseagrass -- reads runfiles and returns the binary (Yes or No) segrass determination entry appropriate for the timestep (t). 
% This function is necessary beacuse runfiles considers only 
% whole steps while t is comprised of wholesteps(entered by the user)
% and a number of substeps specified by the user 

% IR - 27-March-2017



global T;
global runfiles;

substeps = T ./ size(runfiles(j).seagrass,2);

for a = 1:T ./ substeps    
    if t <= a .* substeps
        seagrass = runfiles(j).seagrass(a);
        break;
    end    
end