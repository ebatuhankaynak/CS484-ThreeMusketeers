%Read image
img = imread('000019.jpg');

slicImg = imread('000019_SLIC.jpg');
slicImg = rgb2gray(slicImg);

[height, width, ~] = size(img);

%Read precomputed SLIC0 .dat file
labels = read_slic('000019.dat', height, width);
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



n_iters = 280;
DL_matrix = zeros(nLabels, nLabels)  + Inf;
DH_matrix = zeros(nLabels, nLabels)  + Inf;
DS_matrix = zeros(nLabels, nLabels)  + Inf;
allDtotals = zeros(nLabels, nLabels) + Inf;
for i = 1:n_iters
    for m = 1 : nLabels
        for n = 1 : nLabels
            firstColOfSets = superpixelSets(:, 1);
            if (allDtotals(n, m) == Inf)
                if(m ~= n && firstColOfSets(m) ~= 0 && firstColOfSets(n) ~= 0)
%                     if(i == 68 && m == 171 && n == 174)
%                        a = 5; 
%                     end

                    %Calculate basic distances between the sets S[i] and S[j]
                    % Ds d???ndaki ?eyleri loopdan ç?kar?p table a koyup sadece
                    % minimumlar?n? bulabiliriz belki
                    [Dmin, Dmax, Dg, De, Ds, nSetM, nSetN] = ...
                        calc_basic_distances(m, n, superpixelSets, ctDistances, ...
                        graphDistanceMatrix, edgeDistanceMatrix,...
                        commonBorderMatrix, spSizes);
                    
                    b = 1;
                    % Calculate DL and DH for low and high complexity
                    DL = Dmax + De + Dg;
                    DH = Dmin + (b * Dg);
                    
                    ro = calc_ro(nSetM, nSetN, nLabels);
                    nu =2;
                    
%                   Dtotal = (ro * DL) + ((1 - ro) * DH) + (nu * Ds);
                    DL_matrix(m,n) = DL;
                    DH_matrix(m,n) = DH;
                    DS_matrix(m,n) = Ds;
                    
                    DL_matrix(n,m) = DL;
                    DH_matrix(n,m) = DH;
                    DS_matrix(n,m) = Ds;
                    %allDtotals(m, n) = Dtotal;
                end
            else
                %allDtotals(m, n) = allDtotals(n, m);
            end
        end
    end
    
    % Normalize values of D's
    normDL =  DL_matrix - min( DL_matrix(:));
    normDL = normDL ./ max(normDL(:));
    
    normDs =  DS_matrix - min( DS_matrix(:));
    normDs = normDs ./ max(normDs(:));
    
    normDH =  DH_matrix - min( DH_matrix(:));
    normDH = normDH ./ max(normDH(:));
      
    allDtotals = (ro * DL_matrix) + ((1 - ro) * DH_matrix) + (nu * DS_matrix);
    [min_row,col_indices] = min(allDtotals);
    [min_array,row_index] = min(min_row);

    temp = [superpixelSets(row_index,:) superpixelSets(col_indices(row_index), :)];
    temp = temp(temp ~=0);
    zeroMat = zeros(1,nLabels - length(temp));
    superpixelSets(row_index,:) = [temp zeroMat];
    superpixelSets(col_indices(row_index), :) = zeros(1, nLabels);
    
    DL_matrix(col_indices(row_index), :) =  Inf;
    DH_matrix(col_indices(row_index), :) = Inf;
    DS_matrix(col_indices(row_index), :) = Inf;
    DL_matrix(:,col_indices(row_index)) = Inf;
    DH_matrix(:,col_indices(row_index)) =  Inf;
    DS_matrix(:,col_indices(row_index)) =  Inf;
%     allDtotals(col_indices(row_index), :) = Inf;
%     allDtotals(:, col_indices(row_index)) = Inf;

    slicImg = imread('000019_SLIC.jpg');
    slicImg = rgb2gray(slicImg);
        figure; 
    for l = 1 : size(superpixelSets,2)
        if (superpixelSets(row_index,l) ~= 0)
            slicImg(labels == superpixelSets(row_index,l)) = 255;
        end
    end
    slicImg(labels == col_indices(row_index)) = 255;
    imshow(slicImg);
end
actualSetLabels = calc_set_labels(superpixelSets, labels);

figure; imshow(label2rgb(actualSetLabels));