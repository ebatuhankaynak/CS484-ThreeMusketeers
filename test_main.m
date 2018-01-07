%Read image
img = imread('000215.jpg');

slicImg = imread('000215_SLIC.jpg');

[height, width, ~] = size(img);

%Read precomputed SLIC .dat file
labels = read_slic('000215.dat', height, width);
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

allDtotals = zeros(nLabels, nLabels) + invalid;
DMIN = zeros(nLabels, nLabels) + invalid;

lastMergedSpset = 0;
n_iters = nLabels - 20;
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
                    DMIN(m, n) = Dmin;
                    ro = calc_ro(nSetM, nSetN, nLabels);
                    nu = 16;
                    
                    Dtotal = (ro * DL) + ((1 - ro) * DH) + (nu * Ds);
                    allDtotals(m, n) = Dtotal;
                    allDtotals(n, m) = allDtotals(m, n);
                end
            end
        end
    end
%     [allDtotals, superpixelSets, firstSpSetBeforeMerge, ...
%         secondSpSetBeforeMerge] = mergeSets(allDtotals, superpixelSets,...
%         nLabels);
    [DMIN, superpixelSets, firstSpSetBeforeMerge, ...
        secondSpSetBeforeMerge] = mergeSets(DMIN, superpixelSets,...
        nLabels);
    
    visualize(slicImg, firstSpSetBeforeMerge, secondSpSetBeforeMerge, ...
        labels);
end
actualSetLabels = calc_set_labels(superpixelSets, labels);
figure; imshow(label2rgb(actualSetLabels));