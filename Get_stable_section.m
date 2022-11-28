function [stable_frames,start_frame,space] = Get_stable_section(frames,fs,frame_step,n_parts, n_stable_parts,mark)
    %n_parts: so phan muon chia
    %n_stable_parts: so phan muon lay
    mark = [floor(mark(1)*fs) ceil(mark(2)*fs)];
    mark = round(mark/frame_step);
    %chia n phan -> mot phan co tung nay frame
    one_part = round((mark(2)-mark(1))/n_parts); 
    start_part = floor((n_parts-n_stable_parts)/2)+1;
    start_frame = mark(1)+(start_part-1)*one_part;
    space = n_stable_parts*one_part;
    stable_frames = [];
    for i = 1:space
        stable_frames = [stable_frames; frames(start_frame+i-1,:)];
    end
end