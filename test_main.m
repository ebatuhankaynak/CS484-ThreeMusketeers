%Read image
img = imread('corgi.jpg');
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

allDtotals = zeros(nLabels, nLabels);
for m = 1 : nLabels
    for n = 1 : nLabels
        firstColOfSets = superpixelSets(:, 1);
        if (allDtotals(n, m) == 0)
            if(m ~= n && firstColOfSets(m) ~= 0 && firstColOfSets(n) ~= 0)
                %Calculate basic distances between the sets S[i] and S[j]
                [Dmin, Dmax, Dg, De, Ds, nSetM, nSetN] = ...
                    calc_basic_distances(m, n, superpixelSets, ctDistances, ...
                    graphDistanceMatrix, edgeDistanceMatrix,...
                    commonBorderMatrix, spSizes);
                
                b = 0.4;
                
                DL = Dmax + De + Dg;
                DH = Dmin + (b * Dg);

                ro = calc_ro(nSetM, nSetN, nLabels);
                nu = 2;
                
                Dtotal = (ro * DL) + ((1 - ro) * DH) + (nu * Ds);
                allDtotals(m, n) = Dtotal;
            end
        else
%             allDtotals(m, n) = allDtotals(n, m);
        end
    end
end

actualSetLabels = zeros(width, height);
labelCount = 1;
firstColOfSets = superpixelSets(:, 1);
for i = 1 : nLabels
    if (firstColOfSets(i) ~= 0)
        row = superpixelSets(i, :);
        row = row(row ~= 0);
        for j = 1 : length(row)
            actualSetLabels(labels == row(j)) = labelCount;
        end
        labelCount = labelCount + 1;
    end
end

figure; imshow(label2rgb(actualSetLabels));

%Visualization
%Merging

%WHAT IS FULL GRAPH DISTANCE??
%WE ASSUMED GRAPH HAS 1 WEIGHT ON NEIGHUBR?NG SUPERPIXELS IS THIS DO?R?DUR
%HOW TO MERGE HOJAM
%SHOULD WE CONNECT SLIC AND STUFF