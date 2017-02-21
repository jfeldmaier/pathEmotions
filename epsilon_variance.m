
epsilons = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9];

for i = 1:length(epsilons)
    epsilon = epsilons(i);
    save('tmp_eps','epsilon')
    
    MazeDemo( 20 )
    
end


folders = dir('output_a_*');
% sort by date
[~, idx] = sort([folders.datenum]);
folders = folders(idx);

k = 0;

% rename files
for i = 1:length(folders)
    movefile(folders(i).name, [folders(i).name, '.mat'])
    k = k + 1;
end

disp([num2str(k) ' files renamed...'])


%plot figure

figure
cmap = colormap(jet);
cmap = cmap(30:-1:1,:);

if length(cmap) > (length(folders)-2)
    m = length(cmap) / (length(folders)-2);
    c = 1 - m;
else
    m = (length(cmap)-1) / (length(folders)-1);
    c = 1 - m;
end
    
counter = 1;

for i = 1:length(folders)
    
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
    counter = counter + 1;
%     pause(1)
end
axis([-1 1 -1 1]);
set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1])
hline(0)
vline(0)