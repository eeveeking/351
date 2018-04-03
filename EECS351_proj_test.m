[y, Fs] = audioread('metal/metal.00003.au');
player = audioplayer(y, Fs);
play(player)
y = y(round(size(y,1)*0.25):round(size(y,1)*0.75));
addpath(genpath('mfcc'));
Tw = 25;
Ts = 10;
alpha = 0.95;
R = [ 300 3700 ];  % frequency range to consider
M = 20;            % number of filterbank channels
C = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
[ MFCC, FBE, frames ] = mfcc(y, Fs, Tw, Ts, alpha, hamming, R, M, C, L );
MFCC_mean = mean(MFCC,2);