function mit_plan_GUI

% Add all subfolders to environment
folder = fileparts(which('mit_plan_GUI.m'));
addpath(genpath(folder));


% GUI settings
textFontSize = 10;
textInfo = 'Mitigation planner controller';
textVersion = '0.1.0';
textMessage = ['Version ', textVersion];

% Initialize GUI
hImageMitC.fig = figure('Units','normalized','DockControls','off',...
                        'IntegerHandle','off','Name','Mitigation planner',...
                        'MenuBar','none','NumberTitle','off',...
                        'OuterPosition',[0.35 0.35 0.3 0.4],'handleVisibility','callback',...
                        'Visible','on','NextPlot','add');

hImageMitC.tInfo = uicontrol('Parent',hImageMitC.fig,'Style','text','String',textInfo,...
                             'Units','normalized','Position',[0.05 0.85 0.7 0.1],...
                             'HorizontalAlignment','left','FontSize',textFontSize);
                    
hImageMitC.bLoad = uicontrol('Parent',hImageMitC.fig, 'Style','pushbutton',...
                             'Units','normalized',...
                             'String','Load project data (.xlsx)','Position',...
                             [0.2 0.75 0.6 0.1],'Enable','on','FontSize',textFontSize,...
                             'HandleVisibility','callback','CallBack',@load_data);

                         
                         
hImageMitC.bRun = uicontrol('Parent',hImageMitC.fig, 'Style','pushbutton',...
                             'Units','normalized','String','Run','Position',...
                             [0.2 0.45 0.6 0.1],'Enable','off','FontSize',textFontSize,...
                             'HandleVisibility','callback','CallBack',@run_simulation);                         
                         
hImageMitC.tMessage = uicontrol('Parent',hImageMitC.fig,'Style','text','String',...
                                textMessage,'Units','normalized','Position',...
                                [0.1 0.1 0.8 0.3], 'HorizontalAlignment','left',...
                                'FontSize',textFontSize, 'BackgroundColor','w');
                         
set(hImageMitC.fig,'CloseRequestFcn',@close);

setappdata(0,'hImageMitC',hImageMitC);
end

function close(~,~)
% Close GUI
hImageMitC = getappdata(0, 'hImageMitC');
delete(hImageMitC.fig);

end

function [dataDoube, dataCell] = load_data(~,~)
[filename, pathname] = uigetfile('.xlsx', 'Select your project data');

% Check input 
if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')   
else
    disp(['User selected ', fullfile(pathname, filename)])
end

% Verify existence file
file = [pathname filename];
if isfile(file)
    [dataDouble, dataCell] = import_project(file);    
    disp('Succesfully loaded ', filename);
else
    disp('File can not be found')
end

% Verify dataDouble and dataCell

end