function [ total_reward,steps,Q,Model,pred_risk ] = Episode( maxsteps, Q,Model , alpha, gamma,epsilon,statelist,actionlist,grafic,maze,start,goal,p_steps )
% Episode do one episode of the mountain car with sarsa learning
% maxstepts: the maximum number of steps per episode
% Q: the current QTable
% alpha: the current learning rate
% gamma: the current discount factor
% epsilon: probablity of a random action
% statelist: the list of states
% actionlist: the list of actions

% Maze
% Programmed in Matlab
% by:
%  Jose Antonio Martin H. <jamartinh@fdi.ucm.es>
%
%

x            = start;
steps        = 0;
total_reward = 0;


% convert the continous state variables to an index of the statelist
s   = DiscretizeState(x,statelist);
% selects an action using the epsilon greedy selection strategy
a   = e_greedy_selection(Q,s,epsilon);

x_t = [];
e_t = [];

kappa = zeros(maxsteps,1);

v = zeros(maxsteps,1);

path = zeros(maxsteps,4);


for i=1:maxsteps
    
    % convert the index of the action into an action value
    action = actionlist(a);
    
    %do the selected action and get the next state
    xp  = DoAction( action , x, maze );
    
    % observe the reward at state xp and the final state flag
    [r,f]   = GetReward(xp,goal);
    total_reward = total_reward + r;
    
    % convert the continous state variables in [xp] to an index of the statelist
    sp  = DiscretizeState(xp,statelist);
    
    % select action prime
    ap = e_greedy_selection(Q,sp,epsilon);
    
    % calculate prediction risk
    
     a_s = e_greedy_selection(Q,s,epsilon);
     x_s = DoAction(a_s,x,maze);
     [r_s,~] = GetReward(x_s,goal);
     
%      e_t_temp = r - r_s;
     e_t_temp = norm(xp - x_s);
    
%     x_t_temp = GetExpectedReward(ap,xp,goal,maze);
%     e_t_temp = r - x_t_temp;
%     
%     x_t = [x_t; x_t_temp];
     e_t = [e_t; e_t_temp];
     
%     temp = cov([x_t e_t]);
%     kappa(i) = temp(1,end);
    v(i) = sqrt(var(e_t));
    
%     kappa(i) = cov([x_s; e_t']) ./ sqrt(var(e_t));

    % Update the Qtable, that is,  learn from the experience
    Q = UpdateQLearning( s, a, r, sp, ap, Q , alpha, gamma );
    
    % Planning
    Model = UpdateModel(s,a,r,sp,Model);
    Q     = RandomPlanning(Q, Model, p_steps, alpha, gamma);
    
    % conserve path
    path(i,:) = [xp x_s];
    
    %update the current variables
    s = sp;
    a = ap;
    x = xp;
    
    
    %increment the step counter.
    steps=steps+1;
    
    % Plot of the mountain car problem
    if (grafic==true)
        %        Plot( x,a,steps,maze,start,goal,['PLANNING (N=' num2str(p_steps) ')']);
        PlotMaze( x,a,steps,maze,start,goal,['PLANNING (N=' num2str(p_steps) ')']);
        
    end
    
    % if reachs the goal breaks the episode
    if (f==true)
        pred_risk = {x_t,e_t,v,kappa,path};
        
        break
    end
    
end



