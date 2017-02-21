disp(' ')
disp('--- Welcome VA-Space Analysis - Tool II ---')
disp(' ')
disp(' Available output files: ')

folders = dir('output*');
% sort by date
[~, idx] = sort([folders.datenum]);
folders = folders(idx);

% print filenames
for i = 1:length(folders)
    fprintf('\n [%i] %s', i, folders(i).name)
end
% ask user for input range
disp(' ')
disp('Select a range of output files')
firstFile = [];
while isempty(firstFile)
    firstFile = input('\n\nSelect FIRST output file: ');
end
lastFile = [];
while isempty(lastFile)
    lastFile = input('\nSelect SECOND output file: ');
end
figure
cmap = colormap(gray);
cmap = cmap(30:-1:1,:);

if length(cmap) > (lastFile-firstFile+1)
    m = length(cmap) / (lastFile-firstFile+1);
    c = 1 - m;
else
    m = (length(cmap)-1) / (lastFile-firstFile);
    c = 1 - m;
end
    
counter = 1;

for i = firstFile:1:lastFile
    
    load(folders(i).name)
    % extract variables
    nb_steps = output.nb_steps;
    
    % calculate arousal
    % -> weighted average
%         A = ((output.dir_freq + output.col_freq) ./ 2);
        A = output.A;
        A = mean(A(1:nb_steps));
    
    % calculte valence
%         V = (output.right_dir + output.goal_sight) ./ 2;
        V = output.V;
        V = mean(V(1:nb_steps));
        
        averageVA(counter,:) = [V A];
        
    col = round(m*counter + c);
        
    scatter(averageVA(counter,1),averageVA(counter,2),50,cmap(col,:),'filled');
    hold on 
    text(averageVA(counter,1)+0.01,averageVA(counter,2),num2str(i))
    counter = counter + 1;
     pause(0.5)
end
axis([-1 1 -1 1]);
set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1])
hline(0)
vline(0)





% load(folders(reply).name)
% 
% % extract variables
% 
% nb_steps = output.nb_steps;
% 
% % calculate arousal
% % -> weighted average
% 
% A = ((output.dir_freq + output.col_freq) ./ 2);
% 
% % calculte valence
% 
% % V = (output.right_dir - min(output.right_dir))...
% %     ./(max(output.right_dir) - min(output.right_dir)) - 0.5;
% 
% V = output.right_dir;
% 
% % plot figures
% figure
% subplot(8,1,1)
% plot(1:nb_steps,A(1:nb_steps));
% title('Arousal')
% subplot(8,1,2)
% plot(1:nb_steps,V(1:nb_steps))
% title('Valance')
% subplot(8,1,[4 8])
% scatter(V,A,'filled')
% title('V-A-Space')
% set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1])
% axis([-1 1 -1 1])
% hline(0)
% vline(0)
% subplot(8,1,3)
% plot(1:nb_steps,output.quadrant(1:nb_steps))
% title('Quadrant of the V-A-Space')
% 
% 
% load(folders(reply2).name)
% 
% % extract variables
% 
% nb_steps = output.nb_steps;
% 
% % calculate arousal
% % -> weighted average
% 
% A = ((output.dir_freq + output.col_freq) ./ 2);
% 
% % calculte valence
% 
% % V = (output.right_dir - min(output.right_dir))...
% %     ./(max(output.right_dir) - min(output.right_dir)) - 0.5;
% 
% V = output.right_dir;
% 
% % plot figures
% subplot(8,1,1)
% hold on
% plot(1:nb_steps,A(1:nb_steps),'r')
% subplot(8,1,2)
% hold on
% plot(1:nb_steps,V(1:nb_steps),'r')
% subplot(8,1,[4 8])
% hold on
% scatter(V,A,'r','filled')
% set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1])
% l = legend(folders(reply2).name,folders(reply).name,'Location','BestOutside');
% set(l, 'Interpreter', 'none')
% subplot(8,1,3)
% hold on
% plot(1:nb_steps,output.quadrant(1:nb_steps),'r')
