function [right_dir, distance_new] = CheckDirectionStart(pos,start,distance_old)

distance_new = pdist2(start,pos,'euclidean');

if distance_new > distance_old
    right_dir = 1;
else 
    right_dir = -1;
end
    

