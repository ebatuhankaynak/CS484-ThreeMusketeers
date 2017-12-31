function adjacenyMatrix =neighborhoodGraph(labels)
    % Returns a  matrix where  M(i,j) is the shortest path from node i to j. (I hope) 
    % To solve issue of 0 indexing added 1 to all labels. So that labels start from 1
    % The algorithm should work but can not verify since can not see the graph

    uLabels = unique(labels);
    numberOfVerticies = size(uLabels,1);
    adjacenyMatrix = zeros(numberOfVerticies) + Inf;
    adjacenyMatrix(logical(eye(size(adjacenyMatrix )))) = 0;
    
    for i = 1 :numberOfVerticies
        curLabel = uLabels(i);
        superPixel = labels == curLabel;
        se = ones(3);
        neighbours = imdilate(superPixel, se) & ~superPixel;
        neighbourLabels = unique(labels(neighbours));
        adjacenyMatrix(curLabel,neighbourLabels ) = 1;
    end
    
    % Should vectorize this loop
    for k = 1:numberOfVerticies
        for i = 1 : numberOfVerticies
            for j = 1: numberOfVerticies
                if adjacenyMatrix(i,j) > adjacenyMatrix(i,k) + adjacenyMatrix(k,j)
                    adjacenyMatrix(i,j) = adjacenyMatrix(i,k) + adjacenyMatrix(k,j);
                end
            end
        end
    end
end