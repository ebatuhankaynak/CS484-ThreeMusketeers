fileID = fopen('000012.txt','r');
formatSpec = '%d';
sizeA = [4 Inf]; % change this
A = fscanf(fileID, formatSpec, sizeA);
A = A';
A(end,:) = [];
A