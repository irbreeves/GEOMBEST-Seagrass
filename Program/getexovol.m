function [exovol] = getexovol(t,j);

% getexovol -- reads runfiles and returns the exovol entry 
% appropriate for the timestep (t). This function is 
% necessary beacuse runfiles considers only whole steps 
% while t is comprised of wholesteps(entered by the user)
% and a number of substeps specified by the user 

% Dr David Stolper dstolper@usgs.gov

% Version of 29-Jan-2003 17:03
% Updated    29-Jan-2003 17:03



global T;
global runfiles;

substeps = T ./ size(runfiles(j).exovol,2);

for a = 1:T ./ substeps    
    if t <= a .* substeps
        exovol = runfiles(j).exovol(a);
        break;
    end    
end