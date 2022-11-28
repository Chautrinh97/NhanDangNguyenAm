function [ste] = STECalc(frames)
    n_frame = size(frames,1);
    ste = zeros(1,n_frame);
    for i = 1:n_frame
        ste(i) = sum(frames(i,:).^2);
    end
end