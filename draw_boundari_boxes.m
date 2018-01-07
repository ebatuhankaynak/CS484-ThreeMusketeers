function draw_boundari_boxes(img, detected_windows, reference_windows)
    detected_color = 'r';
    reference_color = 'g';
    figure; imshow(img); hold on;
    
    % Draw detected boxes
    for i = 1:size(detected_windows)
        [x1,y1,x2,y2] = detected_windows(i,:);
        rectangle('Position',[x1, y2, x2-x1, y2-y1],'EdgeColor',detected_color);
    end
    
    % Draw reference boxes
    for i = 1:size(reference_windows)
        [x1,y1,x2,y2] = reference_windows(i,:);
        rectangle('Position',[x1, y2, x2-x1, y2-y1],'EdgeColor',reference_color);
    end
    % Might save image also
    hold off;
end