function errorRate = errorRate(noteTrack,method,time)
    std = [nan nan nan nan 7 6 7 6 7 2 5 3 0 0 0 0 -5 0 2 2 2 -5 -1 2 3 3 3 -5 7 6 7 6 7 2 5 3 0 0 0 0 -5 0 2 2 2 -5 3 2 0 0 0 0 0 0];
    std = reshape(std,[length(std) 1]);
    LCM = lcm(length(noteTrack),length(std));
    std4Check = repelem(std,LCM/length(std),1);
    noteTrack4Check = repelem(noteTrack,LCM/length(noteTrack),1);
    figure
    t = 0:time/(length(std4Check)-1):time;
    errorRate = 1-length(find(std4Check==noteTrack4Check))/LCM;
    
    plot(t,std4Check,'*',t, noteTrack4Check,'linewidth',1.5)
    legend('Standard',method);
    grid on
    title(['Error Rate: ' num2str(errorRate)])
    xlabel('Time [sec]')
    ylabel('Note')
    set(gca, 'fontsize', 14);
end


