function [ a, best_action ] = GetBestAction( Q, s )
% GetBestAction return the best action for state (s)
% Q: the Qtable
% s: the current state
% Q has structure  Q(states,actions)


% must do a trick in order to avoid the selection of the same action when two or more actions
% have the same value.

best_action = 0;

nactions=size(Q,2);

[v idx]    = sort(Q(s,:),'descend');
x          = diff(v);
i          = find(x,1);

if isempty(i)
    a = randi(nactions);
else
    % i is the number of equal elements
    j = randi(i);
    
    % idx(j) is the jth index in sorted idx, thus a=idx(j) some of the best
    % (equal values) actions
    a = idx(j);
    best_action = 1;
end

end