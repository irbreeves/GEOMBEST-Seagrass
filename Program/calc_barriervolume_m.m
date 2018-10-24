function calc_barriervolume_m(filethread,c)

%Function to calculate and print to screen the barrier volume/m from the 
%difference between the initial surface and the finalsurface stored, 
%both of which are stored in shorelines.mat.

%Filethread specifies the output file folder in which the shoreline.mat
%file is located, e.g., output1, output2 and c specifies an x value
%landward of which the program is to search for intersections between the
%initial and final surfaces (intersecta and intersectb, see below).

%Created by L. Moore 5/22/08 using plotsurface as a start


%cross platform file loading of surface.mat, xcentroids.mat and celldim.mat
if(ispc)
   filename = ['../Output' num2str(filethread) '/surface.mat']; 
elseif(isunix)
   filename = ['../Output' num2str(filethread) '/surface.mat']; 
else
    error('Not Unix, Not PC!')
end

load(filename)

if(ispc)
   filename2 = ['../Output' num2str(filethread) '/xcentroids.mat']; 
elseif(isunix)                                                                      
   filename2 = ['../Output' num2str(filethread) '/xcentroids.mat']; 
else
    error('Not Unix, Not PC!')
end                                                                                                                                         

load(filename2)

if(ispc)
   filename3 = ['../Output' num2str(filethread) '/celldim.mat']; 
elseif(isunix)
   filename3 = ['../Output' num2str(filethread) '/celldim.mat']; 
else
    error('Not Unix, Not PC!')
end

load(filename3)
                                                                                                                                                                      
close all

%create variable that contains the dimensions (in meters) of cells in the x
%direction.  

xcelldim = celldim(1,1);     
%xcelldim= xcelldim./1000 % convert cell dimensions to km

%assign variables for surfaces at the first and last timesteps

y1 = surface(1,:); %create variable with values of surface elevations 
    %(at xcentroids) for first time step in meters

yfinal = surface(end,:); %create variable with values of surface elevation 
    %(at xcentroids) for last time step in meters

%convert to km    
%y1 = y1./1000
%yfinal = yfinal./1000
    
%create variable of xcentroids = distance. Divide by 1000 to put into km
x = xcentroids(1,:); 

%x = xcentroids(1,:)./1000; 

%call the function findintersections, which will generate output arguments 
%intersecta and intersectb representing the x values on either side of the barrier 
[intersecta,intersectb]=findintersections(filethread,x,y1,yfinal,c); 


%call the function find_data, which finds the data values in y1 and yfinal 
%corresponding to the x values where y1 and yfinal intersect landward of c. 
data = find_data(filethread,x,y1,yfinal,xcelldim,intersecta,intersectb); 


%multiply the data array by the cell dimensions to calculate the
%contribution of each measurement to barrier volume. 
Area_by_element = (data).* xcelldim; % data is in km and xcelldim is in km


%Sum the elements of data 
Volume_per_m = sum(Area_by_element) 

%save the variable Volume_per_m to the corresponding output folder
save (['../Output' num2str(filethread) '/Volume_per_km.mat'], 'Volume_per_m') 

%%
function [intersecta, intersectb]=findintersections(filethread,x,y1,yfinal,c)

%Generates output arguments intersecta and intersectb representing the x 
%values between which barrier volume is to be calculated.

i = 1;

while (x(i)<= c)
     i = i + 1;
end

%intersecta is the point where final surface becomes higher than the 
%initial surface
while (yfinal(i) < y1(i));
    i=i+1;
end
intersecta = x(i)


%intersect b is the point after which the final surface becomes lower than
%the initial surface
while (yfinal(i) > y1(i));
    i = i+1;
end
intersectb = x(i)
end


%%
function data = find_data(filethread,x,y1,yfinal,xcelldim,intersecta,intersectb)

% Finds the data values in y1 and yfinal that correspond to the x values
% where y1 and yfinal intersect landward of c. 

j=0;
for i=1:length(x) %search for all x values between x=intersecta and x=intersectb 
 if(x(i)> intersecta & x(i)< intersectb) 
     j=j+1;
     data(j)=(yfinal(i)- y1(i)); %calculate difference between the final
                                  %surface and the initial surface for all
                                  %x between intersecta and intersectb.  
                                  %Place the result in the variable data
end
end
data = data;
end