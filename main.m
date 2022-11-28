clc;

locationHL = '.\NguyenAmHuanLuyen-16k\';
personHL = dir(locationHL);
personHL = {personHL.name};
personHL = personHL(3:length(personHL));

locationKT = '.\NguyenAmKiemThu-16k\';
personKT = dir(locationKT);
personKT = {personKT.name};
personKT = personKT(3:length(personKT));
voice = ["\a.wav" "\e.wav" "\i.wav" "\o.wav" "\u.wav"];

frame_time = 0.025;
overlap_time = 0.015;

%3-u 8-i 10-u,i false if fr_t = 0.025 
%10-a 5-e false if fr_t = 0.02

[MEAN_, VAR_] = Get_Mean_Var(locationHL, personHL, voice,frame_time);
NFFT = [512 1024 2048];
[X_FFT_512,X_FFT_1024,X_FFT_2048] = Get_feature_vectors(locationHL, personHL, voice,frame_time, overlap_time,MEAN_,VAR_);

%Ma tran so khop cho cac truong hop NFFT voi file kiem thu
match_512 = zeros(5,5);
match_1024 = zeros(5,5);
match_2048 = zeros(5,5);
check_match = [];
for j = 1:length(NFFT)
    for v = 1:length(voice)
        for i = 1:length(personKT)
            %Doc file
            file = strcat(locationKT,personKT{i}, voice(v));
            file = convertStringsToChars(file);
            [data,f_s] = audioread(file);
            
            %loc bot nhieu moi truong
            data = Moving_average_filter(data,5);
            
            %chuan hoa tin hieu de giam bot dac tinh nguoi noi ???
                %chuan hoa dang chia cho max(data)
            data = Normalize_divide_max(data);
                %chuan hoa bang z_score
            %data = Standardize_z_score(data);

            % tim vi tri nguyen am theo thoi gian
            [mark] = Speech_silent_discrimination(data,f_s,frame_time,MEAN_,VAR_);
            
            %Chia lai tin hieu thanh cac khung co chong len nhau (overlap)
            frames = Framing_overlap(data,f_s,frame_time,overlap_time);
                %tinh buoc cua frame co overlap
            frame_step = frame_time*f_s-overlap_time*f_s;
            
            %without overlap test
%             frames = Framing(data,f_s,frame_time);
%             frame_step = frame_time*f_s;
            
            %tim vung on dinh
            [stable_frames,start,space] = Get_stable_section(frames, f_s,frame_step,3,1,mark);
            
            %tinh FFT cho moi frame trong vung on dinh
            X_FFT = [];
            
            for k = 1:length(stable_frames(:,1))
                X_FFT = [X_FFT; transpose(Get_FFT(transpose(stable_frames(k,:)), NFFT(j)))];
            end
            %tinh ma tran so khop 
            if(j==1)
                index = Get_min_distance_position(X_FFT_512,mean(X_FFT));
                match_512(v,index) = match_512(v,index) + 1;
            elseif (j==2)
                index = Get_min_distance_position(X_FFT_1024,mean(X_FFT));
                match_1024(v,index) = match_1024(v,index) + 1;
            elseif (j==3)
                index = Get_min_distance_position(X_FFT_2048,mean(X_FFT));
                match_2048(v,index) = match_2048(v,index) + 1;
            end
        end
    end
end

figure;
title('Feature vector of 5 vowels with NFFT - 512');
xlabel('Frequency (hz)');
ylabel('FFT Magnitude');
hold on;
freq_512 = 0:f_s/512:f_s/2-1/f_s;
for i = 1:5
    temp = X_FFT_512(i,:);
    plot(freq_512,temp(1:256));
end
legend('a','e','i','o','u');

figure;
title('Feature vector of 5 vowels with NFFT - 1024');
xlabel('Frequency (hz)');
ylabel('FFT Magnitude');
hold on;
freq_1024 = 0:f_s/1024:f_s/2-1/f_s;
for i = 1:5
    temp = X_FFT_1024(i,:);
    plot(freq_1024,temp(1:512));
end
legend('a','e','i','o','u');

figure;
title('Feature vector of 5 vowels with NFFT - 2048');
xlabel('Frequency (hz)');
ylabel('FFT Magnitude');
hold on;
freq_2048 = 0:f_s/2048:f_s/2-1/f_s;
for i = 1:5
    temp = X_FFT_2048(i,:);
    plot(freq_2048,temp(1:1024));
end
legend('a','e','i','o','u');

figure;
title('Feature vector of 5 vowels with NFFT - 512');
xlabel('Frequency (hz)');
ylabel('log10(FFT Magnitude)');
hold on;
freq_512 = 0:f_s/512:f_s/2-1/f_s;
for i = 1:5
    temp = X_FFT_512(i,:);
    plot(freq_512,log10(temp(1:256)));
end
legend('a','e','i','o','u');

figure;
title('Feature vector of 5 vowels with NFFT - 1024');
xlabel('Frequency (hz)');
ylabel('log10(FFT Magnitude)');
hold on;
freq_1024 = 0:f_s/1024:f_s/2-1/f_s;
for i = 1:5
    temp = X_FFT_1024(i,:);
    plot(freq_1024,log10(temp(1:512)));
end
legend('a','e','i','o','u');

figure;
title('Feature vector of 5 vowels with NFFT - 2048');
xlabel('Frequency (hz)');
ylabel('log10(FFT Magnitude)');
hold on;
freq_2048 = 0:f_s/2048:f_s/2-1/f_s;
for i = 1:5
    temp = X_FFT_2048(i,:);
    plot(freq_2048,log10(temp(1:1024)));
end
legend('a','e','i','o','u');
correct = [trace(match_512) trace(match_1024) trace(match_2048)];
disp(correct);
correct_rate = correct/105;
disp(correct_rate);
disp(1-correct_rate);
[max_r, index] = max(correct);
if(index==1) 
    disp(512);
    disp(match_512);
elseif (index==2) 
    disp(1024);
    disp(match_1024);
else
    disp(2048);
    disp(match_2048);
end
%main_for_basic_MFCC();
%main_for_MFCC_kmean();

