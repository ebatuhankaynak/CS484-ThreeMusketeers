function [Dmin, Dmax, Dg, De] = calc_basic_distances(superpixelSets, ...
    ctDistances, graphDistanceMatrix, edgeDistanceMatrix, commonBorderMatrix)
m = 1; n = 2;
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

end