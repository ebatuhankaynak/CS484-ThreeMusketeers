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

m = 1; n = 2;
[Dmin, Dmax, Dg, De] = calc_basic_distances(superpixelSets, ...
    ctDistances, graphDistanceMatrix, edgeDistanceMatrix, commonBorderMatrix);
%Find dct's between each superpixel in the sets S[m] and S[n]


DL = Dmax + De + Dg;
DH = Dmin + (b * Dg);

rm = 0;
rn = 0;
for i = 1 : nSetM
    rm = rm + size(labels(labels == superPixelsInSetM), 1);
end

for i = 1 : nSetN
    rn = rn + size(labels(labels == superPixelsInSetN), 1);
end

Ds = rm + rn;

Tm = nSetM;
Tn = nSetN;
T = nLabels;

alpha = -log2((Tm + Tn) / T);
lambda = 6;
nu = 2;
sigma = 0.1;
k = 1;
ro = 1 / (1 + exp((-(alpha - lambda) / sigma)));

Dtotal = (ro * DL) + ((1 - ro) * DH) + (nu * Ds);

allDtotals = Dtotal;

% %WHAT IS FULL GRAPH DISTANCE??
% %WE ASSUMED GRAPH HAS 1 WEIGHT ON NEIGHUBR?NG SUPERPIXELS IS THIS DO?R?DUR
