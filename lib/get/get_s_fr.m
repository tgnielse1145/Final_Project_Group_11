function fr = get_s_fr(session, channel, unit, fold)
% Get firing rate of specific s-model
%
% Parameters
% ----------
%
% - fold: integer scalar
%   Fold number
%
% Returns
% -------
% - resp: 2D matrix
%   (trial x time) firing rate

result = load_result(session, channel, unit, fold);
fr = result.fr;
end