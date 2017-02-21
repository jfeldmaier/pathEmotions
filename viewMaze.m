function [ h ] = viewMaze( maze, varargin )




[N, M] = size(maze);

h = figure;

% Create axes

[mx my] = find(maze);
plot(mx-0.5,my-0.5,'s','MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[.5 .5 .5],'MarkerSize',20);

set(gca,'YTick',0:M,'YGrid','on',...
    'XTick',0:N,...
    'XGrid','on',...
    'XTickLabel',[],...
    'YTickLabel',[],...
    'PlotBoxAspectRatio',[N M 1],...
    'GridLineStyle','-',...
    'DataAspectRatio',[1 1 1]);


% Uncomment the following line to preserve the X-limits of the axes
xlim(gca,[0 N]);
% Uncomment the following line to preserve the Y-limits of the axes
ylim(gca,[0 M]);
box(gca,'on');

hold on
if length(varargin) == 2
    start = varargin{1};
    goal = varargin{2};
    
    text(start(1)+0.3,start(2)+0.5,'S','FontName','Courier New');
    text(goal(1)+0.3,goal(2)+0.5,'G','FontName','Courier New');
end

drawnow

hold off



end

