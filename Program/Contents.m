% PROGRAM
%
% Files
%   accrete                      - accrete -- accretes a single cell(x) within tempgrid. 
%   backbarrierinfill            - Backbarrierinfill -- calls the functions that evolve the backbarrier bay and marsh
%   bayevolution                 - erodes or accretes the bay bottom depending on the balance between sediment input and waves
%   buildgrid                    - buildgrid -- populates gridstrat (2,x,y,z,s) where 2 is the
%   calc_barriervolume_km        - Function to calculate and print to screen the barrier volume/m from the 
%   calc_barriervolume_m         - Function to calculate and print to screen the barrier volume/m from the 
%   calc_barriervolume_m_initial - Function to calculate and print to screen the barrier volume/m from the 
%   calc_bay width               - 
%   calc_marshwidth              -
%   deposition                   - Accrete using estuary sediment
%   dunebuild                    - Dunebuild -- Infills the backbarrier via dunebuilding
%   erode                        - erode -- erodes a single cell(x) within gridstrat. Erosion depth is limited
%   erodemarsh                   - erodes the left and right boundaries of the marsh based on wave power
%   erosion                      - 
%   findfirstshoreline           - 
%   findshoreline                - 
%   getbaysedflux                - getbaysedflux -- reads runfiles and returns the bay sediment flux
%   getbbwidth                   - getbbwidth -- reads runfiles and returns the backbarrier width
%   geterosioncoeff              - geterosioncoeff -- reads runfiles and returns the erosion coefficient appropriate for the timestep (t). 
%   getexovol                    - getexovol -- reads runfiles and returns the exovol entry 
%   gethighwater                 - gethighwater -- reads runfiles and returns the highwater tide range entry appropriate for the timestep (t). 
%   getoverwashflux              - getoverwashflux -- reads runfiles and returns the backbarrier overwash flux for the timestep (t). 
%   getoverwashrate              - getoverwashrate -- reads runfiles and returns the backbarrier overwash rate for the timestep (t). 
%   getshearcrit                 - reads runfiles and returns the critical shear stress
%   getwindspeed                 - Reads runfiles and returns the input of wind speed 
%   growmarsh                    - Growmarsh -- fills the left and right-most shallow cells in the estuary
%   GreaterOrEqual               - approx -- Tests whether x is greater than or equal to y, with  
%   initcrest                    - initcrest -- 
%   loadrate                     - loadrate -- reads an excel files containing the depth-dependant response rate 
%   loadrunfiles                 - loadrunfiles -- reads data from the run# excel files
%   loadstrat                    - loadstrat -- reads data tract# excel files and populates the strat
%   main                         - [equil surface] = main(filethread) 
%   mainstring                   - For running multiple input files in a row, from the first input file you
%   makeframes                   - makeframes -- Creates matlab figures from GEOMBEST timesteps
%   makeframesnorthcarolina      - makeframes -- Creates matlab figures from GEOMBEST timesteps
%   makeframesnorthcarolina2     - makeframes -- Creates matlab figures from GEOMBEST timesteps
%   makeframeswashington         - makeframes -- Creates matlab figures from GEOMBEST timesteps
%   maxbayerosion                - calculates maximum depth for the bay (where shear = shearcrit)
%   migratevs                    - Plots migration rate for marsh and shoreline together for comparison
%   overwash                     - Overwash -- Infills the backbarrier via overwash and tidal inlet
%   plotblackwhite               - plottract -- plots a raster representation of the tract, superimposed with a surface line  
%   plotblackwhite2              - plotblackwhite -- plots a raster representation of the tract, superimposed with a surface line,for 
%   plotcrosssteps               - plottract -- plots a raster representation of the tract, superimposed with a surface line  
%   plotlmarshedge               - Function to create, plot and output an array of time step and marsh edge
%   plotmarshedge                - Function to create, plot and output an array of time step and marsh edge
%   plotmarshvs                  - Function to compare marsh progradation rates rates from multiple runs
%   plotshore                    - Function to create, plot and output an array of time step and shoreline
%   plotshorevs                  - Function to compare shoreline migration rates from multiple runs
%   plottempgrid                 - plottract -- plots a raster representation of the tempgrid, superimposed with a surface line  
%   plottractcolour              - plottract -- plots a raster representation of the tract, superimposed with a surface line  
%   plottractmov                 - If the movie has already been made, play it
%   poptop                       - poptop -- populates cells within the grid which are intersected by the stratigraphic horizons 
%   saveblock                    - filethread = filethread % outputs filethread to base workspace
%   savedata                     - savedata -- saves shorelines and the global variables required for
%   savepartialrun               - Running this file before closing the workspace after a GEOMBEST run that 
%   savetimestep                 - savetimestep -- saves a file called step_'t' which is the stratigraphic data 
%   setcrest                     - setcrest -- updates equil by shifting the x values by the distance
%   shorefacedisequilibrium      - shorefacedisequilibrium -- calculates the volume that the shoreface is out of equilibrium
%   solvecross                   - solvecross -- searches for the location of the shoreface profile that satisfies all paramater values 
%   stormdeposit                 - Overwash1 -- Spreads a fixed volume of sand over the backbarrier, from
%   stormgen                     - StormGen stochastically generates storm deposits for a given time step
%   stormplot                    - Plots the frequency distribution of different storms
%   Sweepshoreface               - Sweepshoreface -- Scans the shoreface section of tempgrid to find cells
