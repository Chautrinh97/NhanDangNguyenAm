function FFT = Get_FFT(data,NFFT) 
%fft return a NFFT x 1 matrix -> need to transpose it before calculate
%(plot -> no need to transpose)
    frame_w = hamming(length(data)).*data;
    FFT = abs(fft(frame_w,NFFT));
end

