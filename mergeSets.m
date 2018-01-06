function [lastMergedSpset, allDtotals, superpixelSets] = mergeSets(...
    allDtotals, superpixelSets, nLabels)
invalid = NaN;    

[min_row, col_indices] = min(allDtotals);
[~, row_index] = min(min_row);
temp = [superpixelSets(row_index,:) superpixelSets(col_indices(row_index), :)];
temp = temp(temp ~=0);
zeroMat = zeros(1,nLabels - length(temp));
superpixelSets(row_index,:) = [temp zeroMat];
superpixelSets(col_indices(row_index), :) = zeros(1, nLabels);

allDtotals(col_indices(row_index), :) = invalid;
allDtotals(:, col_indices(row_index)) = invalid;
lastMergedSpset = row_index;
end