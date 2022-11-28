function distance = Euclid_distance(vector_dt, vector_kt)
    distance = sqrt(sum((vector_dt-vector_kt).^2));
end