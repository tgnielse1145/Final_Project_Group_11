function dll = get_dll(session, channel, unit, fold, trials, times)
% Get true delta log-likelihood of specific neuron
%
% Parameters
% ----------
%
% - fold: integer scalar
%   Fold number
% - trials: vector
%   Trial indeces
% - times: vector
%   Time of study
%
% Returns
% -------
% - dll: scalar
%   Delta log-likelihood

r = get_resp(session, channel, unit, fold);

if nargin < 5
    trials = get_trials(session, channel, unit, fold, 'test');
end
if nargin < 6
    times = 1:size(r, 2);
end

r = r(trials, times);

fr = get_s_fr(session, channel, unit, fold);
fr = fr(trials, times);
fr = fr / 1000 + epsilon;

fr0 = get_fr0(session, channel, unit, fold);
fr0 = fr0(trials, times);
fr0 = fr0 / 1000 + epsilon;

dll = sum(r .* log(fr ./ fr0) - fr + fr0, 'all') / sum(r, 'all');
end