%Read image
img = imread('corgi.jpg');

slicImg = imread('corgi_SLIC.jpg');
slicImg = rgb2gray(slicImg);

[height, width, ~] = size(img);

%Read precomputed SLIC .dat file
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
importintArguman = (commonBorderMatrix .* edgeDistanceMatrix);
spSizes = zeros(1, nLabels);
for i = 1 : nLabels
    spSizes(i) = size(labels(labels == i), 1);
end
invalid = NaN;
%GER ?EY? YAPTIK AMAN EFF?C?ENCYY LAZIM OLDU(YAZAMADIM DA) O ZAMAN SADACE
%B?R �NCEK? ?TERAT?ONDA ELEMAN EKLNEN SUPERSETIN ROW VE COLUMNUNU
%UPDATELER(TEKRAR HESAPLAYARAK), GER?S? AYNI ZATEN NO NEED TO RECALCULATE.
allDtotals = zeros(nLabels, nLabels) + invalid;
lastMergedSpset = 0;
n_iters = 150;
for i = 1:n_iters
    for m = 1 : nLabels
        for n = 1 : nLabels
            firstColOfSets = superpixelSets(:, 1);
            if(m ~= n && firstColOfSets(m) ~= 0 && firstColOfSets(n) ~= 0)
                if(i == 1 || m == lastMergedSpset)
                    [Dmin, Dmax, Dg, De, Ds, nSetM, nSetN] = ...
                        calc_basic_distances(m, n, superpixelSets, ctDistances, ...
                        graphDistanceMatrix, importintArguman,...
                        commonBorderMatrix, spSizes);
                    b = 0.4;
                    % Calculate DL and DH for low and high complexity
                    DL = Dmax + De + Dg;
                    DH = Dmin + (b * Dg);
                    
                    ro = calc_ro(nSetM, nSetN, nLabels);
                    nu = 2;
                    
                    Dtotal = (ro * DL) + ((1 - ro) * DH) + (nu * Ds);
                    allDtotals(m, n) = Dtotal;
                    allDtotals(n, m) = allDtotals(m, n);
                end
            end
        end
    end
    %INF CAN BE CHANGED WITH TWO FOR'S TO SET VALID SP SETS.
    [min_row,col_indices] = min(allDtotals);
    [min_array,row_index] = min(min_row);
    temp = [superpixelSets(row_index,:) superpixelSets(col_indices(row_index), :)];
    temp = temp(temp ~=0);
    zeroMat = zeros(1,nLabels - length(temp));
    superpixelSets(row_index,:) = [temp zeroMat];
    superpixelSets(col_indices(row_index), :) = zeros(1, nLabels);
    
    allDtotals(col_indices(row_index), :) = invalid;
    allDtotals(:, col_indices(row_index)) = invalid;
    
    lastMergedSpset = row_index;
    
    slicImg = imread('corgi_SLIC.jpg');
    slicImg = rgb2gray(slicImg);
    figure;

    for h = 1 : size(superpixelSets,2)
        if (superpixelSets(row_index,h) ~= 0)
            slicImg(labels == superpixelSets(row_index,h)) = 255;
%             disp(num2str(row_index) + "-" + num2str(superpixelSets(row_index,h)))
        end
    end
    imshow(slicImg);
end
actualSetLabels = calc_set_labels(superpixelSets, labels);
figure; imshow(label2rgb(actualSetLabels));