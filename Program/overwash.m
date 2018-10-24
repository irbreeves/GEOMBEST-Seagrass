function [tempgrid,ii] = overwash (tempgrid,j,t)


% Overwash1 -- Spreads a fixed volume of sand over the backbarrier, from
% the edge of the dune out to a distance determined by the accretion rate
% of the overwash. Deposition decays exponentially with distance from the
% dune.

% David Walters

% Version of 26-Jun-2012

global dunelimit;
global celldim;
global TP;

[q_ow] = getoverwashflux(t,j); % Volume of sand to be deposited as overwash
[overwashrate] = getoverwashrate(t,j); % The maximum rate of overwash accretion
ii = dunelimit; % The landward-most extent of the dune
tempvol = q_ow*TP(t);
topcell = 1;

tA = overwashrate*TP(t)/1000; % The maximum height overwash accretes to at the dunelimit
overwashlength = q_ow*TP(t) / tA; % The extent to which the overwash deposits

while tempvol > 0
    topcellhtT = tA * exp(-(ii-dunelimit) * celldim(1,j)/overwashlength); % The height to which the overwash accretes decays exponentially with the distance from the dunelimit
%     if topcellhtT < 0.05*celldim(3,j)
%         tempvol = 0;
%     end

    % Accrete to the exponentially-adjusted topcellhtT
    realratio = sum(tempgrid(ii,:,:),3); % The amount of sediment in each cell of the column at the dunelimit
    topcell = find(realratio == 1); % The first cell filled with sediment at the dune limit
    topcell = topcell(1) - 1; % The first partially filled/empty cell is the topcell at the dune limit

    k = topcell;
    topcellht = topcellhtT;
    
    while topcellht>0
        realratio = sum(tempgrid(ii,k,:),3); % Fraction of sediment in the topcell
        targetf = 1 - realratio; % Fraction of sediment left to be filled in the topcell

        % If the topcell is higher than the height to which the overwash
        % can fill, fill the cell with the target amount of overwash.
        % Otherwise, fill all the way.
        if topcellht > targetf*celldim(3,j)
            tempgrid(ii,k,1) = tempgrid(ii,k,1) + targetf;
            topcellht = topcellht - targetf*celldim(3,j);
        else
            tempgrid(ii,k,1) = tempgrid(ii,k,1) + (topcellht / celldim(3,j));
            topcellht = 0;
        end
        k = k - 1; % Proceed to the next cell
    end
    tempvol = tempvol - topcellhtT * celldim(1,j); % Update the volume used to fill the cell
    ii = ii + 1; % Proceed to the next column
end