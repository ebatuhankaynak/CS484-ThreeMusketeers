function visualize(slicImg, firstSpSetBeforeMerge, secondSpSetBeforeMerge, ...
    labels)
tempImg = slicImg;
figure;

for h = 1 : size(firstSpSetBeforeMerge, 1)
    for ch = 1 : size(tempImg, 3)
        page = slicImg(:, :, ch);
        page(labels == firstSpSetBeforeMerge(h)) = 255;
        tempImg(:, :, ch) = page;
    end
end
for h = 1 : size(secondSpSetBeforeMerge, 1)
    for ch = 1 : size(tempImg, 3)
        page = tempImg(:, :, ch);
        page(labels == secondSpSetBeforeMerge(h)) = 0;
        tempImg(:, :, ch) = page;
    end
end
imshow(tempImg);
end