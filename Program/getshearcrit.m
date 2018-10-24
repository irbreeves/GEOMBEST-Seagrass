function [shearcrit] = getshearcrit(t,j)

% getshearcrit -- reads runfiles and returns the critical shear stress entry appropriate for the timestep (t). 
% This function is necessary beacuse runfiles considers only 
% whole steps while t is comprised of wholesteps(entered by the user)
% and a number of substeps specified by the user 

% RL - 13-Nov-2014



global T;
global runfiles;

substeps = T ./ size(runfiles(j).shearcrit,2);

for a = 1:T ./ substeps    
    if t <= a .* substeps
        shearcrit = runfiles(j).shearcrit(a);
        break;
    end    
end