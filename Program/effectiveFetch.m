function effectiveFetch(bay1,bay2,profileLength,avgdepth)


%%% Calculate Wave power 

U = 8; % (m/s)
g = 9.81; % (m/s^2)
gamma = 9810; % Specific weight of water (N/m^3)
kerode = .14; % (m3/W/yr)
decaycoeff = 0.01;
pct = .66;
c = decaycoeff*pct; % Max decay coefficient of 0.01 (Bradley and Houser, 2009), varies roughly +1:1 with shoot density (Manca et al., 2012)

meadowWidth = profileLength - bay1 - bay2;

rFetch = bay1;
lFetch = bay2;

% Calculate height of wave when reaching meadow edge
rHwave = (((U^2)*0.2413)*(tanh(0.493*((g*avgdepth)/(U^2)).^0.75)*tanh((0.00313*((g*rFetch)/(U^2)).^0.57)/tanh(0.493*((g*avgdepth)/(U^2)).^0.75))).^0.87)/g; % Wave height of right bay (m)
lHwave = (((U^2)*0.2413)*(tanh(0.493*((g*avgdepth)/(U^2)).^0.75)*tanh((0.00313*((g*lFetch)/(U^2)).^0.57)/tanh(0.493*((g*avgdepth)/(U^2)).^0.75))).^0.87)/g; % Wave height of left bay (m)

% Waves propogating towards right (island) side of bay
lHattenuated = lHwave*exp(-c*meadowWidth); % Attenuate left bay wave reaching right edge of meadow

rA = nthroot((real((lHattenuated*g)/((U.^2)*0.2413))),0.87);
rB = tanh(0.493*((g*avgdepth)/(U^2)).^0.75);
rC = nthroot(real(((atanh(((rA/rB)))*rB)/0.00313)),0.57);

rFetch_attenuated = ((U.^2)*rC)/g; % Back-solved to find fetch for the given attenuated wave height; used to account for regrowth of wave after leaving meadow before reaching marsh edge, below
Rfetch_effective = rFetch_attenuated + rFetch % Effective fetch: equivalent attenuated fetch plus fetch of right bay; used to calculated total wave height reaching right marsh

% Waves propogating towards left (mainland) side of bay
rHattenuated = rHwave*exp(-c*meadowWidth); % Attenuate right bay wave reaching left edge of meadow

lA = nthroot((real((rHattenuated*g)/((U.^2)*0.2413))),0.87);
lB = tanh(0.493*((g*avgdepth)/(U^2)).^0.75);
lC = nthroot(real(((atanh(((lA/lB)))*lB)/0.00313)),0.57);

lFetch_attenuated = ((U.^2)*lC)/g; % Back-solved to find fetch for the given attenuated wave height; used to account for regrowth of wave after leaving meadow before reaching marsh edge, below
Lfetch_effective = lFetch_attenuated + lFetch % Effective fetch: equivalent attenuated fetch plus fetch of left bay; used to calculated total wave height reaching left marsh

AverageEffectiveFetch = (Rfetch_effective + Lfetch_effective)/2

end

