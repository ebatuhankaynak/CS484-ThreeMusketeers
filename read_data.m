function positionList = read_data(txtName)
fileID = fopen(txtName,'r');
formatSpec = '%d';
sizePositionList = [4 Inf]; % change this
positionList = fscanf(fileID, formatSpec, sizePositionList);
positionList = positionList';
positionList(end,:) = [];
end