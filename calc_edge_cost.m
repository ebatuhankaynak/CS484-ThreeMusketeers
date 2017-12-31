function edge_cost = calc_edge_cost(label_i,label_j,labels) 
	% SHOULD CHANGE THIS SINCE:
    % Some sketch code in order to get the common boundary, outer boundary etc. 
	first_superpixel = labels ==label_i;
    second_superpixel = labels ==label_j;
    first_superpixel_edge = edge(first_superpixel,'canny');
    second_superpixel_edge = edge(second_superpixel,'canny');
    total = first_superpixel_edge|second_superpixel_edge;
    no_inner = edge(first_superpixel|second_superpixel,'canny');
    inner_boundary = total - no_inner;
    figure;imshow(total);
    figure;imshow(inner_boundary);
    figure;imshow(no_inner);
    edge_cost = sum(sum(inner_boundary));
end