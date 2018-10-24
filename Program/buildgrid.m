function buildgrid 

% buildgrid -- populates gridstrat (2,x,y,z,s) where 2 is the
% proportion of each stratigraphic unit within a cell residing in 4-D time space. 
% Note that gridstrat has only two time steps representing the present and the previous 
% timestep. Buildgrid also populates equil, the vector representing the equilibrial 
% horizon of each tract. finally it popultes activecrest, which stores the icentroids 
% of the cells housing the crest of the active sand body, for each tract

% Dr David Stolper dstolper@usgs.gov

% Version of 26-Dec-2002 15:03
% Updated    11-Mar-2003 12:21


global L;
global M;
global N;
global S;
global T;

global gridstrat;
global strat;
global xcentroids;
global zcentroids;
global celldim;
global surface;
global equil;
global activecrest;

for j = 1:M
    for s = 1:S
        if ~isempty(strat(j,s + 1).elevation) % ensures that only existing horizons are operated on 
            minx(s) = min(strat(j,s + 1).elevation(:,1)); % determines the minimum x value for each horizon 
            maxx(s) = max(strat(j,s + 1).elevation(:,1)); % determines the maximum x value for each horizon
            minz(s) = min(strat(j,s + 1).elevation(:,2)); % determines the minimum z value for each horizon
            maxz(s) = max(strat(j,s + 1).elevation(:,2)); % determines the maximum z value for each horizon
        end
    end
end

overallminx = min(minx); % determines the overall minimum x value 
overallmaxx = max(maxx); % determines the overall maximum x value 
tractlength = overallmaxx - overallminx; % determines the vector length of the tract
L = floor(tractlength ./ celldim(1,1)); % determines the number of cells representing the x axis
overallminz = min(minz); % determines the overall minimum z value 
overallmaxz = max(maxz); % determines the overall maximum z value 
tractheight = overallmaxz - overallminz; % determines the vector height of the tract
N = floor(tractheight ./ celldim(3,1)); % determines the number of cells representing the z axis

gridstrat = zeros(2,L,M,N,S); % initialises gridstrat
xcentroids = overallminx + celldim(1,1) ./ 2 : celldim(1,1) : overallminx + (L .* celldim(1,1) - celldim(1,1) ./ 2);
zcentroids = overallmaxz - celldim(3,1) ./ 2 : - celldim(3,1) : overallmaxz - (N .* celldim(3,1) - celldim(3,1) ./ 2);

surface = ones(T + 1,L,M) .* (zcentroids(N) - (celldim(3,1) ./ 2)); % initialises surface

% populate gridstrat  
for j = 1:M 
    for s = 1:S 
        horizon = interp1(strat(j,s + 1).elevation(:,1),strat(j,s + 1).elevation(:,2),xcentroids);
        for i = 1:L 
            flag = 1;
            for k = 1:N 
                if (maxz - (k .* celldim(3,j)) < horizon(i)) & flag ==0 % populate cells below the horizon
                    gridstrat(1,i,j,k,:) = 0;
                    gridstrat(1,i,j,k,s) = 1;                                        
                end                
                if (maxz - (k .* celldim(3,j)) < horizon(i)) & flag ==1 % populate the top cell of the horizon
                    poptop(i,j,k,s,overallmaxz,horizon);
                    flag = 0;                    
                end            
            end
            if horizon(i) >= surface(1,i,j) % the "=" sign is new 
                surface(1,i,j) = horizon(i);
            end
        end        
    end    
end

% populate equil
for j = 1:M
    equil(j,:) = interp1(strat(j,1).elevation(:,1),strat(j,1).elevation(:,2),xcentroids,'linear','extrap');
end   

% finds the cells housing the crest of the active sand body of each tract
for j = 1:M
    activehorizon(j,:) = interp1(strat(j,2).elevation(:,1),strat(j,2).elevation(:,2),xcentroids);
    [a,activecrest(j)] = max(activehorizon(j));
end