% Perform 10 runs of the same experiment

clear all, close all

nb_eps = 20;
nb_rep = 10;

only_plot = false;

resdir = 'exp_3_affect_on/';

if not(isempty(findstr(resdir, 'on')))
    affect_switch = true;
else 
    affect_switch = false;
end

if not(only_plot)
    % Affective Episode
    %affect_switch = true;

    mkdir(resdir);

    % Create Samples
    for i = 1:nb_rep
        MazeDemo(nb_eps, resdir, affect_switch)
    end
end


% Evaluation

clear A V averageVA counter

folders = dir([resdir 'output*']);
% sort by date
[~, idx] = sort([folders.datenum]);
folders = folders(idx);


figure
% cmap = colormap(gray);
% cmap = cmap(30:-1:1,:);
if affect_switch
    % blau
    cmap = zeros(30,3);
    cmap(:,3) = linspace(1,0.5,30);
else
    cmap = zeros(30,3);
    cmap(:,1) = linspace(1,0.5,30);
end

if length(cmap) > (nb_eps+1)
    m = length(cmap) / (nb_eps+1);
    c = 1 - m;
else
    m = (length(cmap)-1) / (nb_eps);
    c = 1 - m;
end

counter = 1;

fSize = 18;

% we calculate averages for each episode of the experiment 
% and then average again over the number of repetitions of 
% the experiment. An episode is a full run of the experiment 
% where the agent starts at the start state and has to find 
% the goal state

for i = 1:nb_eps % number of episode 
    for j = 1:nb_rep % number of repetitions of the whole experiment
        
        %         1   2   3   4   5   6   7   8   9   10 ...
        %         21  22  23  24  25  26  27  28  29  30 ...
        %         41  42  43  44  45  46  47  48  49  50 ...
        % this selects the right episode-file number for a 
        % corresponding repetition of the experiment 
        k = (j-1)*nb_eps + i;
        
        
        load([resdir folders(k).name])
        % extract variables
        nb_steps = output.nb_steps;
        
        
        Atmp = output.A;
        A(j) = mean(Atmp(1:nb_steps));
        
        
        Vtmp = output.V;
        V(j) = mean(Vtmp(1:nb_steps));
        
    end
    
    V = mean(V);
    A = mean(A);
    
    
    averageVA(counter,:) = [V A];
    
    col = round(m*counter + c);
    
    scatter(averageVA(counter,1),averageVA(counter,2),50,cmap(col,:),'filled');
    hold on
    text(averageVA(counter,1)+0.01,averageVA(counter,2),num2str(i), 'FontSize', fSize)
%     xlabel('V')
%     ylabel('A')
%     pause(0.5)
    
    counter = counter + 1;
    clear A V
end
%axis([-1 1 -1 1]);
%set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1])
xlim([-0.4, 0.4])
ylim([-0.3, 0.1])
hline(0)
vline(0)

text(-0.1, 0.03, 'Q4', 'FontSize', 30, 'Color', [0.8, 0.8, 0.8])
text(0.02, 0.03, 'Q1', 'FontSize', 30, 'Color', [0.8, 0.8, 0.8])
text(0.02, -0.03, 'Q2', 'FontSize', 30, 'Color', [0.8, 0.8, 0.8])
text(-0.1, -0.03, 'Q3', 'FontSize', 30, 'Color', [0.8, 0.8, 0.8])

set(gca,'FontSize',fSize)

xlabel('Valence', 'FontSize', fSize)
ylabel('Arousal', 'FontSize', fSize)

hold off

set(gcf, 'PaperPosition', [0 0.1 8 7]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [8 7]); %Set the paper to have width 5 and height 5.
saveas(gcf, [resdir(1:end-1), datestr(now, 'HHmmss')], 'pdf')
