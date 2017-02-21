% Perform 10 runs of the same experiment

clear all, close all

nb_eps = 20;
nb_rep = 10;

only_plot = true;
plot_type = 4;  % 1 - average core affect
                % 2 - scatter plot of A and V
                % 3 - separate subplots of A and V
                % 4 - single core affects for selected episodes
                % 5 - learning curve

resdir = 'exp_1_affect_off/';
% resdir = 'exp_10_big_10rep_aff_off/';

% comapring learning curves of experiments. set plot_type to 5
% and enter second results dir (if set to empty, just one 
% learning curve is plotted
% resdir2 = 'exp_10_big_10rep_aff_off/';
resdir2 = [];

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

fSize = 18;
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

switch plot_type
    case 1
        xlim([-0.4, 0.4])
        ylim([-0.3, 0.1])
        hline(0)
        vline(0)
        text(-0.1, 0.03, 'Q4', 'FontSize', 30, 'Color', [0.8, 0.8, 0.8])
        text(0.02, 0.03, 'Q1', 'FontSize', 30, 'Color', [0.8, 0.8, 0.8])
        text(0.02, -0.03, 'Q2', 'FontSize', 30, 'Color', [0.8, 0.8, 0.8])
        text(-0.1, -0.03, 'Q3', 'FontSize', 30, 'Color', [0.8, 0.8, 0.8])
        hold on
    case 4
        xlim([-0.7, 0.7])
        ylim([-0.7, 0.7])
        ax = gca;
        ax.XTick = [-0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6];
        ax.YTick = [-0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6];
        hline(0)
        vline(0)
        rectangle('Position',[-0.5 -0.5 1 1],'Curvature',1, 'LineStyle', '--')
        textconfig = {'HorizontalAlignment', 'VerticalAlignment','BackgroundColor', ...
            'FontSize'};
        textparas = {'center', 'middle', 'white',fSize};
        text(0.3,0.4,'excited',textconfig, textparas)
        text(0.5,0.15,'happy',textconfig, textparas)
        text(0.3,-0.4,'relaxed',textconfig, textparas)
        text(0.5,-0.15,'contented',textconfig, textparas)
        text(-0.3,0.4,'nervous',textconfig, textparas)
        text(-0.5,0.15,'distressed',textconfig, textparas)
        text(-0.3,-0.4,'depressed',textconfig, textparas)
        text(-0.5,-0.15,'sad',textconfig, textparas)
        hold on
    case 5
        PlotLcurve(resdir, resdir2, nb_eps, nb_rep)
end



% we calculate averages for each episode of the experiment
% and then average again over the number of repetitions of
% the experiment. An episode is a full run of the experiment
% where the agent starts at the start state and has to find
% the goal state

A = [];
V = [];
C = zeros(1,2000);

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
        
        switch plot_type
            case 1
                Atmp = output.A;
                A(j) = mean(Atmp(1:nb_steps));
                Vtmp = output.V;
                V(j) = mean(Vtmp(1:nb_steps));
            case {2,3,4}
                
                
                %Atmp = output.A;
                %Atmp = interp1(1:nb_steps,output.A(1:nb_steps),1:2000);
                
                %         xi = 1:1/nb_steps:2000; %interpolation points (where to look for a value)
                %         xi = 1:(nb_steps/2000):2000;
                xi = linspace(1,nb_steps,2000);
                Atmp = interp1(1:nb_steps,output.A(1:nb_steps),xi);
                A(j, :) = Atmp;
                %         Atmp = resample(output.A(1:nb_steps),2000,nb_steps);
                %         A(j, :) = Atmp;
                
                %Vtmp = output.V;
                %Vtmp = interp1(1:nb_steps,output.V(1:nb_steps),1:2000);
                Vtmp = interp1(1:nb_steps,output.V(1:nb_steps),xi);
                V(j, :) = Vtmp;
                %         Vtmp = resample(output.V(1:nb_steps),2000,nb_steps);
                %         V(j,:) = Vtmp;
                
                %         subplot(211)
                %         plot(Vtmp)
                %         hold on
                %         subplot(212)
                %         plot(Atmp)
                %         hold on
                
                tmp = zeros(1,2000);
                tmp(1,1:nb_steps) = 1;
                C = C + tmp;
        end
        
    end
    
    switch plot_type
        case 1
            V = mean(V);
            A = mean(A);
            averageVA(counter,:) = [V A];
            col = round(m*counter + c);
            
            scatter(averageVA(counter,1),averageVA(counter,2),50,cmap(col,:),'filled');
            text(averageVA(counter,1)+0.01,averageVA(counter,2),num2str(i), 'FontSize', fSize)
            
            counter = counter + 1;
            clear A V
        case 2
            Aplot = mean(A,1);
            Vplot = mean(V,1);
            scatter(Vplot(1:end-1),Aplot(1:end-1),'.')
            hold on
        case 3
            Aplot = mean(A,1);
            Vplot = mean(V,1);
            subplot(211)
            hold on
            plot(1:2000, smooth(Vplot))
            title('Valence')
            subplot(212)
            hold on
            plot(1:2000, smooth(Aplot))
            title('Arousal')
        case 4
            Aplot = mean(A,1);
            Vplot = mean(V,1);
            if any(i == [1 2 3 10 20])
                plot(smooth(Vplot,300),smooth(Aplot,300),'LineWidth',2)
                text(Vplot(end-50),Aplot(end-50),num2str(i))
            end
    end
    
    
    
    
    
    %     averageVA(counter,:) = [V A];
    %
    %     col = round(m*counter + c);
    %
    %     scatter(averageVA(counter,1),averageVA(counter,2),50,cmap(col,:),'filled');
    %     hold on
    %     text(averageVA(counter,1)+0.01,averageVA(counter,2),num2str(i), 'FontSize', fSize)
    %     xlabel('V')
    %     ylabel('A')
    %     pause(0.5)
    %
    %     counter = counter + 1;
    %     clear A V
end
%axis([-1 1 -1 1]);
%set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1])
%xlim([-0.4, 0.4])
%ylim([-0.3, 0.1])
switch plot_type
    case 1
        set(gca,'FontSize',fSize)
        xlabel('Valence', 'FontSize', fSize)
        ylabel('Arousal', 'FontSize', fSize)
        
    case 2
        hline(0)
        vline(0)
        
        text(-0.1, 0.03, 'Q4', 'FontSize', 30, 'Color', [0.8, 0.8, 0.8])
        text(0.02, 0.03, 'Q1', 'FontSize', 30, 'Color', [0.8, 0.8, 0.8])
        text(0.02, -0.03, 'Q2', 'FontSize', 30, 'Color', [0.8, 0.8, 0.8])
        text(-0.1, -0.03, 'Q3', 'FontSize', 30, 'Color', [0.8, 0.8, 0.8])
        
        set(gca,'FontSize',fSize)
        
        xlabel('Valence', 'FontSize', fSize)
        ylabel('Arousal', 'FontSize', fSize)
    case 4
        set(gca,'FontSize',fSize)
        xlabel('Valence', 'FontSize', fSize)
        ylabel('Arousal', 'FontSize', fSize)

end

hold off

switch plot_type
    case {1, 2,3,4}
        set(gcf, 'PaperPosition', [0 0.1 8 7]); %Position plot at left hand corner with width 5 and height 5.
        set(gcf, 'PaperSize', [8 7]); %Set the paper to have width 5 and height 5.
        saveas(gcf, ['new_', resdir(1:end-1), datestr(now, 'HHmmss')], 'pdf')
    case 5
        set(gca,'FontSize',fSize)
        xlabel('Episode', 'FontSize', fSize)
        ylabel('Steps', 'FontSize', fSize)
        set(gcf, 'PaperPosition', [0 0.1 12 4]); %Position plot at left hand corner with width 5 and height 5.
        set(gcf, 'PaperSize', [12 4]); %Set the paper to have width 5 and height 5.
        saveas(gcf, ['learningCurve_', resdir(1:end-1), '+', resdir2(1:end-1), datestr(now, 'HHmmss')], 'pdf')
end
