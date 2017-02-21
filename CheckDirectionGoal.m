function [right_dir, distance_new] = CheckDirectionGoal(pos,goal,distance_old)

distance_new = pdist2(goal,pos,'euclidean');

if distance_new < distance_old
    right_dir = 1;
else 
    right_dir = -1;
end
    

