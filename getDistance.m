function dist = getDistance(MFCC1,MFCC2)
mean1 = mean(MFCC1,2);
mean1 = mean1(2:13);
mean2 = mean(MFCC2,2);
mean2 = mean2(2:13);
% cov1 = cov(mean1);
% cov2 = cov(mean2);
cov1 = cov(MFCC1(2:13,:)');
cov2 = cov(MFCC2(2:13,:)');
dist = log(det(cov2)/det(cov1)) + trace(cov2\cov1) + (mean1-mean2)'*inv(cov2)*(mean1-mean2) - 12; % d = 12
dist = dist + log(det(cov1)/det(cov2)) + trace(cov1\cov2) + (mean2-mean1)'*inv(cov1)*(mean2-mean1) - 12;% d = 12
dist = dist / 2;
end