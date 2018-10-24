function [decaycoeff] = getdecaycoeff(t,j)

% getdecaycoeff -- reads runfiles and returns the wave height decay coefficient entry appropriate for the timestep (t). 
% This function is necessary beacuse runfiles considers only 
% whole steps while t is comprised of wholesteps(entered by the user)
% and a number of substeps specified by the user 

% IR - 2-March-2017



global T;
global runfiles;

substeps = T ./ size(runfiles(j).decaycoeff,2);

for a = 1:T ./ substeps    
    if t <= a .* substeps
        decaycoeff = runfiles(j).decaycoeff(a);
        break;
    end    
end