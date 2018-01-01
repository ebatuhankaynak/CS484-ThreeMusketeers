function ctDistances = ct_dists(img, labels)
%Get image bands
red = img(:,:,1);
green = img(:,:,2);
blue = img(:,:,3);

nLabels = size(unique(labels), 1);
ctDistances = zeros(nLabels, nLabels);

colorHistsOfSuperpixels = cell(1, nLabels);
textureHistsOfSuperpixels = cell(1, nLabels);
%Compute and store feature histograms of superpixels for efficiency
for i = 1 : nLabels
    %Index original image with points that correspond to superpixel regions
    indexed = {red(labels == i), green(labels == i), blue(labels == i)};
    
    %Compute color histograms for superpixel set S[i]
    colorHist = compute_color_hist(indexed);
    colorHistsOfSuperpixels{i} = colorHist;
    
    %Compute texture histograms for superpixel set S[i]
    oriHist = compute_ori_hist(indexed);
    textureHistsOfSuperpixels{i} = oriHist;
end

%Compute the distance of color and texture histograms between superpixel
%sets S[i] and S[j]
for i = 1 : nLabels
    for j = 1 : nLabels
        if (i == j)
            ctDistances(i, j) = 0; %Redundant but put for clarity
        elseif (ctDistances(j, i) ~= 0)
            ctDistances(i, j) = ctDistances(j, i);
        else
            ctDistances(i, j) = basic_distance(i, j, ...
                colorHistsOfSuperpixels, textureHistsOfSuperpixels);
        end
        
    end
end
end