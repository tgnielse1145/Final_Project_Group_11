function fr0 = get_fr0(session, channel, unit, fold)
    % Get firing rate of null model
    %
    % Parameters
    % ----------
    %
    % - fold: integer scalar
    %   Fold number
    %
    % Returns
    % -------
    % - fr0: scalar
    %   null firing rate

    r = get_resp(session, channel, unit, fold);

    trials = get_trials(session, channel, unit, fold, 'trn, crs');
    fr0 = mean(r(trials, :), 'all') * 1000 * ones(size(r));
end

function fr0 = get_fr0_old(session, channel, unit, fold)
    % Get firing rate of null model
    %
    % Parameters
    % ----------
    %
    % - fold: integer scalar
    %   Fold number
    %
    % Returns
    % -------
    % - fr0: scalar
    %   null firing rate
    
    % todo: notfair: by this definition the null model is as bad as smodel
    % without stimulus kernel (i.e. fr = smodel(s), if s = 0)

    [a, b] = get_nonlin_params(session, channel, unit, fold);

    [~, psk, off] = get_s_knls(session, channel, unit, fold);

    r = get_resp(session, channel, unit, fold);

    fr0 = zeros(size(r));
    for i = 1:size(r, 1)
        fr0(i, :) = a * logsig(conv(r(i, :), psk, 'same') + off + b);
    end
end
