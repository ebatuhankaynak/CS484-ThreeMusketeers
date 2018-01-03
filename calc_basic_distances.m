function [Dmin, Dmax, Dg, De, Ds, nSetM, nSetN] = ...
    calc_basic_distances(m, n, superpixelSets, ctDistances, ...
    graphDistanceMatrix, edgeDistanceMatrix, commonBorderMatrix, spSizes)
%Find dct's between each superpixel in the sets S[m] and S[n]

%Get superpixels from the sets
superPixelsInSetM = superpixelSets(m, :);
superPixelsInSetM = superPixelsInSetM(superPixelsInSetM ~= 0);
superPixelsInSetN = superpixelSets(n, :);
superPixelsInSetN = superPixelsInSetN(superPixelsInSetN ~= 0);

nSetM = length(superPixelsInSetM);
nSetN = length(superPixelsInSetN);

basicDistances = zeros(1, nSetM * nSetN);
graphDistances = zeros(1, nSetM * nSetN);
edgeCosts = zeros(1, nSetM * nSetN);
commonBorders = zeros(1, nSetM * nSetN);

temp = (commonBorderMatrix .* edgeDistanceMatrix);
%Get all pairwise distances
count = 1;
for x = 1 : nSetM
    for y = 1 : nSetN
       i = superPixelsInSetM(x);
       j = superPixelsInSetN(y);
       basicDistances(count) = ctDistances(i, j);
       graphDistances(count) = graphDistanceMatrix(i, j);
       edgeCosts(count) = temp(i, j);
       commonBorders(count) = commonBorderMatrix(i, j);
       count = count + 1;
    end
end

b = 0.4;

%Calculate big D's
Dmin = min(basicDistances);
Dmax = max(basicDistances);

Dg = min(graphDistances);

if (sum(commonBorders) ~= 0)
    De = sum(edgeCosts) / sum(commonBorders);
else
    De = 0;
end

rm = 0;
rn = 0;
for i = 1 : nSetM
%     rm = rm + size(labels(labels == superPixelsInSetM(i)), 1);
    rm = rm + spSizes(superPixelsInSetM(i));
end

for i = 1 : nSetN
%     rn = rn + size(labels(labels == superPixelsInSetN(i)), 1);
    rn = rn + spSizes(superPixelsInSetM(i));
end

Ds = rm + rn;
end