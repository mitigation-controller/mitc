function pd1 = cost_cdfdist(c1,c2)

% Force all inputs to be column vectors
c1 = c1(:);
c2 = c2(:);

% Prepare figure
clf;
hold on;
LegHandles = []; LegText = {};


% --- Plot data originally in dataset "c1 data"
% This dataset does not appear on the plot

% Get data limits to determine plotting range
XLim = [0.8*min(c1),1.2*max(c1)];

% Create grid where function will be computed
XLim = XLim + [0 1] * 0.01 * diff(XLim);
XGrid = linspace(XLim(1),XLim(2),100);


% --- Create fit "fit 1"
pd1 = fitdist(c1,'kernel','kernel','normal','support','unbounded');
YPlot1 = cdf(pd1,XGrid);
hLine = plot(XGrid,YPlot1,'Color',[0 0 0],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
LegHandles(end+1) = hLine;
LegText{end+1} = 'Tentative cost CDF';

hold on


a=find(YPlot1>0.999);
if length(a)>0
    a=a(1);
    text(XGrid(a),0.96,1,strcat('cost=',num2str(round(XGrid(a)))),'Color','red','FontSize',14);

    plot(XGrid(a),1,'o','MarkerSize',10,'LineWidth',2);
end

hold on

% --- Plot data originally in dataset "c2 data"
% This dataset does not appear on the plot

% Get data limits to determine plotting range
XLim = [0.8*min(c2), 1.2*max(c2)];

% Create grid where function will be computed
XLim = XLim + [0 1] * 0.01 * diff(XLim);
XGrid = linspace(XLim(1),XLim(2),100);

xlabel('cost (Euros)','FontSize',20)
ylabel('Cumulative probability','FontSize',20)
bx = gca;
bx.FontSize = 20; 

% --- Create fit "fit 2"
pd2 = fitdist(c2,'kernel','kernel','normal','support','unbounded');
YPlot2 = cdf(pd2,XGrid);
hLine = plot(XGrid,YPlot2,'Color',[0.7 0.7 0.7],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
LegHandles(end+1) = hLine;
LegText{end+1} = 'Permanent cost CDF';
% Adjust figure
box on;
grid on;
hold off;

% Create legend from accumulated handles and labels
hLegend = legend(LegHandles,LegText,'Orientation', 'vertical', 'FontSize', 18, 'Location', 'northwest');
set(hLegend,'Interpreter','none');
