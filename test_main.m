%Read image
img = imread('corgi.jpg');

slicImg = imread('corgi_SLIC.jpg');
slicImg = rgb2gray(slicImg);

[height, width, ~] = size(img);

%Read precomputed SLIC0 .dat file
labels = read_slic('corgi.dat', height, width);
nLabels = size(unique(labels), 1);

%Initialize superpixel sets
superpixelSets = zeros(nLabels, nLabels);
initialColumn = linspace(1, nLabels, nLabels);
superpixelSets(:, 1) = initialColumn';

%Calculate the basic distance (d[ct]) between each superpixel
ctDistances = ct_dists(img, labels);

%Calculate the graph distance (d[g]) between each superpixel
graphDistanceMatrix = neighborhoodGraph(labels);

%Calculate the edge distance (d[e]) between each superpixel
[edgeDistanceMatrix, commonBorderMatrix]  = edge_costs(img, labels);

spSizes = zeros(1, nLabels);
for i = 1 : nLabels
    spSizes(i) = size(labels(labels == i), 1);
end

n_iters = 80;
for i = 1:n_iters
    allDtotals = zeros(nLabels, nLabels) + Inf;
    for m = 1 : nLabels
        for n = 1 : nLabels
            firstColOfSets = superpixelSets(:, 1);
            if (allDtotals(n, m) == Inf)
                if(m ~= n && firstColOfSets(m) ~= 0 && firstColOfSets(n) ~= 0)
                    if(i == 32 && m == 2 && n == 88)
                       a = 5; 
                    end
                    %Calculate basic distances between the sets S[i] and S[j]
                    % Ds d???ndaki ?eyleri loopdan ç?kar?p table a koyup sadece
                    % minimumlar?n? bulabiliriz belki
                    [Dmin, Dmax, Dg, De, Ds, nSetM, nSetN] = ...
                        calc_basic_distances(m, n, superpixelSets, ctDistances, ...
                        graphDistanceMatrix, edgeDistanceMatrix,...
                        commonBorderMatrix, spSizes);
                    
                    b = 0.4;
                    % Calculate DL and DH for low and high complexity
                    DL = Dmax + De + Dg;
                    DH = Dmin + (b * Dg);
                    
                    ro = calc_ro(nSetM, nSetN, nLabels);
                    nu = 2;
                    
                    Dtotal = (ro * DL) + ((1 - ro) * DH) + (nu * Ds);
                    allDtotals(m, n) = Dtotal;
                end
            else
                allDtotals(m, n) = allDtotals(n, m);
            end
        end
    end
    [min_row,col_indices] = min(allDtotals);
    [min_array,row_index] = min(min_row);
    temp = [superpixelSets(row_index,:) superpixelSets(col_indices(row_index), :)];
    temp = temp(temp ~=0);
    zeroMat = zeros(1,nLabels - length(temp));
    superpixelSets(row_index,:) = [temp zeroMat];
    superpixelSets(col_indices(row_index), :) = zeros(1, nLabels);
    
    if(i == 31)
       a = 5; 
    end
    
    allDtotals(col_indices(row_index), :) = Inf;
    allDtotals(:, col_indices(row_index)) = Inf;
    row_index;
    col_indices(row_index);
    
    slicImg = imread('corgi_SLIC.jpg');
    slicImg = rgb2gray(slicImg);
        figure; 
    for l = 1 : size(superpixelSets,2)
        if (superpixelSets(row_index,l) ~= 0)
            slicImg(labels == superpixelSets(row_index,l)) = 255;
        end
    end
%     slicImg(labels == col_indices(row_index)) = 255;
    imshow(slicImg);
    
%     if(i >= 40)
%         figure;
%         slicImg(labels == row_index) = 255;
%         slicImg(labels == col_indices(row_index)) = 255;
%         imshow(slicImg);
%         pause;
%     end
%     
%     slicImg(labels == row_index) = 255;
%     slicImg(labels == col_indices(row_index)) = 255;
    
    
%         figure;
%         slicImg(labels == row_index) = 255;
%         slicImg(labels == col_indices(row_index)) = 255;
%         imshow(slicImg);
    %     pause;
end
actualSetLabels = calc_set_labels(superpixelSets, labels);

figure; imshow(label2rgb(actualSetLabels));