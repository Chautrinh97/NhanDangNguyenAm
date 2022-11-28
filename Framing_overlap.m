function frames = Framing_overlap(data,fs,frame_time,overlap_time)
    n_per_frame = frame_time*fs;
    %so khung trung lap
    n_over_lap = overlap_time*fs;
    %so khung khong trung lap
    frame_step = n_per_frame - n_over_lap;
    
    frames=[];
    i = 1;
    while i+n_per_frame-1<=length(data)
        frames = [frames; transpose(data(i:i+n_per_frame-1))];
        i = i+ frame_step;
    end
end