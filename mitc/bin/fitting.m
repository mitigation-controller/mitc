function fitting(y_opt,y_all,y_0,y_0_nouncertainty,T_pl)
rng('default'); % for reproducibility

% Force all inputs to be column vectors
y_opt = y_opt(:);
y_all = y_all(:);
y_0 = y_0(:);
y_0_nouncertainty=y_0_nouncertainty(:)+1;

% Prepare figure
clf;
hold on;
LegHandles = []; LegText = {};

%Data boundaries adjustment
[CdfY,CdfX] = ecdf(y_all,'Function','cdf');  % compute empirical function
a=CdfX(1)-2;
b=CdfY(1);
[CdfY,CdfX] = ecdf(y_0,'Function','cdf');  % compute empirical function
c=CdfX(end)+2;
d=CdfY(end);


%%
% --- Plot data originally in dataset "y_0_nouncertainty data"
[CdfY,CdfX] = ecdf(y_0_nouncertainty,'Function','cdf');  % compute empirical function

CdfX=[a;CdfX;c];
CdfY=[b;CdfY;d];

hLine = plot(CdfX,CdfY,'lineWidth',2,'Color' , [0.7 0.7 0.7],'DisplayName','Original Most-Likely duration');

hold on;

%%
% --- Plot data originally in dataset "y_0 data"
[CdfY,CdfX] = ecdf(y_0,'Function','cdf');  % compute empirical function
%hLine = stairs(CdfX,CdfY,'Color',[0 0 0],'LineStyle','-', 'LineWidth',1);
%hold on;

% --- Create fit for "y_0 data"
CdfX(1)=CdfX(1)-1;
CdfX=[a;CdfX;c];
CdfY=[b;CdfY;d];
x=CdfX;
xq2 = linspace(CdfX(1),CdfX(end),200);
p1 = pchip(x,CdfY,xq2);
plot(xq2,p1,':','lineWidth',2,'Color' , [0.7 0.7 0.7],'DisplayName','Original (No Mit)')
hold on

%%
% --- Plot data originally in dataset "y_all data"
[CdfY,CdfX] = ecdf(y_all,'Function','cdf');  % compute empirical function
%hLine = stairs(CdfX,CdfY,'Color',[0.333333 0.666667 0],'LineStyle','-', 'LineWidth',1);

% --- Create fit for "y_all data"
CdfX(1)=CdfX(1)-1;
CdfX=[a;CdfX;c];
CdfY=[b;CdfY;d];

x=CdfX;
xq2 = linspace(CdfX(1),CdfX(end),200);
p2 = pchip(x,CdfY,xq2);
plot(xq2,p2,'--','lineWidth',2, 'Color' , [0.7 0.7 0.7],'DisplayName','Permanent (All Mit)')
hold on;

%%
% --- Plot data originally in dataset "y_opt data"
[CdfY,CdfX] = ecdf(y_opt,'Function','cdf');  % compute empirical function
%hLine = stairs(CdfX,CdfY,'Color',[0.333333 0 0.666667],'LineStyle','-', 'LineWidth',1);

% --- Create fit for "y_opt data"
CdfX(1)=CdfX(1)-1;
CdfX=[a;CdfX;c];
CdfY=[b;CdfY;d];
x=CdfX;
xq2 = linspace(CdfX(1),CdfX(end),200);
p3 = pchip(x,CdfY,xq2);
plot(xq2,p3,'lineWidth',2,'Color' , 'k','DisplayName','Tentative (MitC)')

hold on;

a=find(x>=T_pl);
if length(a)>0
    a=a(1);
    text(T_pl,CdfY(a)-0.05,1,strcat('Target duration=',num2str(T_pl)),'Color','red','FontSize',14);
    plot(T_pl+1,CdfY(a)+0.006,'o','Color','red','MarkerSize',10,'LineWidth',2,'DisplayName','Target duration');
end
%%
% Create grid where function will be computed
XLim = get(gca,'XLim');
XLim = XLim + [-1 1] * 0.01 * diff(XLim);
XGrid = linspace(XLim(1),XLim(2),800);
xlabel('Duration (days)','FontSize',20)
ylabel('Cumulative probability','FontSize',20)
bx = gca;
bx.FontSize = 20; 

% Adjust figure
box on;
hold off;

% Create legend from accumulated handles and labels
legend('Original Most-Likely duration','Original (No Mit)','Permanent (All Mit)','Tentative (MitC)');
hLegend = legend(LegHandles,LegText,'Orientation', 'vertical', 'FontSize', 18, 'Location', 'northeast');
set(hLegend,'Interpreter','none');


grid on