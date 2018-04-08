function MFCC_mean = mfcc_analysis(wave, Fs)
    wave = wave(round(size(wave,1)*0.25):round(size(wave,1)*0.75));
    addpath(genpath('mfcc'));
    Tw = 25;
    Ts = 10;
    alpha = 0.95;
    R = [ 300 3700 ];  % frequency range to consider
    M = 20;            % number of filterbank channels
    C = 13;            % number of cepstral coefficients
    L = 22;            % cepstral sine lifter parameter
    hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
    [ MFCC, FBE, frames ] = mfcc(wave, Fs, Tw, Ts, alpha, hamming, R, M, C, L );
    MFCC_mean = mean(MFCC,2);
end