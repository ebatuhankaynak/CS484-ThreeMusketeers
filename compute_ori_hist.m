function oriHist = compute_ori_hist(indexed)
TEXTURE_BIN_COUNT = 10;
%Set gaussian parameters
windowSize = 3;
sigma = 2;

%Create gaussian filter
f = fspecial('gaussian', [windowSize windowSize], sigma);
[Gx, Gy] = gradient(f);

%Create angles for different orientations
theta = 0:45:315;

oriHist = [];
for i = 1 : size(theta, 2)
    Gtheta = cos(theta(i)) * Gx + sin(theta(i)) * Gy;
    for ch = 1 : 3
        filteredImg = imfilter(indexed{ch}, Gtheta);
        H = hist(double(filteredImg(:)), TEXTURE_BIN_COUNT);
        H = H / sum(H);
        oriHist = horzcat(oriHist, H);
    end
end
end