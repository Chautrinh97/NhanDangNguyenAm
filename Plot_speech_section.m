function Plot_speech_section(data,fs, mark)
    t = (0:length(data)-1)/fs;
    figure;
    title('Speech and silent discrimination');
    xlabel('Time(s)');
    ylabel('Amplitude');
    hold on;
    plot(t,data,'b');
    for i = 1:2
        plot([1 1]*mark(i),ylim, '--r', 'linewidth', 1);
    end
end

