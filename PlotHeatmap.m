function PlotHeatmap( maze, Q )

[N, M] = size(maze);
subplot(2,2,2);
cla
hold on
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

[mx, my] = find(maze);
plot(mx-0.5,my-0.5,'s','MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[.5 .5 .5],'MarkerSize',20);

Q_tmp = (Q - min(min(Q))) ./ (max(max(Q)) - min(min(Q)));

i = 1;
for spalte = 1:N
    for zeile = 1:M
        if any(Q_tmp(i,:))
            [ tmp ] = GetBestAction( Q, i );
            
%             tmp = find(Q_tmp(i,:) == max(Q_tmp(i,:)));
%             if numel(tmp) > 1
%                 tmp = tmp(randi(numel(tmp)));
%             end            
            
            switch tmp
                case 1
                    plot(spalte-0.5,zeile-0.5,'^','MarkerEdgeColor',[.9 .9 .9], ...
                        'MarkerFaceColor',(1-Q_tmp(i,tmp)).*[.5 .5 0],'MarkerSize',10);
                case 2
                    plot(spalte-0.5,zeile-0.5,'>','MarkerEdgeColor',[.9 .9 .9], ...
                        'MarkerFaceColor',(1-Q_tmp(i,tmp)).*[.5 .5 0],'MarkerSize',10);
                case 3
                    plot(spalte-0.5,zeile-0.5,'v','MarkerEdgeColor',[.9 .9 .9], ...
                        'MarkerFaceColor',(1-Q_tmp(i,tmp)).*[.5 .5 0],'MarkerSize',10);
                case 4
                    plot(spalte-0.5,zeile-0.5,'<','MarkerEdgeColor',[.9 .9 .9], ...
                        'MarkerFaceColor',(1-Q_tmp(i,tmp)).*[.5 .5 0],'MarkerSize',10);
            end
            
        end
        i = i + 1;
    end
    
end
drawnow
hold off

end

