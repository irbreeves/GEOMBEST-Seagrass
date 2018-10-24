function playMovie(filethread,timeframe)
%playMovie Plays movie already created in Matlab

tf = timeframe+1;

if exist(['../Output' num2str(filethread) '/pmovie.mat'])
    load(['../Output' num2str(filethread) '/pmovie.mat'])
    figure
    plottractcolour(filethread,tf,1,tf,1,'')
    movie(pmovie,3,3) % Plays 3 times, 2 fps
end

end

