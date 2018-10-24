function [q_ow] = getoverwashflux(t,j)

% getoverwashflux -- reads runfiles and returns the backbarrier overwash 
% volume flux (q_ow) for the timestep (t). This function is necessary 
% beacuse runfiles considers only whole steps while t is comprised of 
% wholesteps(entered by the user) and a number of substeps specified by the 
% user 

% David Walters

% Version of 21-Jun-2012


global T;
global runfiles;

substeps = T ./ size(runfiles(j).overwashflux,2);

for a = 1:T ./ substeps    
    if t <= a .* substeps
        q_ow = runfiles(j).overwashflux(a);
        break;
    end    
end