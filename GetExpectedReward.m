function [ r ] = GetExpectedReward( ap,pos,goal,maze )
% GETEXPECTEDREWARD returns the expected reward for action a in in position
% pos
% 
% 
% r: expected reward
% a: actual selected action
% pos: position
% goal: terminal state

% 0 in case of success, -1 for all other moves

[ posp ] = DoAction( ap, pos, maze );

if ( posp==goal) 
	r = 1;
else
    r = -1;   
end


end

