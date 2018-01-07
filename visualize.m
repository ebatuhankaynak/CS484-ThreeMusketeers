function visualize(slicImg, firstSpSetBeforeMerge, secondSpSetBeforeMerge, ...
    labels)
tempImg = slicImg;
figure;

for ch = 1 : size(tempImg, 3)
    page = slicImg(:, :, ch);
    for h = 1 : size(firstSpSetBeforeMerge, 2)
        page(labels == firstSpSetBeforeMerge(h)) = 255;
    end
    tempImg(:, :, ch) = page;
end
% imshow(tempImg);
for ch = 1 : size(tempImg, 3)
    page = tempImg(:, :, ch);
    for h = 1 : size(secondSpSetBeforeMerge, 2)
        page(labels == secondSpSetBeforeMerge(h)) = 0;
    end
    tempImg(:, :, ch) = page;
end
% for h = 1 : size(firstSpSetBeforeMerge, 1)
%     for ch = 1 : size(tempImg, 3)
%         page = slicImg(:, :, ch);
%         page(labels == firstSpSetBeforeMerge(h)) = 255;
%         tempImg(:, :, ch) = page;
%     end
% end
% for h = 1 : size(secondSpSetBeforeMerge, 1)
%     for ch = 1 : size(tempImg, 3)
%         page = tempImg(:, :, ch);
%         page(labels == secondSpSetBeforeMerge(h)) = 0;
%         tempImg(:, :, ch) = page;
%     end
% end
imshow(tempImg);
end