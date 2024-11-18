function resp = get_resp(session, channel, unit, fold)
% Get true responses of specific neuron
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
%   (trial x time) response

result = load_result(session, channel, unit, fold);
resp = result.resp;
end