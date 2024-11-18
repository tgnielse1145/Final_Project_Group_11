function [session, channel, unit] = get_id_parts(id)
    % Get neuron's IDs
    %
    % Parameters
    % ----------
    % - id: char vector
    %   Neuron's ID
    %
    % Returns
    % ----------
    % - session: scalar
    %   Session number with format: yymmdd
    % - channel: scalar
    %   Channel number
    % - unit: scalar
    %   Unit number

    session = str2double(id(1:6));
    channel = str2double(id(7:8));
    unit = str2double(id(9:10));
end