function [precision, recall] = evaluate(detected_windows, reference_windows)

    % Intersection over Union (IoU) measure is used to count correctly 
    % detected objects. If IoU is greater than 0.5, the detection is 
    % considered correct.
    
    n_detected = size(detected_windows, 1);
    n_objects = size(reference_windows, 1);
    n_correctly_detected = 0;
    
    iou_matrix = zeros(n_detected, n_objects);
    for i=1:n_objects
        for j=1:n_detected
            min_ref_x = reference_windows(i,1);
            min_ref_y = reference_windows(i,2);
            max_ref_x = reference_windows(i,3);
            max_ref_y = reference_windows(i,4);
            
            min_det_x = detected_windows(j,1);
            min_det_y = detected_windows(j,2);
            max_det_x = detected_windows(j,3);
            max_det_y = detected_windows(j,4);

            % No intersection
            if max_det_x < min_ref_x || max_ref_x < min_det_x || ...
               max_det_y < min_ref_y || max_ref_y < min_det_y
                intersection = 0;
                union_ = 1;  % not one but for calculation sake
            else
                % Find the points on the x axis. 
                X_s = sort([min_det_x min_ref_x max_det_x max_ref_x]);

                % The intersection in the x_axis
                intersection_in_x = X_s(3) - X_s(2);

                % Find the points on the y axis. 
                Y_s = sort([min_det_y min_ref_y max_det_y max_ref_y]);

                % The intersection in the y_axis
                intersection_in_y = Y_s(3) - Y_s(2);

                intersection = intersection_in_x * intersection_in_y;
                det_area = (max_det_x - min_det_x) * (max_det_y - min_det_y);
                ref_area = (max_ref_x - min_ref_x) * (max_ref_y - min_ref_y);
                union_ = det_area + ref_area - intersection;
            end

            iou_matrix(i,j) = intersection / union_;
            
        end
            bigz = max(iou_matrix, [], 2);
            n_correctly_detected = size(bigz(bigz >= 0.5), 1);
    end
    
    % Calculate precision
    precision = n_correctly_detected / n_detected;
    % Calculate recall
    recall = n_correctly_detected / n_objects;
end