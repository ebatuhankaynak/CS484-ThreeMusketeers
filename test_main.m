%Read image
img = imread('corgi.jpg');
[height, width, ~] = size(img);

%Read precomputed SLIC0 .dat file
labels = read_slic('corgi.dat', height, width);

ctDistances = ct_dists(img, labels);

