baseFolder = 'C:\Users\ebatu\Desktop\ImageAnalysis\Project\processedData\';
folder = strcat(baseFolder, 'original');
fileFull = fullfile(folder, '*.jpg');
files = dir(fileFull);
nfiles = length(files);
images = cell(1, nfiles);
for i = 1 : nfiles
    currentfilename = files(i).name;
    fullFileName = fullfile(folder, currentfilename);
    currentimage = imread(fullFileName);
    images{i} = currentimage;
end
folder = strcat(baseFolder, 'slic');
fileFull = fullfile(folder, '*.jpg');
files = dir(fileFull);
slicImages = cell(1, nfiles);
for i = 1 : nfiles
    currentfilename = files(i).name;
    fullFileName = fullfile(folder, currentfilename);
    currentSlic = imread(fullFileName);
    slicImages{i} = currentSlic;
end
fclose('all');
folder = strcat(baseFolder, 'dat');
fileFull = fullfile(folder, '*.dat');
files = dir(fileFull);
labels = cell(1, nfiles);
for i = 1 : nfiles
    currentfilename = files(i).name;
    fullFileName = fullfile(folder, currentfilename);
    [height, width, ~] = size(images{i});
    currentLabels = read_slic(fullFileName, height, width);
    labels{i} = currentLabels;
end
folder = strcat(baseFolder, 'txt');
fileFull = fullfile(folder, '*.txt');
files = dir(fileFull);
texts = cell(1, nfiles);
for i = 1 : nfiles
    currentfilename = files(i).name;
    fullFileName = fullfile(folder, currentfilename);
    currentText = read_data(fullFileName);
    texts{i} = currentText;
end
fclose('all');

for i = 1 : size(files, 1)
    setLabels = main(images{i}, slicImages{i}, labels{i});
    evaluate(detected_windows, texts{i})
    evaluate(setLabels);
end