function finiteValues = openFile()

    % Open the file navigation system to look for Excel file
    [filename,path] = uigetfile({'*.xls;*.xlsx;*.xlsm;*.xltx;*.xltm',...
                        'Excel Files (*.xls,*.xlsx,*.xlsm,*.xltx,*.xltm)'},'File Selector');
    
    % Combine the filename and path into one string
    file = strcat(path,filename);
    
    % Extract the data from the file
    [num,header,data] = xlsread(file);
    
    % Set which header you want to find
    textToLookFor = input('What is the header of the data to be analyzed?\n','s');
    
    % Search for the header
    [row,col] = find(strcmp(data,textToLookFor));
    
    % Extract the column from the data
    columnOfValues = cell2mat(data(row+1:end,col));
    
    % Remove entries that are NaN
    finiteValues = columnOfValues(isfinite(columnOfValues));

end
