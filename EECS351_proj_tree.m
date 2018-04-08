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

bluesResult = [];
classicalResult = [];
metalResult = [];
popResult = [];
discoResult = [];

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

lpc_blues = ones(100,5);
lpc_classical = ones(100,5);
lpc_metal = ones(100,5);
lpc_pop = ones(100,5);
lpc_disco = ones(100,5);

Fs = 22050;

for i = 1:100
    %% Spectral centroid
    [C,CM1,CSTD,CMAX] = SpecCentroid(bluesDataSet(i,:),Fs);
    [C,CM2,CSTD,CMAX] = SpecCentroid(classicalDataSet(i,:),Fs);
    [C,CM3,CSTD,CMAX] = SpecCentroid(metalDataSet(i,:),Fs);
    [C,CM4,CSTD,CMAX] = SpecCentroid(popDataSet(i,:),Fs);
    [C,CM5,CSTD,CMAX] = SpecCentroid(discoDataSet(i,:),Fs);
    %% ZCR
    zcr1 = ZCR(bluesDataSet(i,:));
    zcr2 = ZCR(classicalDataSet(i,:));
    zcr3 = ZCR(metalDataSet(i,:));
    zcr4 = ZCR(popDataSet(i,:));
    zcr5 = ZCR(discoDataSet(i,:));
    %% STE
    ste1 = mean(STE(bluesDataSet(i,:),201));
    ste2 = mean(STE(classicalDataSet(i,:),201));
    ste3 = mean(STE(metalDataSet(i,:),201));
    ste4 = mean(STE(popDataSet(i,:),201));
    ste5 = mean(STE(discoDataSet(i,:),201));
    bluesResult = [bluesResult; [CM1,zcr1,ste1]];
    classicalResult = [classicalResult; [CM2,zcr2,ste2]];
    metalResult = [metalResult; [CM3,zcr3,ste3]];
    popResult = [popResult; [CM4,zcr4,ste4]];
    discoResult = [discoResult; [CM5,zcr5,ste5]];
    i
end

%% MFCC
for i = 1:100
    mfcc_blues = [mfcc_blues; (mfcc_analysis(bluesDataSet(i,:)', Fs))'];
    mfcc_classical = [mfcc_classical; (mfcc_analysis(classicalDataSet(i,:)', Fs))'];
    mfcc_metal = [mfcc_metal; (mfcc_analysis(metalDataSet(i,:)', Fs))'];
    mfcc_pop = [mfcc_pop; (mfcc_analysis(popDataSet(i,:)', Fs))'];
    mfcc_disco = [mfcc_disco; (mfcc_analysis(discoDataSet(i,:)', Fs))'];
    i
end
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
end

%treeResult = [[bluesResult mfcc_blues lpc_blues];[classicalResult mfcc_classical lpc_classical];...
%    [metalResult mfcc_metal lpc_metal];...
%[popResult mfcc_pop lpc_pop];[discoResult mfcc_disco lpc_disco]];

treeResult = [[classicalResult lpc_classical];...
   [metalResult lpc_metal];...
[popResult lpc_pop];[discoResult lpc_disco]];

treelabel = [classicallable; metallabel; poplable; discolabel];

tree = fitctree(treeResult, treelabel,'CrossVal','on');

view(tree.Trained{1},'Mode','graph')

kfoldLoss(tree)
