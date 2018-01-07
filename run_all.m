baseFolder = 'processedData\';
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

fileID = fopen(strcat(baseFolder, 'results.txt'), 'a');
    fprintf(fileID,'%6s %12s %6s\n', 'ImageNum', 'Precision', 'Recall');
for i = 105 : size(files, 1)
    setLabels = main(images{i}, slicImages{i}, labels{i});
    fig = figure;
    imshow(label2rgb(setLabels));
    saveas(fig, strcat(baseFolder, 'results\',...
        extractBefore(files(i).name, '.txt'), '.png'));
    [precision, recall] = evaluate(detect_objects(setLabels), texts{i});
    fprintf(fileID,'%6.2f %12.8f %6.2f\r\n', [i; precision; recall]);
end
fclose(fileID);