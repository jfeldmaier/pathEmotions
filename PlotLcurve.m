function [ output_args ] = PlotLcurve( resdir, resdir2, nb_eps, nb_rep)

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
tmp_lcurve = mean(tmp_lcurve,1);

plot(tmp_lcurve, 'LineWidth', 2);
xlim([1 nb_eps]);

if not(isempty(resdir2))
    
    
    clear A V averageVA counter
    
    folders = dir([resdir2 'l_curve*']);
    % sort by date
    [~, idx] = sort([folders.datenum]);
    folders = folders(idx);
    
    for  i = 1:nb_rep
        load([resdir2 folders(i).name])
        tmp_lcurve(i,:) = l_curve(2,:);
    end
    hold on
    tmp_lcurve = mean(tmp_lcurve,1);
    
    plot(tmp_lcurve, 'LineWidth', 2);
    legend('Experiment 1','Experiment 2')
    xlim([1 nb_eps]);
end

hold off


end

