function filtered = Moving_average_filter(data,n_point)
    filtered = filter(1/n_point *ones(1,n_point),1,data);
end