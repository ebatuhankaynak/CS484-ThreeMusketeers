function draw_boundary_boxes(img, detected_windows, reference_windows)
    detected_color = 'r';
    reference_color = 'g';
    hold on; imshow(img);
    
    % Draw detected boxes
    for i = 1:size(detected_windows)
        pts = detected_windows(i,:);
        rectangle('Position',[pts(1), pts(2), pts(3)-pts(1), pts(4)-pts(2)],'EdgeColor',detected_color);
    end
    
    % Draw reference boxess
    for i = 1:size(reference_windows)
        pts = reference_windows(i,:);
        rectangle('Position',[pts(1), pts(2), pts(3)-pts(1), pts(4)-pts(2)],'EdgeColor',reference_color);
    end
    % Might save image also
    hold off;
end