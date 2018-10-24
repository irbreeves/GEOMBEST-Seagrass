function [erosioncoeff] = geterosioncoeff(t,j)

% geterosioncoeff -- reads runfiles and returns the erosion coefficeint appropriate for the timestep (t). 
% This function is necessary beacuse runfiles considers only 
% whole steps while t is comprised of wholesteps(entered by the user)
% and a number of substeps specified by the user 

% RL - 6/25/15



global T;
global runfiles;

substeps = T ./ size(runfiles(j).erosioncoeff,2);

for a = 1:T ./ substeps    
    if t <= a .* substeps
        erosioncoeff = runfiles(j).erosioncoeff(a);
        break;
    end    
end