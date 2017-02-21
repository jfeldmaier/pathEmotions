% Perform 10 runs of the same experiment

resdir = 'exp1/';

nb_eps = 20;
nb_rep = 49;


% for i = 1:nb_rep
%     MazeDemo(nb_eps)
% end



% Evaluation

clear A V averageVA counter

folders = dir([resdir 'l_curve*']);
% sort by date
[~, idx] = sort([folders.datenum]);
folders = folders(idx);

for  i = 1:nb_rep
    load([resdir folders(i).name])
    
    tmp_lcurve(i,:) = l_curve(2,:);
    
       
end
figure
tmp_lcurve = mean(tmp_lcurve,1);

plot(tmp_lcurve,'b');
xlim([1 nb_eps]);

resdir = 'exp2/';

nb_eps = 20;
nb_rep = 50;


% for i = 1:nb_rep
%     MazeDemo(nb_eps)
% end



% Evaluation

clear A V averageVA counter

folders = dir([resdir 'l_curve*']);
% sort by date
[~, idx] = sort([folders.datenum]);
folders = folders(idx);

for  i = 1:nb_rep
    load([resdir folders(i).name])
    
    tmp_lcurve(i,:) = l_curve(2,:);
    
       
end
hold on
tmp_lcurve = mean(tmp_lcurve,1);

plot(tmp_lcurve,'r');
legend('Experiment 1','Experiment 2')
xlim([1 nb_eps]);
hold off