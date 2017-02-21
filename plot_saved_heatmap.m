load Q_save

for i = 1:length(Q_sav)
    
    maze = CreateMaze;
    tmp = Q_sav{i};
    
    PlotHeatmap(maze,tmp);
    pause(0.1)
    
end