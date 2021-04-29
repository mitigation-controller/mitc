function pd1 = cost_pdfdist(c1,c2)

% Force all inputs to be column vectors
c1 = c1(:);
c2 = c2(:);

% Prepare figure
clf;
hold on;
LegHandles = []; LegText = {};

%%
% Get data limits to determine plotting range
XLim = [0.8*min(c1),1.2*max(c1)];

% Create grid where function will be computed
XLim = XLim + [0 1] * 0.01 * diff(XLim);
XGrid = linspace(XLim(1),XLim(2),100);

%%
% --- Plot data originally in dataset "c1 data"
[CdfF,CdfX] = ecdf(c1,'Function','cdf');  % compute empirical cdf
BinInfo.rule = 1;
[~,BinEdge] = internal.stats.histbins(c1,[],[],BinInfo,CdfF,CdfX);
[BinHeight,BinCenter] = ecdfhist(CdfF,CdfX,'edges',BinEdge);
hLine = bar(BinCenter,BinHeight,'hist');
set(hLine,'FaceColor','none','EdgeColor',[0 0 0],...
    'LineStyle','-', 'LineWidth',1);

LegHandles(end+1) = hLine;
LegText{end+1} = 'Tentative (MitC) cost histogram';

hold on

%%
% --- Create fit "pdf1"
pd1 = fitdist(c1,'kernel','kernel','normal','support','unbounded');
YPlot = pdf(pd1,XGrid);
hLine = plot(XGrid,YPlot,'Color',[0 0 0],...
    'LineStyle','-', 'LineWidth',3,...
    'Marker','none', 'MarkerSize',6);
LegHandles(end+1) = hLine;
LegText{end+1} = 'Tentative (MitC) cost PDF';

hold on

%%
% Get data limits to determine plotting range
XLim = [0.8*min(c2), 1.2*max(c2)];

% Create grid where function will be computed
XLim = XLim + [0 1] * 0.01 * diff(XLim);
XGrid = linspace(XLim(1),XLim(2),100);
%%
% --- Plot data originally in dataset "c2 data"
[CdfF,CdfX] = ecdf(c2,'Function','cdf');  % compute empirical cdf
BinInfo.rule = 1;
[~,BinEdge] = internal.stats.histbins(c2,[],[],BinInfo,CdfF,CdfX);
[BinHeight,BinCenter] = ecdfhist(CdfF,CdfX,'edges',BinEdge);
hLine = bar(BinCenter,BinHeight,'hist');
set(hLine,'FaceColor','none','EdgeColor',[0.7 0.7 0.7],...
    'LineStyle','-', 'LineWidth',1);
xlabel('cost: mitigation+penalty-reward (Euros)','FontSize',20)
ylabel('PDF','FontSize',20)
LegHandles(end+1) = hLine;
LegText{end+1} = 'Permanent (All Mit) cost histogram';
bx = gca;
bx.FontSize = 20; 

hold on

%%
% --- Create fit "pdf2"

pd2 = fitdist(c2,'kernel','kernel','normal','support','unbounded');

YPlot = pdf(pd2,XGrid);
hLine = plot(XGrid,YPlot,'Color',[0.7 0.7 0.7],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
LegHandles(end+1) = hLine;
LegText{end+1} = 'Permanent (All Mit) cost PDF';

% Adjust figure
box on;
hold off;

% Create legend from accumulated handles and labels
hLegend = legend(LegHandles,LegText,'Orientation', 'vertical', 'FontSize', 20, 'Location', 'northeast');
set(hLegend,'Interpreter','none');
