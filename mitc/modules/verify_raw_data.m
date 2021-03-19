function [status, message] = verify_raw_data(dataDouble, dataCell)
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
message = {};
status = 0;
% Correct row shift due to removal of header
shift = 3;

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
    % Generate warning messages for type error
    message = [message; type_error(listCell, columns{i}, 'char', 'double')];
    
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
            row = rowsChar(j) + shift;
            col = columns{i};
            message{end+1, 1} = "Error: Cell(" + num2str(row(j)) +...
                           ", " + num2str(col) + ") cannot be converted into a number.";             
        end        
    end
end

%% --- 2) Verify properties ID lists for
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
        message{end+1,1} = "Error: Column " + num2str(columns{i}) +...
                                  " contains missing or invalid data.";
    end
    
    % Verify monotonity of IDs
    cleanList = remove_nan(listDouble);
    if cleanList(1) ~= 1 || ~issorted(cleanList, 1, 'strictascend')
        message{end+1,1} = "Error: IDs in column " + num2str(columns{i}) +...
                                  " are not monotonically ascending.";            
    end
end

%% --- 3) Verify properties of min --> optimal --> max values for
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
    
     % Verify ascending order of values
    for j = 1 : size(listDouble,1)
        row = j + shift;
        col = columns{i};
        
        if any(isnan(listDouble(j,:))) && ~all(isnan(listDouble(j,:)))
            message{end+1,1} = "Error: Row " + num2str(row) + " in columns [" ...
                                          + num2str(columns{i}) + "] contains missing or invalid data.";        
        elseif ~issorted(listDouble(j,:), 2, 'ascend')
            message{end+1,1} = "Error: Row " + num2str(row) + " in columns [" ...
                                      + num2str(columns{i}) + "] is descending.";            
        end
    end  
        
    % Check that rows of all NaN values are only present as a terminal sequence
    [row, ~] = find(isnan(listDouble));
    listNan = unique(row);
    if ~isempty(listNan)
        % Verify that last index is same as length listID and monotonity of
        % NaN values
        if listNan(end) ~= length(listDouble) || ~issorted(listNan, 'strictmonotonic')
            message{end+1,1} = "Error: Encountered missing values in columns [" +...
                                      num2str(columns{i}) + "].";
        end        
    end           
end


%% --- 4) Verify that mitigation max duration < min duration of affected activity

durationActivity = remove_nan(dataDouble(:,3));
durationMitigation = remove_nan(dataDouble(:, 11));
isNotMissingIndex = find(~cellfun(@(x) isa(x, 'missing'), dataCell(:, 16)) == 1);
mitigationID = dataDouble(isNotMissingIndex,7);
relActivityMitigation = remove_missing(dataCell(:, 16));

for i = 1 : length(relActivityMitigation)
   minActivity = durationActivity(relActivityMitigation{i});
   maxMitigation = durationMitigation(i);
   
   % Compare min and max durations
   if maxMitigation > minActivity 
      message{end+1,1} = "Error: Maximum duration of Mitigation ID " +...
          num2str(mitigationID(i)) + " is greater than minimum duration of Activity ID " + ...
                num2str(relActivityMitigation{i}) + ".";             
   end

end

%% --- 5) Verify presence of Activity IDs

activityIDs = remove_nan(dataDouble(:,1));

columns = {6, 16, 22, 29};

for i = 1 : length(columns)
    listID = dataCell(:, columns{i});
    
    % Get unique values 
    listDoubles = unique_doubles_from_cell(listID);
    
    % Find missing activity IDs
    isMissing = ~ismember(listDoubles, activityIDs);
    missingActivities = listDoubles(isMissing);
    
    
    % Generate error if acitivities are missing
    if ~isempty(missingActivities)        
        message{end+1,1} = "Error: The requested Activity ID(s) " + num2str(missingActivities) +...
            " in column " + num2str(columns{i}) + " was not found.";
    end        
end


%% Remove empty messages
message = message(~cellfun('isempty', message));

%% Message if all data is OK
if isempty(message)
    message{end+1,1} = "Project data verification completed.";
    status = 1;
end

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
