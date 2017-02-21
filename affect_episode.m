function [ total_reward,steps,Q,Model, output ] = affect_episode( maxsteps, ...
    Q,Model , alpha, gamma,epsilon,statelist,actionlist,grafic,maze,...
    start, goal, p_steps, affect_switch, resdir)
%AFFECT_EPISODE

% maxstepts: the maximum number of steps per episode
% Q: the current QTable
% alpha: the current learning rate
% gamma: the current discount factor
% epsilon: probablity of a random action
% statelist: the list of states
% actionlist: the list of actions

%resdir = 'exp2/';

version_switch = 1; % 1-paper version 2-diss version

% preallocation
x            = start;
steps        = 0;
total_reward = 0;
output.dir_freq = zeros(1,maxsteps);
output.col_freq = zeros(1,maxsteps);
output.right_dir = zeros(1,maxsteps);
output.quadrant = zeros(1,maxsteps+1);
output.actions = zeros(1,maxsteps);
output.positions = zeros(2,maxsteps);
output.goal_sight = zeros(1,maxsteps);
output.A = zeros(1,maxsteps);
output.V = zeros(1,maxsteps);
col_freq = 0;
dir_freq = 0;
goal_freq = 0;
dir_changed = 0;
best_action = 0;
distance = Inf;
ap = [];

% exponential growth process
w = 0;          % initial value
theta = 0.2;    % growth rate
w2 = 0;
theta2 = 0.2;

% exponential decay process
eta = 0.15;

% % reward bonus process
% rbonus = 0;

% convert the continous state variables to an index of the statelist
s   = DiscretizeState(x,statelist);
% selects an action using the epsilon greedy selection strategy
a   = e_greedy_selection(Q,s,epsilon);


