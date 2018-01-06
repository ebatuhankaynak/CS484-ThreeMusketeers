function oriHist = compute_ori_hist(indexed)
TEXTURE_BIN_COUNT = 10;

%Set gaussian parameters
windowSize = 20;
sigma = 4;

%Create gaussian kernel with a given size and spread
floorW = floor(windowSize/2);
[X, Y] = meshgrid(-floorW : floorW, -floorW : floorW);
gaussian = (exp(-(X.^2 + Y.^2) / (2 * (sigma^2)))) ...
            / (2 * pi * (2 * (sigma^2)));
        
%Normalize the kernel ant create derivatives along x and y directions
normGaussian = gaussian / sum(gaussian(:));
Gx = -X .* normGaussian / (sigma^2);
Gy = -Y .* normGaussian / (sigma^2);

%Create angles for different orientations
theta = 0:45:315;


oriHist = [];
for i = 1 : size(theta, 2)
    %Obtain derivatives in a certain direction
    Gtheta = cos(theta(i)) * Gx + sin(theta(i)) * Gy;
    %For each color channel, calculate orientation histogram
    for ch = 1 : 3
        filteredImg = imfilter(indexed{ch}, Gtheta);
        H = hist(double(filteredImg(:)), TEXTURE_BIN_COUNT);
        H = H / sum(H);
        oriHist = horzcat(oriHist, H);
    end
end
end