function [windspeed] = getwindspeed(t,j)

% getwindspeed -- reads runfiles and returns the wind speed entry appropriate for the timestep (t). 
% This function is necessary beacuse runfiles considers only 
% whole steps while t is comprised of wholesteps(entered by the user)
% and a number of substeps specified by the user 

% RL - 10/13/14



global T;
global runfiles;

substeps = T ./ size(runfiles(j).windspeed,2);

for a = 1:T ./ substeps    
    if t <= a .* substeps
        windspeed = runfiles(j).windspeed(a);
        break;
    end    
end