function [ r,f ] = GetReward( pos,goal,varargin )
% MountainCarGetReward returns the reward at the current state
% x: a vector of position and velocity of the car
% r: the returned reward.
% f: true if the car reached the goal, otherwise f is false

if isempty(varargin)
    good_state = -1;
else
    good_state = varargin{1};
end
    

% 0 in case of success, -1 for all other moves
if ( pos==goal)
%     r = 1;
	r = 10;
    f = true;
else
    r = good_state;   
    f = false;
end

    


    
