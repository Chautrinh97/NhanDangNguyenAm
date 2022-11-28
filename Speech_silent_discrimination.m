function [mark] = Speech_silent_discrimination(data, fs, frame_time,MEAN,VAR)
    %Dua tinh hieu vao cac khung
    [frames, n_frame, n_per_frame] = Framing(data, fs, frame_time);
    
    %chuan hoa tin hieu de ve
    %data = data/max(max(data),abs(min(data)));
    
    %tinh ste cho tat ca cac khung
    ste = STECalc(frames);
    
%     %normalize ste style 1
%     ste = (ste-min(ste))/(max(ste)-min(ste));
    %normalize ste style 2
    ste = Normalize_divide_max(ste);
     
%     %Khi can ve do thi ,noi cac ste cua tung khung -> tin hieu roi rac ste_wave
%     ste_norm = ste./max(abs(ste));
%     ste_wave = 0;
%     for i = 1:n_frame        
%         L = length(ste_wave);
%         ste_wave(L:L+n_per_frame) = ste_norm(i);
%     end
    
    %Threshold: nguong thuc nghiem.
    Threshold = 0.02;
    
    %Them gia tri MEAN va VAR cua silent frames de tang do chinh xac
    %ap dung nguyen tac 3-xich-ma cua phan phoi chuan tac N(0,1)
    isFrameSpeech = find(ste>Threshold & abs(ste-MEAN)>3*sqrt(VAR));
    
%     mark = isFrameSpeech;
%     len = length(mark);
%     mark = [(mark(1)-1)*frame_time mark(2:len)*frame_time];
    
    mark = isFrameSpeech(1);
    mark = [mark isFrameSpeech(length(isFrameSpeech))];  
    mark = [(mark(1)-1)*frame_time mark(2)*frame_time ];

end

