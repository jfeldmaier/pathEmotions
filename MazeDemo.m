function  MazeDemo( maxepisodes, resdir, affect_switch)
%MazeDemo, the main function of the demo
%maxepisodes: maximum number of episodes to run the demo

% Maze Problem
% Programmed in Matlab
% by:
%  Jose Antonio Martin H. <jamartinh@fdi.ucm.es>
%

%delete output files
% s = input('Delete all output files? [y/n]: ','s');
% if strcmp(s,'y')
%     delete('output_*')
% end

grafica = false; % indicates if display the graphical interface
select_maze = 1; % select different mazes

%clc
%close all
switch select_maze
    case 1
        start       = [0 3];
        goal        = [8 5];
        [maze N M]  = CreateMaze();
    case 2
        start       = [0 3];
        goal        = [8 5];
        [maze N M]  = CreateMaze2();
end
        

% start       = [0 3];
% goal        = [7 7];
% load('long_maze_8x8.mat')
% N = 8;
% M = 8;

% empty maze
% start       = [0 3];
% goal        = [7 7];
% load('empty_maze_8x8.mat')
% N = 8;
% M = 8;

% start       = [0 3];
% goal        = [7 0];
% load('diff_maze_8x8.mat')
% N = 8;
% M = 8;

statelist   = BuildStateList(N,M);  % the list of states
actionlist  = BuildActionList(); % the list of actions

nstates     = size(statelist,1);
nactions    = size(actionlist,1);

%Generate initial Population
Q           = BuildQTable(nstates,nactions ); % the Qtable
Model       = BuildModel(nstates,nactions ); % model

% planning steps
p_steps     = 50;    % fast learning
% p_steps     = 5;     % slow learning

maxsteps    = 2000;  % maximum number of steps per episode
alpha       = 0.01;   % learning rate
gamma       = 0.95;  % discount factor

% load('tmp_eps')
epsilon     = 0.1;   % probability of a random action selection

% Affective Episode
% affect_switch = false;

%resdir = 'exp2/';

if grafica
    figure
end
% grafica     = true;
xpoints=[];
ypoints=[];
x2points=[];
y2points=[];
x3points=[];
y3points=[];

% result variables
avg_steps = [];
avg_reward = [];
avg_walls = [];

for i=1:maxepisodes
    
    %     if i ~= 10
    [total_reward,steps,Q,Model, output ] =  affect_episode( maxsteps, Q, Model , alpha, ...
        gamma,epsilon,statelist,actionlist,grafica,maze,start,goal,p_steps,affect_switch, resdir);
    disp(['Espisode: ',int2str(i),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward),' epsilon: ',num2str(epsilon)])
    %     else
    %         [total_reward,steps,Q,Model, output ] =  mod_episode( maxsteps, Q, Model , alpha, ...
    %             gamma,epsilon,statelist,actionlist,grafica,maze,start,goal,p_steps, affect_switch) ;
    %         disp(['Espisode: ',int2str(i),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward),' epsilon: ',num2str(epsilon)])
    %     end
    
    [ avg_steps ] = movingAverage( steps, avg_steps );
    [ avg_reward ] = movingAverage( total_reward, avg_reward );
    
    A = ((output.dir_freq + output.col_freq) ./ 2);
    A = mean(A(1:steps));
    V = output.right_dir;
    V = mean(V(1:steps));
    %     if (V > 0) && (A > 0)
    %         % Quadrant I
    %         epsilon = epsilon*0.95;
    %     end
    
    
    %epsilon = epsilon*0.999;
    
    %PlotHeatmap( maze, Q )
    
    Q_sav{i} = Q;
    
    xpoints(i)=i-1;
    ypoints(i)=steps;
    if grafica
        %subplot(3,2,3:4);        
        %plot(xpoints,ypoints,x2points,y2points)
        %title(['Episode: ',int2str(i),' epsilon: ',num2str(epsilon)])
    end
    
    x3points(i)=i-1;
    y3points(i)=epsilon;
    
    if grafica
        subplot(3,2,2);
        plot(x3points,y3points)
        title('Epsilon: ')
        
        drawnow
    end
    
%         if i > 10
%             [maze N M]  = CreateNewMaze();
%         end
%     
    
end

disp(['Average Steps: ',int2str(avg_steps)])
disp(['Average Reward: ',int2str(avg_reward)])

l_curve = [xpoints; ypoints];
if affect_switch
    save([resdir 'l_curve_a_' strrep(num2str(epsilon),'.','_') '_' datestr(now, 'mmssfff')],'l_curve' )
else
    save([resdir 'l_curve_n_' strrep(num2str(epsilon),'.','_') '_' datestr(now, 'mmssfff')],'l_curve' )
end
% save(['Learning_curve_' num2str(p_steps), 'p_steps'], 'l_curve')
% save('Q_save', 'Q_sav')






