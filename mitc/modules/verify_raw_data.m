function warningMessage = verify_raw_data(dataDouble, dataCell)
% VERIFY_RAW_DATA - 
%
% Inputs:
%   dataDouble : matrix of doubles
%   dataCell : matrix of cells
%
% Outputs:
%   warningMessage : cell
%       Messages that report on the data verification
%

% Initialize output
warningMessage = {};


%% --- 1) Verify data types
% Columns that require data of type <double>
columns = {1, 3, 4, 5,...
           7, 9, 10, 11,...
           13, 14, 15, 17,...
           19, 20, 21, 23,...
           24, 26, 27, 28}; 

for i = 1 : length(columns)
    % Get imported column data
    listCell = dataCell(:, columns{i});
    % Get all datatypes in the data column
    dataTypes = cellfun(@(x) class(x), listCell, 'UniformOutput', false);
    % Generate warning messages
    warningMessage = [warningMessage; type_warning(dataTypes, columns{i}, 'char', 'double')];
    
end

% Columns that contain data of type <char> that need to be converted to
% <double>
columns = {6, 16, 22, 29};
for i = 1 : length(columns)
    % Get imported column data
    listCell = dataCell(:, columns{i});
    % Get all datatypes in the data column
    dataTypes = cellfun(@(x) class(x), listCell, 'UniformOutput', false);
    
    % Find all data of type <char>
    isChar = contains(dataTypes, 'char');
    rowsChar = find(isChar == 1);
    dataChar = listCell(isChar);
        
    for j = 1 : length(dataChar)
        isConvertable = str2num(dataChar{j});
        if isempty(isConvertable) || ~isa(isConvertable, 'double')
            row = rowsChar(j);
            col = columns{i};
            warningMessage{end+1, 1} = "Warning: Excel index [" + num2str(row(j)) +...
                           ";" + num2str(col) + "] cannot be converted into a number";             
        end        
    end
end

%% --- 2) Check for missing values



%% --- 1) Verify properties ID lists for
% - containing NaN values within the sequence
% - monotonically increasing sequence, starting from 1

% Columns that contain the IDs
columns = {1, 7, 17, 24};

for i = 1 : length(columns)
    listCell = dataCell(:, columns{i});
    listDouble = dataDouble(:, columns{i});
    
    % Find all data types  
    dataTypes = cellfun(@(x) class(x), listCell, 'UniformOutput', false);          
    
    % Check for missing values not at the end of the list
    if ~issorted(contains(dataTypes, 'missing'))
        warningMessage{end+1,1} = "Warning: Column " + num2str(columns{i}) +...
                                  " contains missing or invalid data";
    end
    
    % Verify monotonity of IDs
    cleanList = remove_nan(listDouble);
    if cleanList(1) ~= 1 || ~issorted(cleanList, 1, 'strictascend')
        warningMessage{end+1,1} = "Warning: IDs in column " + num2str(columns{i}) +...
                                  " are not monotonically ascending";            
    end
end

%% --- 2) Verify properties of min --> optimal --> max values for
% - data type
% - containing NaN values
% - non-descending order

% Columns that contain the values
columns = {[3, 4, 5],...        % Activity duration
            [9, 10, 11],...     % Mitigation duration
            [13, 14, 15],...    % Mitigation costs
            [19, 20, 21],...    % Risk event duration
            [26, 27, 28]};      % Duration of shared activities

for i = 1 : length(columns)
    listDouble = dataDouble(:, columns{i});
%     listCell = dataCell(:, columns{i});
    
    % Find all data types  
%     dataTypes = cellfun(@(x) class(x), listCell, 'UniformOutput', false);
      
    
    % Check that NaN values are only present as a terminal sequence
    [listNan, ~] = find(isnan(listDouble));
    if ~isempty(listNan)
        % Verify that last index is same as length listID and monotonity of
        % NaN values
        if listNan(end) ~= length(listDouble) || ~all(diff(listNan))
            warningMessage{end+1,1} = "Encountered missing values in columns [" +...
                                      num2str(columns{i}) + "].";
        end        
    end
    
    % Verify ascending order of values
    for j = 1 : size(listDouble,1)        
        if ~issorted(listDouble(j,:), 2, 'ascend')
            % Account for index shift due to header removal
            row = j + 3;
            warningMessage{end+1,1} = "Warning: Row " + num2str(row) + " in column series [" ...
                                      + num2str(columns{i}) + "] is descending.";   
        end
    end  
    
end

%% --- 3) Verify cells with multiple inputs for
% - data type
% - missing values

% Columns that can contain cells with multiple values
columns = {6, 16, 22, 29};

for i = 1 : length(columns)
    list = dataCell(:, columns{i});
    
%     % Check that NaN values are only present as a terminal sequence
%     [listNan, ~] = find(isnan(list));
%     if ~isempty(listNan)
%         % Verify that last index is same as length listID and monotonity of
%         % NaN values
%         if listNan(end) ~= length(values) || ~all(diff(listNan))
%             message = strcat('Encountered missing values in columns ', columns{i});
%             warningStatus = true;
%         end        
%     end
    
    
    
    for j = 1 : length(list)
        dataTypes = class(list{j});       
        if ~strcmp(dataTypes, {'double', 'char', 'missing'})
           warningMessage{end+1,1} = strcat('Encountered datatype ', dataTypes, ' in column ',...
                            num2str(columns{i}), '. Allowed types are <double> and <char>.');
        end        
    end   
end


%% --- 4) Verify that mitigation max duration < min duration of affected activity

% durationActivity = dataDouble(:,3);
% durationMitigation = remove_nan(dataDouble(:, 11));
% relActivityMitigation = remove_missing(dataCell(:, 16));
% 
% for i = 1 : length(relActivityMitigation)
%    minActivity = durationActivity(relActivityMitigation{i});
%    maxMitigation = durationMitigation(i);
%    
%    if ~isempty(relActivityMitigation{i})
%        % Check duration
%        if maxMitigation > minActivity 
%           warningMessage{end+1,1} = strcat('Maximum of mitigation ', num2str(i),...
%                     ' is greater than minimum of activity ',...
%                     num2str(relActivityMitigation(i)));             
%        end
%    else
%         warningMessage{end+1,1} = strcat('Encountered missing values in column 16');
%       
%    end    
% end

%% Remove empty messages
warningMessage = warningMessage(~cellfun('isempty', warningMessage));


end

%% --- Helper functions
function arrayOut = remove_nan(arrayIn)
    arrayIn(~any(~isnan(arrayIn), 2),:) = [];
    arrayOut = arrayIn;
end

function cellOut = remove_missing(cellIn)
    mask = cellfun(@(x) strcmp(class(x), 'missing'), cellIn, 'UniformOutput', true);
    cellIn(mask) = [];
    cellOut = cellIn;
end
