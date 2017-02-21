start       = [0 3];
goal        = [8 5];
[maze N M]  = CreateMaze();

x = start(1);
y = start(2);

% bounds for x
xmax = N-1;
xmin = 0;
% bounds for y
ymax = M-1;
ymin = 0;

load('output_a0105664_24')

figure
subplot(211)
% Create axes
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
text(start(1)+0.3,start(2)+0.5,'S','FontName','Courier New');
text(goal(1)+0.3,goal(2)+0.5,'G','FontName','Courier New');

[mx my] = find(maze);
plot(mx-0.5,my-0.5,'s','MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[.5 .5 .5],'MarkerSize',20);

for j = 1:output.nb_steps
    subplot(211)
    switch output.actions(j)
        case 1
            % action 1
            plot(x+0.5,y+0.75,'^','MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[1 0 0],'MarkerSize',15);
            y = y + 1;
        case 2
            % action 2
            plot(x+0.75,y+0.5,'>','MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[1 0 0],'MarkerSize',15);
            x = x + 1;
        case 3
            % action 3
            plot(x+0.5,y+0.25,'v','MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[1 0 0],'MarkerSize',15);
            y = y - 1;
        case 4
            % action 4
            plot(x+0.25,y+0.5,'<','MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[1 0 0],'MarkerSize',15);
            x = x - 1;
    end
    drawnow
    subplot(212)
    hold on
    switch output.actions(j)
        case 1
            % action 1
            plot(j,0.5,'^','MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[1 0 0],'MarkerSize',15);
        case 2
            % action 2
            plot(j,0.5,'>','MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[1 0 0],'MarkerSize',15);
        case 3
            % action 3
            plot(j,0.5,'v','MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[1 0 0],'MarkerSize',15);
        case 4
            % action 4
            plot(j,0.5,'<','MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[1 0 0],'MarkerSize',15);
    end
    drawnow
    pause(0.4)
    
    if x > xmax
        x = xmax;
    end
    if x < xmin
        x = xmin;
        
    end
    if y > ymax
        y = ymax;
    end
    if y < ymin
        y = ymin;
    end
    if maze(x+1,y+1)==1
        x = xold;
        y = yold;
    end
    xold = x;
    yold = y;
end



hold off