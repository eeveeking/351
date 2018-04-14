%% Read Data
load('bluesDataSet.mat')
bluesDataSet = dataSet;
load('metalDataSet.mat')
metalDataSet = dataSet;
load('classicalDataSet.mat')
classicalDataSet = dataSet;
load('jazzDataSet.mat')
jazzDataSet = dataSet;
Fs = 22050;
addpath(genpath('mfcc'));
%% MFCC setting
Tw = 25;
Ts = 10;
alpha = 0.95;
R = [ 300 3700 ];  % frequency range to consider
M = 20;            % number of filterbank channels
C = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
allDataSet = [bluesDataSet(1:80,:);metalDataSet(1:80,:);classicalDataSet(1:80,:);jazzDataSet(1:80,:)];
testDataSet = [bluesDataSet(81:100,:);metalDataSet(81:100,:);classicalDataSet(81:100,:);jazzDataSet(81:100,:)];

test_num = 80;
test_correct = 0;
label = zeros(1,80);
k = 160;

for i = 1:80
    i
    distance = zeros(1,320);
    [MFCC1,~,~] = mfcc(testDataSet(i,:), Fs, Tw, Ts, alpha, hamming, R, M, C, L );
    for j = 1:320
        if rem(j,20) == 0
            j
        end
        [MFCC2,~,~] = mfcc(allDataSet(j,:), Fs, Tw, Ts, alpha, hamming, R, M, C, L );
        distance(j) = getDistance(MFCC1,MFCC2);
    end
    label(i) = getKnn(distance,k);
    label(i)
    if label(i) == ceil(i/20)
        test_correct = test_correct + 1;
    end
    acc = test_correct / test_num
end

acc = test_correct / test_num



