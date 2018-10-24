function a = GreaterOrEqual(x,y,tol) 

% approx -- Tests whether x is greater than or equal to y, with  
% equality tested to a tolerance "tol" If a tolerance is not 
% specified then the square root of epsilon is used as a default 
% This function is useful when testing equality with floats 

% Dr David Stolper dstolper@usgs.gov

% Version of 03-Jun-2003 16:16
% Updated    03-Jun-2003 16:16

if nargin < 3,tol = sqrt(eps); end

a = x > (y - tol);