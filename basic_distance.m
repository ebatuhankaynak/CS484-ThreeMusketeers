%Get superpixels as input: Image regions that is indexed by Si and Sj
%Create Hc
%Create Ht
%Find L1 distance

%Read image
img = imread('corgi.jpg');

%Get image bands
red = img(:,:,1);
green = img(:,:,2);
blue = img(:,:,3);

COLOR_BIN_COUNT = 20;
TEXTURE_BIN_COUNT = 10;

%Obtain histogram of color channels and normalize them
redHist = hist(double(red(:)), COLOR_BIN_COUNT);
greenHist = hist(double(green(:)), COLOR_BIN_COUNT);
blueHist = hist(double(blue(:)), COLOR_BIN_COUNT);

redHist = redHist / sum(redHist);
greenHist = greenHist / sum(greenHist);
blueHist = blueHist / sum(blueHist);

% figure; bar(redHist);
% figure; bar(greenHist);
% figure; bar(blueHist);

%Create derivative of gaussian filter
[height, width, ~] = size(img);
minSize = min([height, width]);
% X = 1:1:minSize;

windowSize = 3;
sigma = 2;

% floorW = floor(windowSize/2);
% [X, Y] = meshgrid(-floorW : floorW, -floorW : floorW); %?U INTERNET
% gaussian = (exp(-(X.^2 + Y.^2) / (2 * (sigma^2)))) ...
%             / (2 * pi * (2 * (sigma^2)));
%         
% %?U 3Ü ?NTERNETTEN COPY PASTE
% G_norm = gaussian / sum(gaussian(:));
% Gx = -X.*G_norm/(sigma^2);
% Gy = -Y.*G_norm/(sigma^2);

%THIS IS ACTUALLY EASIER BUT NOT AS ACCURATE FALAN F?LAN
% w=7,sd=3% window,st.dev
% f = fspecial('gaussian', [w w], sd);
% [Gx,Gy] = gradient(f);

f = fspecial('gaussian', [windowSize windowSize], sigma);
[Gx,Gy] = gradient(f);

%Create derivatives in different orientations
theta = 0:45:315;
% filters = cell(1, 8);
% for i = 1 : size(theta, 2)
%     filters{i} = cos(theta(i)) * Gx + sin(theta(i)) * Gy;
% end

oriHist = cell(8, 3);
for i = 1 : size(theta, 2)
    Gtheta = cos(theta(i)) * Gx + sin(theta(i)) * Gy;
%     for ch = 1 : size(img, 3)
    for ch = 1 : 1
        filteredImg = imfilter(img(:,:,ch), Gtheta);
%         fig = figure;
%         hAxes = axes(figure);
%         title( hAxes, "For orientation = " + num2str(theta(i)));
        figure;
        imshow(label2rgb(filteredImg));
        H = hist(double(filteredImg), TEXTURE_BIN_COUNT);
        oriHist{i, ch} = H / sum(H);
%         figure; bar(oriHist{i, ch});
    end
end