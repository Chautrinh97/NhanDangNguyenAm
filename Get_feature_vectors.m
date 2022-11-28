function [X_FFT_512, X_FFT_1024, X_FFT_2048] = Get_feature_vectors(location, person, voice, frame_time, overlap_time,MEAN_,VAR_)
    NFFT = [512 1024 2048];
    X_FFT_512 =[];
    X_FFT_1024 =[];
    X_FFT_2048 =[];
    for j = 1:length(NFFT)
        for v = 1:length(voice)
            X_FFT_one_vowel = [];
            for i = 1:length(person)%length(person)
                %Doc file
                file = strcat(location,person{i}, voice(v));
                file = convertStringsToChars(file);
                [data,f_s] = audioread(file);
                
                %loc bot nhieu
                data = Moving_average_filter(data,5);
                
                %chuan hoa du lieu de giam bot dac tinh nguoi noi ???
                    %chuan hoa dang chia cho max(data)
                data = Normalize_divide_max(data);
                    %chuan hoa bang z_score
                %data = Standardize_z_score(data);
                
                %tim ra vi tri nguyen am theo thoi gian
                mark = Speech_silent_discrimination(data,f_s,frame_time,MEAN_,VAR_);
                
                %Chia lai tin hieu thanh cac khung co chong len nhau (overlap)
                frames = Framing_overlap(data,f_s,frame_time,overlap_time);
                    %tinh buoc cua frame co overlap
                frame_step = frame_time*f_s-overlap_time*f_s;
                
% %                 without overlap test
%                 frames = Framing(data,f_s,frame_time);
%                 frame_step = frame_time*f_s;

                %tim vung on dinh
                stable_frames = Get_stable_section(frames, f_s,frame_step,3,1,mark);
            
                %tinh FFT cho moi frame trong vung on dinh
                X_FFT = [];
                
                for k = 1:length(stable_frames(:,1))
                    X_FFT = [X_FFT ; transpose(Get_FFT(transpose(stable_frames(k,:)), NFFT(j)))];
                end
                X_FFT_one_vowel(i,:) = mean(X_FFT);
            end
            if j==1
                X_FFT_512 = [X_FFT_512 ; mean(X_FFT_one_vowel)];
            elseif j==2
                X_FFT_1024 = [X_FFT_1024 ; mean(X_FFT_one_vowel)];
            elseif j==3
                X_FFT_2048 = [X_FFT_2048 ; mean(X_FFT_one_vowel)];
            end
        end
    end
end

