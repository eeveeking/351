%% Read Data
load('bluesDataSet.mat')
bluesDataSet = dataSet;
% load('classicalDataSet.mat')
% classicalDataSet = dataSet;
load('metalDataSet.mat')
metalDataSet = dataSet;
% load('popDataSet.mat')
% popDataSet = dataSet;
% load('countryDataSet.mat')
% countryDataSet = dataSet;
load('discoDataSet.mat')
discoDataSet = dataSet;

bluesResult = [];
classicalResult = [];
metalResult = [];
popResult = [];
discoResult = [];
for i = 1:100
    %% Spectral centroid
    [C,CM1,CSTD,CMAX] = SpecCentroid(bluesDataSet(i,:),Fs);
%     [C,CM2,CSTD,CMAX] = SpecCentroid(classicalDataSet(i,:),Fs);
    [C,CM3,CSTD,CMAX] = SpecCentroid(metalDataSet(i,:),Fs);
%     [C,CM4,CSTD,CMAX] = SpecCentroid(popDataSet(i,:),Fs);
    [C,CM5,CSTD,CMAX] = SpecCentroid(discoDataSet(i,:),Fs);
    %% ZCR
    zcr1 = ZCR(bluesDataSet(i,:));
%     zcr2 = ZCR(classicalDataSet(i,:));
    zcr3 = ZCR(metalDataSet(i,:));
%     zcr4 = ZCR(popDataSet(i,:));
    zcr5 = ZCR(discoDataSet(i,:));
    %% STE
    ste1 = mean(STE(bluesDataSet(i,:),201));
%     ste2 = mean(STE(classicalDataSet(i,:),201));
    ste3 = mean(STE(metalDataSet(i,:),201));
%     ste4 = mean(STE(popDataSet(i,:),201));
    ste5 = mean(STE(discoDataSet(i,:),201));
    bluesResult = [bluesResult; [CM1,zcr1,ste1]];
%     classicalResult = [classicalResult; [CM2,zcr2,ste2]];
    metalResult = [metalResult; [CM3,zcr3,ste3]];
%     popResult = [popResult; [CM4,zcr4,ste4]];
    discoResult = [discoResult; [CM5,zcr5,ste5]];
end

kmeansResult = [bluesResult;metalResult;discoResult];
k = 3;
for i = 1:3
    kmeansResult(:,i) = kmeansResult(:,i) / max(kmeansResult(:,i));
end

idx = kmeans(kmeansResult,k);



