function actualSetLabels = calc_set_labels(superpixelSets, labels)
nLabels = size(superpixelSets, 1);
[height, width, ~] = size(labels);
actualSetLabels = zeros(height, width);
labelCount = 1;

firstColOfSets = superpixelSets(:, 1);
for i = 1 : nLabels
    if (firstColOfSets(i) ~= 0)
        row = superpixelSets(i, :);
        row = row(row ~= 0);
        for j = 1 : length(row)
            setLabeledSuperPixel = (labels == row(j)) .* labelCount; 
            actualSetLabels = actualSetLabels + setLabeledSuperPixel;
        end
        labelCount = labelCount + 1;
    end
end
end