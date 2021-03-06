function detected_windows = detect_objects(labeled_image)
    u_labels = unique(labeled_image);
    n_labels = size(u_labels, 1);
    detected_windows = zeros(n_labels, 4);
    for i=1:n_labels
        cur_obj = labeled_image == u_labels(i);
        [row_size, col_size] = size(cur_obj);
        
        % Left
        detected_windows(i,1) = floor(find(cur_obj, 1)/row_size)+1;
        % Top
        detected_windows(i,2) = floor(find(cur_obj', 1)/col_size)+1;        
        % Right 
        detected_windows(i,3) = floor(find(cur_obj, 1, 'last')/row_size)+1;
        % Bottom 
        detected_windows(i,4) = floor(find(cur_obj', 1, 'last')/col_size)+1;
        
    end    
end