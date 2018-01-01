function labels = read_slic(file_name, height, width)

% Opens and Reads data output of SLIC0 "filename.dat" file into labels matrix
% We can also read the image here to get height and width but shoud we?
file = fopen(file_name,'r');
data = fread(file, inf, '*int32');
labels = zeros(height,width);
% Creates the labels matrix
for j = 1:height
    for k = 1:width
       ind = (j-1)*width+k;
       labels(j,k) = data(ind); 
    end
end
labels = labels + 1;
end

