function loadlookup
% Loads lookup.xls and depth_lookup.xls files and assigns them to global variable lookup and depth_lookup

% 29-Jan-17 Ian Reeves

global lookup;
global depth_lookup;

filename1 = ['C:/GEOMBEST+/Program/seagrass_lookup.xls'];
filename2 = ['C:/GEOMBEST+/Program/depth_lookup.xls'];

lookup = xlsread(filename1);
depth_lookup = xlsread(filename2);

end

