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
% function [redHist, greenHist, blueHist] = ...
%     compute_color_hist(redLabeled, greenLabeled, blueLabeled)
% 
% COLOR_BIN_COUNT = 20;
% 
% %Obtain histogram of color channels and normalize them
% redHist = hist(double(redLabeled(:)), COLOR_BIN_COUNT);
% greenHist = hist(double(greenLabeled(:)), COLOR_BIN_COUNT);
% blueHist = hist(double(blueLabeled(:)), COLOR_BIN_COUNT);
% 
% redHist = redHist / sum(redHist);
% greenHist = greenHist / sum(greenHist);
% blueHist = blueHist / sum(blueHist);
% end

% function hists = compute_color_hist(indexed)
% COLOR_BIN_COUNT = 20;
% hists = cell(1, 3);
% %Obtain histogram of color channels and normalize them
% for i = 1 : 3
%     channel = indexed{i};
%     H = hist(double(channel(:)), COLOR_BIN_COUNT);
%     hists{i} = H / sum(H);
% end
% 
% 
% end