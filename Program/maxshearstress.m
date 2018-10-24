clear
close all
U=10;
% depth = 0.4;
fetch = 300;
g = 9.81;

% Hwave = (((U^2)*0.2413)*(tanh(0.493*((g*depth)/(U^2)).^0.75).*tanh((0.00313*((g*fetch)/(U^2)).^0.57)./tanh(0.493*((g*depth)/(U^2)).^0.75))).^0.87)./g; %(m)
%    
% Twave = ((7.518*U)*(tanh(0.331*((g*depth)/(U^2)).^1.01).*tanh((0.0005215*((g*fetch)/(U^2)).^0.73)./tanh(0.331*((g*depth)/(U^2)).^1.01))).^0.37)./g;  %(s)
    

roughness = 0.001; %roughness length scale of sediment bed - 1 mm in M&F 2013
%     friction = 0.4.*(Hwave./(sinh(depth.*(2*pi./(Twave.*(g*depth).^0.5))).*roughness)).^-0.75; %friction factor
    density = 1000; %(kg/m^3) ranges from 997 to 1002 from fresh to salt water
%     shearstress=(9.94519296*10^14).*0.5.*friction.*density.*(pi*Hwave./(Twave.*sinh((2.*pi.*depth)./(Twave.*(g*depth).^0.5)))).^2; %(Pa)(s/yr)^2 = (kg/(m*yr^2))
    
% %calculate erosion
% A = (4.12*10^-4)/31536000; %erosion coeff (s/m)(yr/s) = (yr/m)
% %if shear stress is greater than critical shear stress, erosion occurs
% shearcrit = 0.1*(9.94519296*10^14); %(Pa) = (kg/m/s^2)(s/yr)^2  = (kg/m/yr^2)
% seddensity = 2600; %(kg/m^3)
% 
%    % toperosion = A*(shearstress - shearcrit)*TP(t)/seddensity; %(kg/m^2/yr)(yr)(m^3/kg) = m
%     
%    %if toperosion = 0.1, t = ??
%    
%    toperosion = 0.1;
%    
%    dt = toperosion*seddensity/(A*(shearstress - shearcrit))
 
   
   depth = linspace(0.1,3,100);
   shearstress = zeros(1,100);
   Hwave = zeros(1,100);
   Twave = zeros(1,100);
   %friction = zeros(1,100);
   Ub = zeros(1,100);
   friction = 0.03;
   shearcrit = 0.2; %(Pa) = (kg/m/s^2)
   
  % for fetch = [1:18]*100
   
   %    figure
    %   fetch
       
   for i = 1:100
       Hwave(i) = (((U^2)*0.2413)*(tanh(0.493*((g*depth(i))/(U^2)).^0.75).*tanh((0.00313*((g*fetch)/(U^2)).^0.57)./tanh(0.493*((g*depth(i))/(U^2)).^0.75))).^0.87)./g;
       Twave(i) = ((7.518*U)*(tanh(0.331*((g*depth(i))/(U^2)).^1.01).*tanh((0.0005215*((g*fetch)/(U^2)).^0.73)./tanh(0.331*((g*depth(i))/(U^2)).^1.01))).^0.37)./g;
       %friction(i) = 0.4.*(Hwave(i)./(sinh(depth(i).*(2*pi./(Twave(i).*(g*depth(i)).^0.5))).*roughness)).^-0.75;
       Ub(i) = pi*Hwave(i)./(Twave(i).*sinh((2.*pi.*depth(i))./(Twave(i).*(g*depth(i)).^0.5)));
       shearstress(i) =0.5.*friction.*density.*Ub(i).^2; %(Pa) = (kg/(m*s^2))
       %(9.94519296*10^14).*
   end
   
  
   plot(depth,shearstress)
   xlabel('depth')
   ylabel('shear')
   hold on
   plot(depth,shearcrit)
   hold off
  
   maxshear=max(shearstress)
    
    %calculate erosion
A = (4.12*10^-4); %erosion coeff (s/m)
%if shear stress is greater than critical shear stress, erosion occurs

seddensity = 2600; %(kg/m^3)

    %toperosion = A*(shearstress - shearcrit)*TP(t)/seddensity; %(kg/m^2/yr)(yr)(m^3/kg) = m
    
   %if toperosion = 0.5, t = ??
   
 minerosion= find(diff(sign(shearstress-shearcrit),1)); %find position in vector of shear=shearcrit
  minerosion=depth(minerosion)
   toperosion = minerosion
   toperosion=max(toperosion)
   
   dt = toperosion*seddensity/(A*(maxshear - shearcrit)); %(s)
    dt=dt/31536000
    
   
   %end
    
    
%     figure
%     
%     plot(depth,Ub)
%     xlabel('depth')
%     ylabel('Ub')
%     
%     figure
%     
%     plot(depth,friction)
%     xlabel('depth')
%     ylabel('friction')
   
%     figure
%    
%    Hwave = linspace(0,1,100);
%    for i = 1:100
%       Hwave = (((U^2)*0.2413)*(tanh(0.493*((g*depth)/(U^2)).^0.75).*tanh((0.00313*((g*fetch)/(U^2)).^0.57)./tanh(0.493*((g*depth)/(U^2)).^0.75))).^0.87)./g; %(m)
%    end
%    
%    plot(depth,Hwave)
%    xlabel('depth')
%    ylabel('H')
%    
%    figure
%    
%       Twave = linspace(0,1,100);
%    for i = 1:100
%       Twave = ((7.518*U)*(tanh(0.331*((g*depth)/(U^2)).^1.01).*tanh((0.0005215*((g*fetch)/(U^2)).^0.73)./tanh(0.331*((g*depth)/(U^2)).^1.01))).^0.37)./g;  %(s)
%    end
%    
%    plot(depth,Twave)
%    xlabel('depth')
%    ylabel('T')
%    
%    figure
%    
%    Ub = linspace(0,1,100);
%    for i = 1:100
%        Ub = pi*Hwave./(Twave.*sinh((2.*pi.*depth)./(Twave.*(g*depth).^0.5)))
%    end
%    
%    plot(depth,Ub)
%    xlabel('depth')
%    ylabel('Ub')
%    
%   
%        