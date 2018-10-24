function [Lfetch_effective,Rfetch_effective,avgLdepth,avgRdepth] = attenuation(tempgrid,t,j)
%attenuation Attenuates wave height due to seagrass and returns effective fetch

% Calculates and returns the effective fetches for waves propogating in both directions as a result 
% of attenuation from the seagrass meadow. Wave height decay is modeled as an exponential function,
% and the decay coefficient varies with the shoot density of the meadow.

% Ian Reeves 
% Version of 7-April-2017


global celldim;
global zcentroids;
global SL;
global bay;
global seagrass;
global lookup;


%%% Set values

rbay = bay(1); % First cell in bay on right
lbay = bay(length(bay)); % Last cell in bay on left
midbay = round(median(bay)); % Index location of the middle of bay
rDepth = 0;
lDepth = 0;
maxdensity = max(max(lookup));
meadowWidth = nnz(seagrass)*celldim(1,j); % (m) Width of seagrass bed    
if meadowWidth == 0
    meadowDensity = 0;
    pct = 0;
else
    meadowDensity = sum(seagrass)/(nnz(seagrass)); % Shoot density of seagrass meadow
    pct = meadowDensity/maxdensity; % Percent of max shootdensity
end


%%% Calculate average depth of whole bay

for i=rbay:lbay % For each cell in the bay
    realratio = sum(tempgrid(i,:,:),3); % Amount of sed in each cell of column i
    topcell = find(realratio == 1);
    topcell = topcell(1) - 1; % Top cell with sediment
    k = topcell;
    realratio = sum(tempgrid(i,k,:),3); % Amount of sediment in topcell
    H = (zcentroids(k)-celldim(3,j)./2)+ realratio*celldim(3,j); % Height
    depth(i+1-rbay) = SL(t,j)-H; % (m)
end
avgdepth = sum(depth)/length(depth); % Average depth of whole bay


%%% Calculate fetch and average depth of RIGHT bay 
% From seagrass meadow edge to marsh edge on right (island) side of bay, or from middle bay to marsh if no seagrass

if meadowWidth == 0 % If no seagrass in bay
    Rx = midbay-1;
else
    Rx = find(seagrass,1); % Right edge of seagrass meadow in bay
end
rFetch = (Rx-rbay)*celldim(1,j); % (m) Fetch of right (island) side of bay

for i = rbay:(Rx-1) % For each cell in right bay
    realratio = sum(tempgrid(i,:,:),3); % Amount of sed in each cell of column i
    topcell = find(realratio == 1);
    topcell = topcell(1) - 1; % Top cell with sediment
    k = topcell;
    realratio = sum(tempgrid(i,k,:),3); % Amount of sediment in topcell
    H = (zcentroids(k)-celldim(3,j)./2)+ realratio*celldim(3,j); % Height
    rDepth(i+1-rbay) = SL(t,j)-H; % Meters
end
avgRdepth = sum(rDepth)/length(rDepth); % Average depth of right bay



%%% Calculate fetch and average depth of LEFT bay 
% From seagrass meadow edge to marsh edge on left (mainland) side of bay, or from middle bay to marsh if no seagrass 

if meadowWidth == 0 % If no seagrass in bay
    Lx = midbay;
else
    Lx = find(seagrass,1,'last'); % Left edge of seagrass meadow in bay
end
lFetch = (lbay-Lx)*celldim(1,j); % (m) Fetch of left (mainland) side of bay

for i = (Lx+1):lbay % For each cell in right bay
    realratio = sum(tempgrid(i,:,:),3); % Amount of sed in each cell of column i
    topcell = find(realratio == 1);
    topcell = topcell(1) - 1; % Top cell with sediment
    k = topcell;
    realratio = sum(tempgrid(i,k,:),3); % Amount of sediment in topcell
    H = (zcentroids(k)-celldim(3,j)./2)+ realratio*celldim(3,j); % Height
    lDepth(i-Lx) = SL(t,j)-H; % Meters
end
avgLdepth = sum(lDepth)/length(lDepth); % Average depth of left bay



%%% Calculate Wave power 

U = getwindspeed(t,j); % (m/s)
g = 9.81; % (m/s^2)
gamma = 9810; % Specific weight of water (N/m^3)
kerode = geterosioncoeff(t,j); % Varies per site (units m3/W/yr)
decaycoeff = getdecaycoeff(t,j);
c = decaycoeff*pct; % Max decay coefficient of 0.01 (Bradley and Houser, 2009), varies roughly +1:1 with shoot density (e.g. Manca et al., 2012)

% Calculate height of wave when reaching meadow edge
rHwave = (((U^2)*0.2413)*(tanh(0.493*((g*avgdepth)/(U^2)).^0.75)*tanh((0.00313*((g*rFetch)/(U^2)).^0.57)/tanh(0.493*((g*avgdepth)/(U^2)).^0.75))).^0.87)/g; % Wave height of right bay (m)
lHwave = (((U^2)*0.2413)*(tanh(0.493*((g*avgdepth)/(U^2)).^0.75)*tanh((0.00313*((g*lFetch)/(U^2)).^0.57)/tanh(0.493*((g*avgdepth)/(U^2)).^0.75))).^0.87)/g; % Wave height of left bay (m)

% Waves propogating towards right (island) side of bay
lHattenuated = lHwave*exp(-c*meadowWidth); % Attenuate left bay wave reaching right edge of meadow

rA = nthroot((real((lHattenuated*g)/((U.^2)*0.2413))),0.87);
rB = tanh(0.493*((g*avgdepth)/(U^2)).^0.75);
rC = nthroot(real(((atanh(((rA/rB)))*rB)/0.00313)),0.57);

rFetch_attenuated = ((U.^2)*rC)/g; % Back-solved to find fetch for the given attenuated wave height; used to account for regrowth of wave after leaving meadow before reaching marsh edge, below
Rfetch_effective = rFetch_attenuated + rFetch; % Effective fetch: equivalent attenuated fetch plus fetch of right bay; used to calculated total wave height reaching right marsh

% Waves propogating towards left (mainland) side of bay
rHattenuated = rHwave*exp(-c*meadowWidth); % Attenuate right bay wave reaching left edge of meadow

lA = nthroot((real((rHattenuated*g)/((U.^2)*0.2413))),0.87);
lB = tanh(0.493*((g*avgdepth)/(U^2)).^0.75);
lC = nthroot(real(((atanh(((lA/lB)))*lB)/0.00313)),0.57);

lFetch_attenuated = ((U.^2)*lC)/g; % Back-solved to find fetch for the given attenuated wave height; used to account for regrowth of wave after leaving meadow before reaching marsh edge, below
Lfetch_effective = lFetch_attenuated + lFetch; % Effective fetch: equivalent attenuated fetch plus fetch of left bay; used to calculated total wave height reaching left marsh




end

