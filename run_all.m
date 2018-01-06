folder = 'C:\Users\ebatu\Desktop\ImageAnalysis\Project\datFiles';
fileFull = fullfile(folder, '*.dat');
files = dir(fileFull);
nfiles = length(files);
images = cell(1, nfiles);
for i = 1:nfiles
    currentfilename = files(i).name;
    fullFileName = fullfile(folder, currentfilename);
    currentimage = imread(fullFileName);
    images{i} = currentimage;
end
