function [warningStatus, message] = verify_raw_data(dataDouble, dataCell)
% VERIFY_RAW_DATA - 
%
% Inputs:
%   dataDouble : matrix of doubles
%   dataCell : matrix of cells
%
% Outputs:
%   warningStatus : boolean
%       Report on status of imported data (true = warning)
%   message : string
%       Message to report on the data verification
%

% Initialize outputs
warningStatus = false;
message = [];

%% --- 1) Verify properties ID lists for
% - data type
% - containing NaN values
% - monotonically increasing sequence starting at 1

% Columns that contain the IDs
columns = {1, 7, 17, 24};

for i = 1 : length(columns)
    listID = dataDouble(:, columns{i});
    
    % Check datatype
    if ~isa(listID, 'double')
        message = strcat('Data in column ', columns{i}, ' is not of type <double>');
        warningStatus = true;
    end
    
    % Check that NaN values are only present as a terminal sequence
    listNan = find(isnan(listID));
    if ~isempty(listNan)
        % Verify that last index is same as length listID and monotonity of
        % NaN values
        if listNan(end) ~= length(listID) || ~all(diff(listNan))
            message = strcat('Encountered missing values in column ', columns{i});
            warningStatus = true;
        end        
    end
    
    % Verify monotonity of IDs
    if listID(1) ~= 1 || ~issorted(listID)
        message = strcat('IDs in column ', columns{i}, ' are not monotonically increasing');
        warningStatus = true;        
    end
end

%% --- 2) Verify properties of min --> optimal --> max values for
% - data type
% - containing NaN values
% - non-descending order

% Columns that contain the values
columns = {[3, 4, 5],...       % Activity duration
            [9, 10, 11],...     % Mitigation duration
            [13, 14, 15],...    % Mitigation costs
            [19, 20, 21],...    % Risk event duration
            [26, 27, 28]};      % Duration of shared activities

for i = 1 : length(columns)
    values = dataDouble(:, columns{i});
    
    % Check datatype
    if ~isa(values, 'double')
        message = strcat('Data in columns ', columns{i}, ' is not of type <double>');
        warningStatus = true;
    end
    
    % Check that NaN values are only present as a terminal sequence
    [listNan, ~] = find(isnan(values));
    if ~isempty(listNan)
        % Verify that last index is same as length listID and monotonity of
        % NaN values
        if listNan(end) ~= length(values) || ~all(diff(listNan))
            message = strcat('Encountered missing values in columns ', columns{i});
            warningStatus = true;
        end        
    end
    
    % Verify ascending order of values
    if ~issorted(values, 2, 'ascend')
        message = strcat('Found values in columns ', columns{i}, ' that are descending');
        warningStatus = true;        
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
        type = class(list{j});       
        if ~stcmp(type, {'double', 'char', 'missing'})
           message = strcat('Encountered datatype ', type, ' in column ',...
                            num2str(columns{i}), '. Allowed types are <double> and <char>.');
           warningStatus = true;
        end        
    end   
end


%% --- 4) Verify that mitigation max duration < min duration of affected activity
% (Column[3] < Column[11] for column[16]==column[1])

durationActivity = dataDouble(:,3);
durationMitigation = remove_nan(dataDouble(:, 11));
relActivityMitigation = remove_missing(dataCell(:, 16));

for i = 1 : length(relActivityMitigation)
   minActivity = durationActivity(relActivityMitigation{i});
   maxMitigation = durationMitigation(i);
   
   if ~isempty(relActivityMitigation{i})
       % Check duration
       if maxMitigation > minActivity 
          message = strcat('Maximum of mitigation ', num2str(i),...
                    ' is greater than minimum of activity ',...
                    num2str(relActivityMitigation(i))); 
          warningStatus = true;             
       end
   else
        message = strcat('Encountered missing values in column 16');
        warningStatus = true;       
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

