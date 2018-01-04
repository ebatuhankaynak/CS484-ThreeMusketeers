function oriHist = compute_ori_hist(indexed)
TEXTURE_BIN_COUNT = 10;
%Set gaussian parameters
windowSize = 30;
sigma = 8;

%Create gaussian filter
% f = fspecial('gaussian', [windowSize windowSize], sigma);
% [Gx, Gy] = gradient(f);

floorW = floor(windowSize/2);
[X, Y] = meshgrid(-floorW : floorW, -floorW : floorW); %?U INTERNET
gaussian = (exp(-(X.^2 + Y.^2) / (2 * (sigma^2)))) ...
            / (2 * pi * (2 * (sigma^2)));
        
%?U 3Ü ?NTERNETTEN COPY PASTE
G_norm = gaussian / sum(gaussian(:));
Gx = -X.*G_norm/(sigma^2);
Gy = -Y.*G_norm/(sigma^2);

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