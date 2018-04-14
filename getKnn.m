function label = getKnn(distance, k)
[~, idx] = sort(distance);
idx = idx(1:k);
cat1 = size(find(idx<=80),2);
cat2 = size(find(idx>80 & idx<=160),2);
cat3 = size(find(idx>160 & idx<=240),2);
cat4 = size(find(idx>240 & idx<=320),2);
result = [cat1,cat2,cat3,cat4];
[~,label] = max(result);
end