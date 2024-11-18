function trials = get_trials(session, channel, unit, fold, type)
% Get trials of specific neuron
%
% Parameters
% ----------
%
% - fold: integer scalar
%   Fold number
% - type: char vector
% - Contains 'trn', 'crs', or 'tst'
%
% Returns
% -------
% - resp: 2D matrix
%   (trial x time) response

result = load_result(session, channel, unit, fold);

trials = [];

% train
if contains(type, {'trn', 'train', 'all'})
    trials = [trials, result.trials.trn_indices];
end
% validation
if contains(type, {'crs', 'val', 'validation', 'all'})
    trials = [trials, result.trials.crs_indices];
end
% test
if contains(type, {'tst', 'test', 'all'})
    trials = [trials, result.trials.tst_indices];
end

end