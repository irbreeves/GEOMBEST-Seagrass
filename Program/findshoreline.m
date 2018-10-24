function findshoreline(t,j)

global strat;
global shorelines;

entries = size (strat(j,1).elevation,1);

for e = 2:entries %changed from e = 1:entries because of error saying 
    %subscript indicies must be positive, real or logical.  At line 12, e-1
    %was failing b/c trying to access row 0 when rows start at 1.  Not sure
    %why this wasn't an issue previously. ljm and otb 9/13/2010
    if strat(j,1).elevation(e,2) >= 0
        upperx = strat(j,1).elevation(e,1);
        lowerx = strat(j,1).elevation(e - 1,1);
        upperz = strat(j,1).elevation(e,2);
        lowerz = strat(j,1).elevation(e - 1,2);        
        totalrise = upperz - lowerz;
        totalrun = upperx - lowerx;
        zlow = 0 - lowerz;
        lowratio = zlow ./ totalrise;
        shorelines(t + 1,j) = lowerx + (lowratio .* totalrun);
        break    
    end
end