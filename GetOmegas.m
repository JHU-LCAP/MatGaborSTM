% =========================================================================%
% Author: MP Huet (mphuet@jhu.edu)
% If used, please cite:
% Huet & Elhilali (2025), bioRxiv, https://doi.org/10.1101/2025.05.22.655464
% =========================================================================
function [omegas_t, omegas_f, params] = GetOmegas(rate_params, scale_params, FS, FMIN, FMAX, NCHAN, TMIN)
% GETOMEGAS Create temporal and spectral modulation axes for MPS/MRF analysis.
%
% Minimal use:
%   [omegas_t, omegas_f] = GetOmegas(rate_params, scale_params)
%
% Recommended use:
%   [omegas_t, omegas_f, params] = GetOmegas(rate_params, scale_params, FS, FMIN, FMAX, NCHAN, TMIN)
%
% Inputs:
%   rate_params  = [MIN_RATE, MAX_RATE, STEP_RATE] in log2(Hz)
%   scale_params = [MIN_SCALE, MAX_SCALE, STEP_SCALE] in log2(cycles/octave)
%   TMIN         = shortest signal duration in seconds
%   FS           = spectrogram sampling rate in Hz
%   FMIN         = minimum acoustic frequency in Hz
%   FMAX         = maximum acoustic frequency in Hz
%   NCHAN        = number of spectrogram frequency channels
%
% Outputs:
%   omegas_t     = temporal modulation rates in Hz
%   omegas_f     = spectral modulation scales in cycles/octave
%   params       = corrected log2 parameters

NCYCLE = 2;

MIN_RATE  = rate_params(1);
MAX_RATE  = rate_params(2);
STEP_RATE = rate_params(3);

MIN_SCALE  = scale_params(1);
MAX_SCALE  = scale_params(2);
STEP_SCALE = scale_params(3);

has_limits = nargin >= 7 && ...
             ~isempty(FS) && ~isempty(FMIN) && ~isempty(FMAX) && ...
             ~isempty(NCHAN) && ~isempty(TMIN);

if ~has_limits
    warning(['No signal/spectrogram constraints provided. ' ...
             'Axes generated without automatic checks. To avoid aliasing, use ' ...
             'MAX_RATE < FS/2 and MAX_SCALE < NCHAN/2; minimum rates/scales should allow >=2 cycles.']);
else
    % ---------------------------------------------------------------------
    % Temporal rate limits
    % ---------------------------------------------------------------------

    min_rate_recommended = NCYCLE / TMIN;
    max_rate_recommended = FS / 2;

    if 2^MIN_RATE < min_rate_recommended
        new_MIN_RATE = ceil(log2(min_rate_recommended) / STEP_RATE) * STEP_RATE;

        warning(['[MPS] MIN_RATE too low: %.3f log2 Hz (%.3f Hz).\n' ...
                 'Recommended minimum is %.3f log2 Hz (%.3f Hz), based on %d cycles over %.3f s.\n' ...
                 'Using MIN_RATE = %.3f instead.'], ...
                 MIN_RATE, 2^MIN_RATE, ...
                 log2(min_rate_recommended), min_rate_recommended, NCYCLE, TMIN, ...
                 new_MIN_RATE);

        MIN_RATE = new_MIN_RATE;
    end

    if 2^MAX_RATE > max_rate_recommended
        new_MAX_RATE = floor(log2(max_rate_recommended) / STEP_RATE) * STEP_RATE;

        warning(['[MPS] MAX_RATE too high: %.3f log2 Hz (%.3f Hz).\n' ...
                 'Recommended maximum is %.3f log2 Hz (%.3f Hz), based on FS/4.\n' ...
                 'Using MAX_RATE = %.3f instead.'], ...
                 MAX_RATE, 2^MAX_RATE, ...
                 log2(max_rate_recommended), max_rate_recommended, ...
                 new_MAX_RATE);

        MAX_RATE = new_MAX_RATE;
    end

    % ---------------------------------------------------------------------
    % Spectral scale limits
    % ---------------------------------------------------------------------

    B_oct = log2(FMAX / FMIN);

    min_scale_recommended = NCYCLE / B_oct;
    max_scale_recommended = NCHAN / 2;

    if 2^MIN_SCALE < min_scale_recommended
        new_MIN_SCALE = ceil(log2(min_scale_recommended) / STEP_SCALE) * STEP_SCALE;

        warning(['[MPS] MIN_SCALE too low: %.3f log2 cyc/oct (%.3f cyc/oct).\n' ...
                 'Recommended minimum is %.3f log2 cyc/oct (%.3f cyc/oct), based on %d cycles over %.3f octaves.\n' ...
                 'Using MIN_SCALE = %.3f instead.'], ...
                 MIN_SCALE, 2^MIN_SCALE, ...
                 log2(min_scale_recommended), min_scale_recommended, NCYCLE, B_oct, ...
                 new_MIN_SCALE);

        MIN_SCALE = new_MIN_SCALE;
    end

    if 2^MAX_SCALE > max_scale_recommended
        new_MAX_SCALE = floor(log2(max_scale_recommended) / STEP_SCALE) * STEP_SCALE;

        warning(['[MPS] MAX_SCALE too high: %.3f log2 cyc/oct (%.3f cyc/oct).\n' ...
                 'Recommended maximum is %.3f log2 cyc/oct (%.3f cyc/oct), based on NCHAN/4.\n' ...
                 'Using MAX_SCALE = %.3f instead.'], ...
                 MAX_SCALE, 2^MAX_SCALE, ...
                 log2(max_scale_recommended), max_scale_recommended, ...
                 new_MAX_SCALE);

        MAX_SCALE = new_MAX_SCALE;
    end
end

% -------------------------------------------------------------------------
% Create modulation axes
% -------------------------------------------------------------------------

omegas_t = 2.^(MIN_RATE:STEP_RATE:MAX_RATE);
omegas_f = 2.^(MIN_SCALE:STEP_SCALE:MAX_SCALE);

params = struct();
params.MIN_RATE = MIN_RATE;
params.MAX_RATE = MAX_RATE;
params.STEP_RATE = STEP_RATE;
params.MIN_SCALE = MIN_SCALE;
params.MAX_SCALE = MAX_SCALE;
params.STEP_SCALE = STEP_SCALE;
params.NCYCLE = NCYCLE;
params.has_limits = has_limits;

end