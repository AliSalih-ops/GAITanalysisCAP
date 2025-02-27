function LoadDataButton
    % Create a figure with a button
    fig = figure('Name', 'Data Loader', 'Position', [300, 300, 300, 150]);
    btn = uicontrol('Style', 'pushbutton', 'String', 'Load Data', ...
        'Position', [100, 60, 100, 30], ...
        'Callback', @loadData);
end

function loadData(src, event)
    % This function is called when the button is clicked
    [fileName, filePath] = uigetfile({'*.mat;*.csv;*.xlsx', 'Data Files (*.mat, *.csv, *.xlsx)'; ...
                                     '*.*', 'All Files (*.*)'}, ...
                                     'Select a file to load');
                               
    % Check if the user selected a file
    if isequal(fileName, 0)
        disp('User canceled file selection');
        return;
    end
    
    % Get the full file path
    fullPath = fullfile(filePath, fileName);
    
    % Get the file extension to determine how to load it
    [~, ~, ext] = fileparts(fullPath);
    
    % Load the data based on file type
    try
        switch lower(ext)
            case '.mat'
                % Load MAT file
                loadedData = load(fullPath);
                disp('MAT file loaded successfully');
                
            case '.csv'
                % Load CSV file
                loadedData = readtable(fullPath);
                disp('CSV file loaded successfully');
                
            case {'.xlsx', '.xls'}
                % Load Excel file
                loadedData = readtable(fullPath);
                disp('Excel file loaded successfully');
                
            otherwise
                % Handle other file types or provide a message
                disp(['Unsupported file type: ' ext]);
                return;
        end
        
        % Assign the loaded data to the base workspace
        assignin('base', 'loadedData', loadedData);
        disp(['Data from ' fileName ' has been loaded into variable "loadedData"']);
        
    catch ME
        % Display any errors that occurred
        errordlg(['Error loading file: ' ME.message], 'Load Error');
    end
end