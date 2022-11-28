function [min_index] = Get_min_distance_position(feature_vectors, X_FFT)
    all_distance = [];
    for i = 1:length(feature_vectors(:,1))
        all_distance = [all_distance Euclid_distance(feature_vectors(i,:),X_FFT)];
    end
    [min_dis, min_index] = min(all_distance);
end

