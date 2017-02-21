disp(' ')
disp('--- Welcome VA-Space Analysis ---')
disp(' ')
disp(' Available output files: ')
folders = dir('output*');

% sort by date
[~, idx] = sort([folders.datenum]);
folders = folders(idx);

for i = 1:length(folders)
    fprintf('\n [%i] %s', i, folders(i).name)
end
reply = [];
while isempty(reply)
    reply = input('\n\nSelect FIRST output file to display (blue): ');
end
reply2 = [];
while isempty(reply2)
    reply2 = input('\nSelect SECOND output file to display (red): ');
end

load(folders(reply).name)

% extract variables

nb_steps = output.nb_steps;

% calculate arousal
% -> weighted average

% A = ((output.dir_freq + output.col_freq) ./ 2);
A = output.A;

% calculte valence

% V = (output.right_dir - min(output.right_dir))...
%     ./(max(output.right_dir) - min(output.right_dir)) - 0.5;

% V = (output.right_dir + output.goal_sight) ./ 2;
V = output.V;

% plot figures
figure
subplot(8,1,1)
plot(1:nb_steps,A(1:nb_steps));
title('Arousal')
subplot(8,1,2)
plot(1:nb_steps,V(1:nb_steps))
title('Valance')
subplot(8,1,[4 8])
scatter(V,A,'filled')
title('V-A-Space')
set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1])
axis([-1 1 -1 1])
hline(0)
vline(0)
subplot(8,1,3)
plot(1:nb_steps,output.quadrant(1:nb_steps))
title('Quadrant of the V-A-Space')


load(folders(reply2).name)

% extract variables

nb_steps = output.nb_steps;

% calculate arousal
% -> weighted average

% A = ((output.dir_freq + output.col_freq) ./ 2);
A = output.A;

% calculte valence

% V = (output.right_dir - min(output.right_dir))...
%     ./(max(output.right_dir) - min(output.right_dir)) - 0.5;

% V = (output.right_dir + output.goal_sight) ./ 2;
V = output.V;

% plot figures
subplot(8,1,1)
hold on
plot(1:nb_steps,A(1:nb_steps),'r')
subplot(8,1,2)
hold on
plot(1:nb_steps,V(1:nb_steps),'r')
subplot(8,1,[4 8])
hold on
scatter(V,A,'r','filled')
set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1])
l = legend(folders(reply).name,folders(reply2).name,'Location','BestOutside');
set(l, 'Interpreter', 'none')
subplot(8,1,3)
hold on
plot(1:nb_steps,output.quadrant(1:nb_steps),'r')
