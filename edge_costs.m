function [edgeCostMatrix, commonBorderMatrix] = edge_costs(img, labels) 
    n = size(unique(labels),1);
    edgeCostMatrix = zeros(n);
    commonBorderMatrix = zeros(n);
    img_gray = rgb2gray(img);
    edges = edge(img_gray, 'canny');

    for i=1:n
        current_sp = labels == i;
        se = ones(3);
        neighbours = imdilate(current_sp, se) & ~current_sp;
        neighbourLabels = unique(labels(neighbours));
        
        first_sp_border = edge(current_sp,'canny');
        for j=1:size(neighbourLabels)
            k = neighbourLabels(j);
            if edgeCostMatrix(i,k) == 0
                second_sp = labels == k;

                % First, calculate the common border            
                second_sp_border = edge(second_sp,'canny');
                %total = first_sp_border | second_sp_border;
                total = current_sp | second_sp;
                outer = edge(total,'canny');
                %second_outer_border = total - first_sp_border;
                common_border = (first_sp_border | second_sp_border) - outer;
                %figure; imshow(total);

                %figure; imshow(common_border);
                commonBorderMatrix(i,k) = sum(sum(common_border));
                commonBorderMatrix(k,i) = commonBorderMatrix(i,k);

                % Second, calculate edge costs
                % No common border, no edge cost
                if commonBorderMatrix(i,k) == 0
                    edgeCostMatrix(i,k) = 0;
                    edgeCostMatrix(k,i) = 0;
                else
                    sum_edge_cost = sum(sum(edges & common_border));
                    % Normalizing edge cost
                    edgeCostMatrix(i,k) = sum_edge_cost/commonBorderMatrix(i,k);
                    edgeCostMatrix(k,i) = edgeCostMatrix(i,k) ;
                end
            end
        end
    end
end