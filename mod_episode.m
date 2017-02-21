function [ total_reward,steps,Q,Model, output ] = mod_episode( maxsteps, Q,Model , alpha, gamma,epsilon,statelist,actionlist,grafic,maze,start,goal,p_steps,affect_switch)
%AFFECT_EPISODE

% maxstepts: the maximum number of steps per episode
% Q: the current QTable
% alpha: the current learning rate
% gamma: the current discount factor
% epsilon: probablity of a random action
% statelist: the list of states
% actionlist: the list of actions

disp('Entering modified episode...')

x            = start;
steps        = 0;
total_reward = 0;
output.dir_freq = zeros(1,maxsteps);
output.col_freq = zeros(1,maxsteps);
output.right_dir = zeros(1,maxsteps);
output.quadrant = zeros(1,maxsteps);
col_freq = 0;
dir_freq = 0;
dir_changed = 0;
distance = Inf;


ap = [];

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
    [xp, wall_detection]  = ModDoAction( action , x, maze );
    
    
    if affect_switch == true
        if output.quadrant(i) > 0 && output.quadrant(i) < 3
            good_state = 0;
        else
            good_state = -1;
        end
    else
        good_state = -1;
    end
    
    
    % observe the reward at state xp and the final state flag
    
    [r,f]   = GetReward(xp,goal,good_state);
    total_reward = total_reward + r;
    
    % generate short time memory processes for collisions and direction
    % changes
    
    if wall_detection
        col_freq = 1;
    else
        col_freq = col_freq * 0.95;
    end
    
    if dir_changed
        dir_freq = 1;
    else
        dir_freq = dir_freq * 0.95;
    end
    
    
    %% --------------------------------------------------------------------- %%
    % ROUTINE level
    
    % convert the continous state variables in [xp] to an index of the statelist
    sp  = DiscretizeState(xp,statelist);
    
    % select action prime
    ap = e_greedy_selection(Q,sp,epsilon);
    
    % Update the Qtable, that is,  learn from the experience
    Q = UpdateQLearning( s, a, r, sp, ap, Q , alpha, gamma );
    
    
    
    %% --------------------------------------------------------------------- %%
    % REFELCTION level
    
    dir_changed = CheckDirection(a,ap);
    
    %[right_dir, distance] = CheckDirectionGoal(xp,goal,distance);
    [right_dir, distance] = CheckDirectionStart(xp,start,distance);
    
    if i == 1
        output.right_dir(1) = 0.01*right_dir;
    elseif right_dir == -1
        output.right_dir(i) = output.right_dir(i-1) * 0.7;
    else
        %y2(i) = y2(i-1)^0.5;
        output.right_dir(i) = 6.3 ./ (1.0 + 0.1*exp(-(output.right_dir(i-1)-5)));
    end
    
    %%% Reflection: Affective Appraisal
    
    % calculate arousal
    % -> weighted average
    
    A = ((dir_freq + col_freq) ./ 2) - 0.5;
    
    % calculte valence
    
    V = output.right_dir(i) - 0.5;
    
    % alter reward due to the affective appraisal
    
    if (V > 0) && (A > 0.5)
        % Quadrant I
        output.quadrant(i) = 1;
    elseif (A > 0.5) && (V < 0)
        % Quadrant IV
        output.quadrant(i) = 4;
    elseif (A < 0.5) && (V < 0)
        % Quadrant III
        output.quadrant(i) = 3;
    else
        % Quadrant II
        output.quadrant(i) = 2;
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
    end
    
    % if reachs the goal breaks the episode
    if (f==true)
        output.nb_steps = i;
        if affect_switch
            save(['output_a' datestr(now, 'hhmmss') '_' num2str(i)],'output' )
        else
            save(['output_n' datestr(now, 'hhmmss') '_' num2str(i)],'output' )
        end
        break
    end
    
end






end

