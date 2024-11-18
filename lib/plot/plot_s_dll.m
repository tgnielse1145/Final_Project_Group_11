function plot_s_dll()
    % Plot delta log-likelihood of trained s-models
    %
    % Parameters
    % ----------
    %
    
    info = get_info();
    num_folds = info.num_folds;
    
    filename = fullfile(...
        info.folders.results, ...
        'dll.mat');
    
    if ~isfile(filename)
        ids = get_ids();
        num_neurons = numel(ids);
        
        dll_all = zeros(num_neurons, num_folds);
        dll_fix = zeros(num_neurons, num_folds);
        dll_sac = zeros(num_neurons, num_folds);
        
        parfor i = 1:num_neurons % todo: parfor
            id = ids{i};

            fprintf('%d - %s\n', i, id);
            
            [session, channel, unit] = get_id_parts(id);

            [dll_all(i, :), dll_fix(i, :), dll_sac(i, :)] = ...
                get_s_dll_for_one_neuron(session, channel, unit);
        end

        save(filename, 'dll_all', 'dll_fix', 'dll_sac');
    else
        load(filename, 'dll_all', 'dll_fix', 'dll_sac');
    end

    dll_all = mean(dll_all, 2);
    dll_fix = mean(dll_fix, 2);
    dll_sac = mean(dll_sac, 2);
    
    % plot
    create_figure('DLL');
    % - all
%     histogram(dllAll);
%     title(modelName);
%     ylabel('DLL');

    scatter(dll_fix, dll_sac, 'filled');
    
    hold('on');
    m = min(min(dll_sac), min(dll_fix));
    M = max(max(dll_sac), max(dll_fix));
    plot([m, M], [m, M], 'Color', 'red', 'LineStyle', '--', 'LineWidth', 1);
    hold('off');
    
    % title('Delta Log-Likelihood');
    xlabel('DLL [fix]');
    ylabel('DLL [sac]');
    
    set_axis();
    
    saveas(...
        gcf, ...
        fullfile(...
            info.folders.results, ...
            ['dll', info.plotting.formattype]));

end

function [dll_all, dll_fix, dll_sac] = get_s_dll_for_one_neuron(session, channel, unit)
    info = get_info();
    
    times = info.times;
    tmin = times(1);
    all_idx = times - tmin + 1;
    fix_idx = info.fix - tmin + 1;
    sac_idx = info.sac - tmin + 1;

    num_folds = info.num_folds;
    dll_all = nan(num_folds);
    dll_fix = nan(num_folds);
    dll_sac = nan(num_folds);
    
    for fold = 1:num_folds
        trials = get_trials(session, channel, unit, fold, 'test, validation');
        
        dll_all(fold) = get_dll(session, channel, unit, fold, trials, all_idx);
        dll_fix(fold) = get_dll(session, channel, unit, fold, trials, fix_idx);
        dll_sac(fold) = get_dll(session, channel, unit, fold, trials, sac_idx);
    end
end
