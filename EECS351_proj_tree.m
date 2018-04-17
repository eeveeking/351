%% Read Data
load('bluesDataSet.mat')
bluesDataSet = dataSet;
load('classicalDataSet.mat')
classicalDataSet = dataSet;
load('metalDataSet.mat')
metalDataSet = dataSet;
load('popDataSet.mat')
popDataSet = dataSet;
load('countryDataSet.mat')
countryDataSet = dataSet;
load('discoDataSet.mat')
discoDataSet = dataSet;
load('jazzDataSet.mat')
jazzDataSet = dataSet;

bluesResult = [];
classicalResult = [];
metalResult = [];
popResult = [];
discoResult = [];
jazzResult = [];

mfcc_blues = [];
mfcc_classical = [];
mfcc_metal = [];
mfcc_pop = [];
mfcc_disco = [];

blueslabel = ones(100,1);
classicallable = ones(100,1)*2;
metallabel = ones(100,1)*3;
poplable = ones(100,1)*4;
discolabel = ones(100,1)*5;
jazzlabel = ones(100,1)*6;

lpc_blues = ones(100,5);
lpc_classical = ones(100,5);
lpc_metal = ones(100,5);
lpc_pop = ones(100,5);
lpc_disco = ones(100,5);
lpc_jazz = ones(100,5);

Fs = 22050;

for i = 1:100
    %% Spectral centroid
    [C,CM1,CSTD,CMAX] = SpecCentroid(bluesDataSet(i,:),Fs);
    [C,CM2,CSTD,CMAX] = SpecCentroid(classicalDataSet(i,:),Fs);
    [C,CM3,CSTD,CMAX] = SpecCentroid(metalDataSet(i,:),Fs);
    [C,CM4,CSTD,CMAX] = SpecCentroid(popDataSet(i,:),Fs);
    [C,CM5,CSTD,CMAX] = SpecCentroid(discoDataSet(i,:),Fs);
    [C,CM6,CSTD,CMAX] = SpecCentroid(jazzDataSet(i,:),Fs);
    %% ZCR
    zcr1 = ZCR(bluesDataSet(i,:));
    zcr2 = ZCR(classicalDataSet(i,:));
    zcr3 = ZCR(metalDataSet(i,:));
    zcr4 = ZCR(popDataSet(i,:));
    zcr5 = ZCR(discoDataSet(i,:));
    zcr6 = ZCR(jazzDataSet(i,:));
    %% STE
    ste1 = mean(STE(bluesDataSet(i,:),201));
    ste2 = mean(STE(classicalDataSet(i,:),201));
    ste3 = mean(STE(metalDataSet(i,:),201));
    ste4 = mean(STE(popDataSet(i,:),201));
    ste5 = mean(STE(discoDataSet(i,:),201));
    ste6 = mean(STE(jazzDataSet(i,:),201));
    %% Spectral flux
    spec_blue = FeatureSpectralFlux(abs(spectrogram(bluesDataSet(i,:))), Fs);
    % spec_blue1 = FeatureSpectralRolloff(spectrogram(bluesDataSet(i,:)), Fs);
    spec_classical = FeatureSpectralFlux(abs(spectrogram(classicalDataSet(i,:))), Fs);
    % spec_classical1 = FeatureSpectralRolloff(spectrogram(classicalDataSet(i,:)), Fs);
    spec_metal = FeatureSpectralFlux(abs(spectrogram(metalDataSet(i,:))), Fs);
    % spec_metal1 = FeatureSpectralRolloff(spectrogram(metalDataSet(i,:)), Fs);
    spec_pop = FeatureSpectralFlux(abs(spectrogram(popDataSet(i,:))), Fs);
    % spec_pop1 = FeatureSpectralRolloff(spectrogram(popDataSet(i,:)), Fs);
    spec_disco = FeatureSpectralFlux(abs(spectrogram(discoDataSet(i,:))), Fs);
    % spec_disco1 = FeatureSpectralRolloff(spectrogram(discoDataSet(i,:)), Fs);
    spec_jazz = FeatureSpectralFlux(abs(spectrogram(jazzDataSet(i,:))), Fs);
    bluesResult = [bluesResult; [CM1,zcr1,ste1,spec_blue]];
    classicalResult = [classicalResult; [CM2,zcr2,ste2,spec_classical]];
    metalResult = [metalResult; [CM3,zcr3,ste3,spec_metal]];
    popResult = [popResult; [CM4,zcr4,ste4,spec_pop]];
    discoResult = [discoResult; [CM5,zcr5,ste5,spec_disco]];
    jazzResult = [jazzResult; [CM6,zcr6,ste6,spec_jazz]];
    i
end

%% MFCC
% for i = 1:100
%     mfcc_blues = [mfcc_blues; (mfcc_analysis(bluesDataSet(i,:)', Fs))'];
%     mfcc_classical = [mfcc_classical; (mfcc_analysis(classicalDataSet(i,:)', Fs))'];
%     mfcc_metal = [mfcc_metal; (mfcc_analysis(metalDataSet(i,:)', Fs))'];
%     mfcc_pop = [mfcc_pop; (mfcc_analysis(popDataSet(i,:)', Fs))'];
%     mfcc_disco = [mfcc_disco; (mfcc_analysis(discoDataSet(i,:)', Fs))'];
%     i
% end
%% LPC
for i = 1:100
    a = lpc(bluesDataSet(i,:),5);
    lpc_blues(i,:) = a(2:6);
    b = lpc(classicalDataSet(i,:),5);
    lpc_classical(i,:) = b(2:6);
    c = lpc(metalDataSet(i,:),5);
    lpc_metal(i,:) = c(2:6);
    d = lpc(popDataSet(i,:),5);
    lpc_pop(i,:) = d(2:6);
    e = lpc(discoDataSet(i,:),5);
    lpc_disco(i,:) = e(2:6);
    f = lpc(jazzDataSet(i,:),5);
    lpc_jazz(i,:) = f(2:6);
    i
end

%treeResult = [[bluesResult mfcc_blues lpc_blues];[classicalResult mfcc_classical lpc_classical];...
%    [metalResult mfcc_metal lpc_metal];...
%[popResult mfcc_pop lpc_pop];[discoResult mfcc_disco lpc_disco]];

treeResult = [[classicalResult lpc_classical];...
   [metalResult lpc_metal];...
[popResult lpc_pop];[jazzResult lpc_jazz]];

treelabel = [classicallable; metallabel; poplable; jazzlabel];

tree = fitctree(treeResult, treelabel,'CrossVal','on');

view(tree.Trained{1},'Mode','graph')

kfoldLoss(tree)
predict_label = kfoldPredict(tree);

% sum(predict_label(1:100,:) == 2)
% sum(predict_label(101:200,:) == 2)
% sum(predict_label(201:300,:) == 2)
% sum(predict_label(301:400,:) == 2)
% 
% sum(predict_label(1:100,:) == 3)
% sum(predict_label(101:200,:) == 3)
% sum(predict_label(201:300,:) == 3)
% sum(predict_label(301:400,:) == 3)
% 
% sum(predict_label(1:100,:) == 4)
% sum(predict_label(101:200,:) == 4)
% sum(predict_label(201:300,:) == 4)
% sum(predict_label(301:400,:) == 4)
% 
% sum(predict_label(1:100,:) == 6)
% sum(predict_label(101:200,:) == 6)
% sum(predict_label(201:300,:) == 6)
% sum(predict_label(301:400,:) == 6)


