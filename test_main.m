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
% edgeDistanceMatrix, commonBorderMatrix  = edge_costs(img, labels);

m = 1; n = 2;
%Find dct's between each superpixel in the sets S[m] and S[n]

%Get superpixels from the sets
superPixelsInSetM = superpixelSets(m, :);
superPixelsInSetM = superPixelsInSetM(superPixelsInSetM ~= 0);
superPixelsInSetN = superpixelSets(n, :);
superPixelsInSetN = superPixelsInSetN(superPixelsInSetN ~= 0);

basicDistances = zeros(1, length(superPixelsInSetM) * length(superPixelsInSetN));
graphDistances = zeros(1, length(superPixelsInSetM) * length(superPixelsInSetN));
edgeCosts = zeros(1, length(superPixelsInSetM) * length(superPixelsInSetN));
commonBorders = zeros(1, length(superPixelsInSetM) * length(superPixelsInSetN));
% temp = (commonBorderMatrix .* edgeDistanceMatrix);
%Get all pairwise distances
count = 1;
for x = 1 : length(superPixelsInSetM)
    for y = 1 : length(superPixelsInSetN)
       i = superPixelsInSetM(x);
       j = superPixelsInSetN(y);
       basicDistances(count) = ctDistances(i, j);
       graphDistances(count) = graphDistanceMatrix(i, j);
%        edgeCosts(count) = temp(i, j);
%        commonBorders(count) = commonBorderMatrix(i, j);
       count = count + 1;
    end
end

b = 0.4;

%Calculate big D's
Dmin = min(basicDistances);
Dmax = max(basicDistances);

Dg = min(graphDistances);

% if (sum(commonBorders) ~= 0)
%     De = sum(edgeCosts) / sum(commonBorders);
% else
%     De = 0;
% end

% DL = Dmax + De + Dg;
DH = Dmin + (b * Dg);

rm = 0;
rn = 0;
for i = 1 : length(superPixelsInSetM)
    rm = rm + size(labels(labels == superPixelsInSetM), 1);
end

for i = 1 : length(superPixelsInSetN)
    rn = rn + size(labels(labels == superPixelsInSetN), 1);
end

Ds = rm + rn;

Tm = length(superPixelsInSetM);
Tn = length(superPixelsInSetN);
T = nLabels;

alpha = -log2((Tm + Tn) / T);
lambda = 6;
nu = 2;
sigma = 0.1;
k = 1;
ro = 1 / (1 + exp((-(alpha - lambda) / sigma)));

Dtotal = (ro * DL) + ((1 - ro) * DH) + (nu * Ds);

%WHAT IS FULL GRAPH DISTANCE??
%WE ASSUMED GRAPH HAS 1 WEIGHT ON NEIGHUBR?NG SUPERPIXELS IS THIS DO?R?DUR
