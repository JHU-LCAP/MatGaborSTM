% =========================================================================
% Example: Compute the Modulation Power Spectrum (MPS) / Modulation Response Function (MRF)
%
% Author: Huet, M.-Ph., & Elhilali, M.
% Email:  mphuet@jhu.edu
% Date:   2025-07-16
% Update: 2026-04-25
%
% Description:
% This script computes the MPS from an acoustic waveform or the MRF from a 
% reconstructed spectrogram. 
%
% If you use this code, please cite the following paper:
%
% Huet, M.-P., & Elhilali, M. (2025). 
% The shape of attention: How cognitive goals sculpt cortical representation of speech.
% bioRxiv. https://doi.org/10.1101/2025.05.22.655464
% =========================================================================

clear; close all; clc;
%% 1. Parameters

% SPECTROGRAM
FMIN = 125;                % Minimum frequency for the spectrogram
FMAX = 8000;               % Maximum frequency
CHANPEROCTAVES = 16;       % Channels per octave
DOWNFS = 100;              % Target sampling rate for modulation

% STM
MIN_RATE = -1; 
MAX_RATE = 5; 
STEP_RATE = 0.25;
MIN_SCALE = -1;
MAX_SCALE = 2;
STEP_SCALE = 0.25;

%% 2. Load audio

audio_file = 'example/audio.wav';

[x, fs] = audioread(audio_file);
x = mean(x, 2);                         % Mono mix
x = (x - mean(x)) / std(x);             % Normalize
x = x / max(abs(x)) * 0.98;             % Avoid clipping

%% 3. Compute and plot spectrogram

[y, time, freqs] = GetSpectrogram(x, fs, FMIN, FMAX, CHANPEROCTAVES);
tmin = length(y)/fs;

figure;
PlotSpectrogram(y, time, freqs);
title('Spectrogram');

% Resample spectrogram along time axis for computational efficiency
y = resample(y, DOWNFS, fs);  
time = (0:length(y)-1) / DOWNFS;

%% 4. Compute and plot the spectrotemporal modulation profile

[omegas_t, omegas_f] = GetOmegas([MIN_RATE, MAX_RATE, STEP_RATE],[MIN_SCALE, MAX_SCALE, STEP_SCALE], DOWNFS, FMIN, FMAX, CHANPEROCTAVES, tmin);

STM = GetRS(y, DOWNFS, freqs, omegas_t, omegas_f);
STM = PermuteFold(STM, omegas_t, omegas_f);

figure;
PlotRS(STM, omegas_t, omegas_f, 'STM profile for audio');
