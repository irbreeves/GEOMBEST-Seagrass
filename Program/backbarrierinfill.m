function [dunevol,tempgrid,ii] = backbarrierinfill (tempgrid,t,j,icrest,shorewidth)

% Backbarrierinfill --
% 1) Infills the backbarrier via overwash, riverine input, and marsh accretion
% 2) Updates tempgrid

% Dr David Stolper dstolper@usgs.gov

% Version of 02-Jan-2003 10:47
% Updated    08-Apr-2003 4:47
% Updated DW 22-Jun-2012
% Updated RL 13-Nov-2014
% Updated IR 29-Jan-2017

global TP;
global SL;
global stormcount;

% Build the back-half of the dune up to the equilibrium morphology
[dunevol,tempgrid] = dunebuild (tempgrid,icrest,t,j,shorewidth);
    
% Update the bay surface and calculate volume of sediment eroded
[tempgrid,marshvol,icrest,targetDepth] = bayevolution(icrest,tempgrid,t,j,TP);

% Erode the marsh edge due to wind waves, and add % of that sediment to sed available from bay erosion
% if t < 11
    [tempgrid,redepvol,maxDeq,icrest] = erodemarsh(icrest,tempgrid,t,j,t,TP,targetDepth);
% else
%     [tempgrid,redepvol,maxDeq,icrest] = erodemarsh_OrgConserv(icrest,tempgrid,t,j,t,TP,targetDepth);        %%% For no conservation of all organic sediment
% end

% Grow the marsh at the left and right boundaries of the bay
% if t < 11
    [tempgrid] = growmarsh(tempgrid,marshvol,t,j,t,redepvol,maxDeq,icrest);
% else
%     [tempgrid] = growmarsh_NoAugmen(tempgrid,marshvol,t,j,t,redepvol,maxDeq,icrest);                        %%% For no augmentation from organic matter
% end


stormcount = zeros(1,5);

[tempgrid,ii] = overwash(tempgrid,j,t);


end