for i=1:maxsteps
    
    % convert the index of the action into an action value
    action = actionlist(a);
    
    %% --------------------------------------------------------------------- %%
    % REACTION level
    
    %do the selected action and get the next state
    [xp, wall_detection]  = DoAction( action, x, maze );
    
    % save actions and positions
    output.actions(i) = action;
    output.positions(:,i) = xp;
    
    % Change reward structure if agent is in a good mood
    if affect_switch == true
        if output.quadrant(i) > 0 && output.quadrant(i) < 3
            good_state = 0;
            %             good_state = 1;
            %    disp('good state')
        else
            good_state = -1;
            %             good_state = 0;
        end
    else
        good_state = -1;
        %         good_state = 0;
    end
    
    
    % observe the reward at state xp and the final state flag
    
    [r,f]   = GetReward(xp,goal, good_state);
    total_reward = total_reward + r;
    
    % generate short time memory processes for collisions and direction
    % changes
    switch version_switch
        case 1
            % 03-01-14: habe positiven anstieg mit negativer abnahme vertauscht
            % +/-1 vertauschen!!!
            % Wall collision frequency
            if wall_detection
                % col_freq = 1;
                % if wall detected the contribution to arousal goes up
                col_freq = col_freq + (1 - col_freq) * eta;
            else
                % col_freq = col_freq * eta; % old methode with eligibilty traces
                col_freq = col_freq + (-1 - col_freq) * eta;
            end
            % Direction Frequency
            if (dir_changed)
                dir_freq = dir_freq + (1 - dir_freq) * eta;
            else
                dir_freq = dir_freq + (-1 - dir_freq) * (eta);
            end
            %     disp(['dir_freq=' num2str(col_freq)])
        case 2
            % using exponential smoothing (diss version)
            if wall_detection
                col_freq = eta * 1 + (1-eta)*col_freq;
            else
                col_freq = eta * (-1) + (1-eta)*col_freq;
            end
            if (dir_changed)
                dir_freq = eta * 1 + (1-eta)*dir_freq;
            else
                dir_freq = eta * (-1) + (1-eta)*dir_freq;
            end
            %     disp(['dir_freq=' num2str(col_freq)])
    end
    
    %     disp(['col_freq=' num2str(col_freq)])
    %     if (dir_changed && not(best_action))
    %         % dir_freq = 1;
    %         % frequent directional changes increase the arousal value
    %         dir_freq = dir_freq + (1 - dir_freq) * eta;
    %     elseif best_action
    %         % dir_freq = dir_freq * eta; % old methode with eligibilty traces
    %         % in case of an action according to the policy the arousal goes
    %         % down (fast)
    %         dir_freq = dir_freq + (-1 - dir_freq) * (eta + 0.1);
    %     else
    %         % if there is no directional change arousal goes down slowly
    %         dir_freq = dir_freq + (-1 - dir_freq) * (eta);
    %     end
    
    %% --------------------------------------------------------------------- %%
    % ROUTINE level
    
    % convert the continous state variables in [xp] to an index of the statelist
    sp  = DiscretizeState(xp,statelist);
    
    % select action prime
    [ap, best_action] = e_greedy_selection(Q,sp,epsilon);
    
    % Update the Qtable, that is,  learn from the experience
    Q = UpdateQLearning( s, a, r, sp, ap, Q , alpha, gamma );
    
    
    
    %% --------------------------------------------------------------------- %%
    % REFELCTION level
    
    dir_changed = CheckDirection(a,ap);
    
    % [right_dir, distance] = CheckDirectionGoal(xp,goal,distance);
    [right_dir, distance] = CheckDirectionStart(xp,start,distance);
    
    w = w + (right_dir - w) * theta;
    
    output.right_dir(i) = w;
    
    % Goal in sight?
    
    goal_sight = goalinsight(xp,goal,maze);
    
    switch version_switch
        case 1 % paper version
            w2 = w2 + (goal_sight - w2) * theta2;
            output.goal_sight(i) = w2;
        case 2 % diss version
            % exponential smoothing
            goal_freq = theta2 * goal_sight + (1-eta)*goal_freq;
            output.goal_sight(i) = goal_freq;
    end
    
    %%% Reflection: Affective Appraisal
    
    % calculate arousal
    % -> weighted average
    
    if goal_sight
        A = ((dir_freq + col_freq + output.goal_sight(i)) ./ 3);
    else
        A = ((dir_freq + col_freq) ./ 2);
    end
    
    % calculate valence
    
    if goal_sight
        V = (output.right_dir(i) + output.goal_sight(i)) ./ 2;
    else
        V = output.right_dir(i);
    end
    
    % save A and V value
    
    output.A(i) = A;
    output.V(i) = V;
    
    % 03-01-14: Valence modification according to the reward
    %     if r >= 0
    %         rbonus = rbonus + (1 - rbonus) * 0.01;
    % %         sprintf(' %.2f',rbonus)
    %         V = (output.right_dir(i) + rbonus) / 2;
    %     else
    %         rbonus = rbonus + (-1 - rbonus) * 0.01;
    %         V = output.right_dir(i);
    %     end
    %
    
    % alter reward due to the affective appraisal
    
    if (V > 0) && (A > 0)
        % Quadrant I
        output.quadrant(i+1) = 1;
    elseif (A > 0) && (V < 0)
        % Quadrant IV
        output.quadrant(i+1) = 4;
    elseif (A < 0) && (V < 0)
        % Quadrant III
        output.quadrant(i+1) = 3;
    elseif (A < 0) && (V > 0)
        % Quadrant II
        output.quadrant(i+1) = 2;
    else
        output.quadrant(i+1) = 0;
    end
    
    
    % Planning
    Model = UpdateModel(s,a,r,sp,Model);
    
    Q     = RandomPlanning(Q, Model, p_steps, alpha, gamma);
    
    %output.right_dir(i) = right_dir;
    
    %% --------------------------------------------------------------------- %%
    
    
    %update the current variables
    s = sp;
    a = ap;
    x = xp;
    
    
    %increment the step counter.
    steps=steps+1;
    
    % save outputs
    output.dir_freq(i) = dir_freq;
    output.col_freq(i) = col_freq;
    
    % Plot of the mountain car problem
    if (grafic==true)
        %        Plot( x,a,steps,maze,start,goal,['PLANNING (N=' num2str(p_steps) ')']);
        PlotMaze( x,a,steps,maze,start,goal,['PLANNING (N=' num2str(p_steps) ') Affective: ' num2str(affect_switch)]);
        PlotVAlive(output, i);
    end
    
    % if reachs the goal breaks the episode
    if (f==true)
        output.nb_steps = i;
        if affect_switch
            save([resdir 'output_a_' strrep(num2str(epsilon),'.','_') '_' datestr(now, 'mmssfff') '_' num2str(i)],'output' )
        else
            save([resdir 'output_n_' datestr(now, 'mmssfff') '_' num2str(i)],'output' )
        end
        break
    end
    
end

if i == maxsteps
    output.nb_steps = maxsteps;
    if affect_switch
        save([resdir 'output_a_' strrep(num2str(epsilon),'.','_') '_' datestr(now, 'mmssfff') '_' num2str(i)],'output' )
    else
        save([resdir 'output_n_' datestr(now, 'mmssfff') '_' num2str(i)],'output' )
    end
end






end

