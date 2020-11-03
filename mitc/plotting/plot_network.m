function plot_network(A, dataCell)
% plot_network
%
% Inputs: 
%
% Outputs: 


%--- Compute weights for every edge: weight of an edge is equal to the duration
%of the precedent node/activity
for k=1:length(A)
    w(k)=dataCell(A(k,1),3);
end
w=cell2mat(w);

%--- Create the graph
figure
G = digraph(A(:,1),A(:,2),w);
p = plot(G,'Layout','layered','Direction','right','AssignLayers','asap','EdgeLabel',G.Edges.Weight);

end