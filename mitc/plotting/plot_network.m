function plot_network(A, dataCell, savefolder, savename)
%PLOT_NETWORK plots and exports the network
%
% Syntax: plot_network(A, dataCell)
%
% Inputs: 
%   A : double
%       two-column matrix that shows which activity depends on which activity (link matrix)     
%   dataCell : cell
%        cell of imported project data file
%   savefolder : string
%       folder name
%   savename : string
%       name of the figure


%--- Compute weights for every edge: weight of an edge is equal to the duration
%of the precedent node/activity
for k=1:length(A)
    w(k)=dataCell(A(k,1),3);
end
w=cell2mat(w);

G = digraph(A(:,1),A(:,2),w);

%--- Create the graph
h = figure;
hold on
plot(G,'Layout','layered','Direction','right','AssignLayers','asap','EdgeLabel',G.Edges.Weight);
hold off

%--- Export figures
file = [savefolder savename];
export_fig(h, file)
end