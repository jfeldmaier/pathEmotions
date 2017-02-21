function goal_sight = goalinsight(xp,goal,maze)

goal_sight = 0;

[walls_x,walls_y] = find(maze == 1);

walls = [walls_x - 1, walls_y - 1];

[x,y] = bresenham(xp(1),xp(2),goal(1),goal(2));

for i=1:length(x)
    if ismember([x(i),y(i)],walls,'rows')
        return % return if a wall coordinate is member of the line coordinates
    end
end

goal_sight = 1;
