function export_fig(h, file)
% EXPORT_FIG - Saves a figure as png, fig, and eps
% 
% Syntax:
% export_fig(h, file)
%
% Inputs:
%   h : matlab.ui.Figure
%       Figure handle
%   file : string
%       Full path of the filename
%

saveas(h, file, 'png');
saveas(h, file, 'fig');
saveas(h, file, 'eps');
end