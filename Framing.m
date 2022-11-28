function [frames, n_frame, n_per_frame] = Framing(data, fs, frame_time)
    n_per_frame = frame_time*fs;
    n_frame = floor(length(data)/n_per_frame);
    for i = 1:n_frame
        for j = 1:n_per_frame
            frames(i,j) = data((i-1)*n_per_frame+j);
        end
    end
end