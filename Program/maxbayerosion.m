function[maxdepth, maxshear, shearcrit] = maxbayerosion (t,j,icrest,tempgrid)


%Maxbayerosion
% calculates the shear stress based on wind speed, fetch, and depth
%determines the maximum depth of the bay (depth where shear = shearcrit)
%
%RL - 2/23/15 
%

% global zcentroids;
% global celldim;
% global L;
% global SL;
global fetch;


U = getwindspeed(t,j); 

%variable fetch maximum depth
if isempty(fetch)==1
fetch = 1800;
end

g = 9.81;
density = 1000; %(kg/m^3) ranges from 997 to 1002 from fresh to salt water
depth = linspace(0.1,3,1000);
   shearstress = zeros(1,1000);
   Hwave = zeros(1,1000);
   Twave = zeros(1,1000);
   Ub = zeros(1,1000);
   friction = 0.03;
   shearcrit = getshearcrit(t,j); %(Pa) = (kg/m/s^2)
   for i = 1:1000
       Hwave(i) = (((U^2)*0.2413)*(tanh(0.493*((g*depth(i))/(U^2)).^0.75).*tanh((0.00313*((g*fetch)/(U^2)).^0.57)./tanh(0.493*((g*depth(i))/(U^2)).^0.75))).^0.87)./g;
       Twave(i) = ((7.518*U)*(tanh(0.331*((g*depth(i))/(U^2)).^1.01).*tanh((0.0005215*((g*fetch)/(U^2)).^0.73)./tanh(0.331*((g*depth(i))/(U^2)).^1.01))).^0.37)./g;
       Ub(i) = pi*Hwave(i)./(Twave(i).*sinh((2.*pi.*depth(i))./(Twave(i).*(g*depth(i)).^0.5)));
       shearstress(i) =0.5.*friction.*density.*Ub(i).^2; %(Pa) = (kg/(m*s^2))
   end
   maxshear=max(shearstress);

   while maxshear < shearcrit
       U=U+1;
          for i = 1:1000
       Hwave(i) = (((U^2)*0.2413)*(tanh(0.493*((g*depth(i))/(U^2)).^0.75).*tanh((0.00313*((g*fetch)/(U^2)).^0.57)./tanh(0.493*((g*depth(i))/(U^2)).^0.75))).^0.87)./g;
       Twave(i) = ((7.518*U)*(tanh(0.331*((g*depth(i))/(U^2)).^1.01).*tanh((0.0005215*((g*fetch)/(U^2)).^0.73)./tanh(0.331*((g*depth(i))/(U^2)).^1.01))).^0.37)./g;
       Ub(i) = pi*Hwave(i)./(Twave(i).*sinh((2.*pi.*depth(i))./(Twave(i).*(g*depth(i)).^0.5)));
       shearstress(i) =0.5.*friction.*density.*Ub(i).^2; %(Pa) = (kg/(m*s^2))
          end
   maxshear=max(shearstress);
   end
  
  minerosion= find(diff(sign(shearstress-shearcrit),1)); %find position in vector of shear=shearcrit
  minerosion=depth(minerosion);%max depth of bay
  minerosion=max(minerosion); %if two values (one near zero) pick larger
  maxdepth = minerosion; %max possible erosion is max depth of bay
end
