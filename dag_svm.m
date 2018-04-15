load('treeResult.mat')
index_train = cat(2, 1:80, 101:180, 201:280, 301:380);
index_test = cat(2, 81:100, 181:200, 281:300, 381:400);
tree_result_train = treeResult(index_train',:);
tree_result_test = treeResult(index_test',:);

classicallable = ones(80,1)*0;
metallabel = ones(80,1)*1;
poplable = ones(80,1)*2;
jazzlabel = ones(80,1)*3;

treelabel_train = [classicallable; metallabel; poplable; jazzlabel];
pred = svm_dag(tree_result_train, treelabel_train, tree_result_test, 6);
sum(pred(1:20) == 0)
sum(pred(21:40) == 1)
sum(pred(41:60) == 2)
sum(pred(61:80) == 3)