function [MEAN, VAR] = Get_Mean_Var(location, person,voice,frame_time)
    ste_silent = [];
    for i = 1:length(person)%length(person)
        for j = length(voice)%length(voice)
            % Doc file
            file = strcat(location,person{i}, voice(j));
            file = convertStringsToChars(file);
            [data,fs] = audioread(file);
            
            %khong loc nhieu
            
            % chuan hoa data
            data = Normalize_divide_max(data);
            
            %dua du lieu vao cac khung
            [frames,n_frame,n_per_frame] = Framing(data,fs,frame_time);
            
            %tinh ste cho cac khung
            ste = STECalc(frames);
            
            %tim cac khung co nang luong thap -> du doan no la silent
            for k = 1:length(ste)
                if ste(k)<=0.01
                    ste_silent = [ste_silent ste(k)];
                end
            end
        end
    end
    MEAN = mean(ste_silent);
    VAR = var(ste_silent);
end