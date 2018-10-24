function [q_b] = getbaysedflux(t,j)


% getbaysedflux -- reads runfiles and returns the input of riverine sediment 
% to the bay entry appropriate for the timestep (t). 
% This function is necessary beacuse runfiles considers only 
% whole steps while t is comprised of wholesteps(entered by the user)
% and a number of substeps specified by the user 

% David Walters

% Version of Jun-27-2012

global T;
global runfiles;

substeps = T ./ size(runfiles(j).baysedflux,2);

for a = 1:T ./ substeps    
    if t <= a .* substeps
        q_b = runfiles(j).baysedflux(a);
        break;
    end    
end

