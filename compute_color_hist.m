function colorHist = compute_color_hist(indexed)
COLOR_BIN_COUNT = 20;
colorHist = [];
%Obtain histogram of color channels and normalize them
for i = 1 : 3
    channel = indexed{i};
    H = hist(double(channel(:)), COLOR_BIN_COUNT);
    H = H / sum(H);
    colorHist = horzcat(colorHist, H);
end
end