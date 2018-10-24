function phasemovie(filethread,Array,TS,Title)


%%% Create Interpolated Phase Space Frames

for step = 1:(TS+10)

    frame = Array(:,:,step);
    frame = frame';
    [RSLR_size,RivInput_size] = size(frame);
    
    % Create vector of width differences
    diffs = zeros(1,(RSLR_size*RivInput_size));
    zz = 1;
    for i = 1:RSLR_size
        for j = 1:RivInput_size
            diffs(zz) = frame(i,j);
            zz = zz+1;
        end
    end
    
    % Create corresponding vector of RSLR
    SLR = zeros(1,(RSLR_size*RivInput_size));
    xx = 1;
    for i = 1:RSLR_size
        for j = 1:RivInput_size
            SLR(xx) = j;
            xx = xx+1;
        end
    end
    SLR = SLR + 1;      %# HARD-WIRED!!
    
    % Create corresponding vector of RivInput
    Riv = zeros(1,(RSLR_size*RivInput_size));
    yy = 1;
    for i = 1:RSLR_size
        for j = 1:RivInput_size
            Riv(yy) = i;
            yy = yy+1;
        end
    end
    Riv = Riv*6;        %# HARD-WIRED!!
    
    
    % Create and save interpolated phase space movie frame
    Interpolation(SLR,Riv,diffs,Title)
    time = strcat(['t = ',num2str((step)*10-100),' yr']);
    annotation('textbox',[.2 .05 .2 .2],'String',time,'FitBoxToText','on','HorizontalAlignment','center','VerticalAlignment','middle','FontSize',28,'BackgroundColor',[1 1 1],'EdgeColor',[0 0 0]);
    pmovie(step) = getframe;
    outputfilename = ['../PhaseMovie/phasemovieframe' num2str(step)];
    set(gcf, 'InvertHardCopy', 'off','PaperPositionMode','auto');
    print('-dpng',outputfilename)
    
    
end    
    
% Play movie
movie(pmovie,1,3) % Plays 1 time, 2 fps
save(['../Output' num2str(filethread) '/pmovie.mat'],'pmovie')


end


