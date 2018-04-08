class_set = {'blues','classical','metal','pop','country','disco','hiphop','jazz','reggae','rock'};
dataSet = [];
for counter = 0:9
    filename = strcat(class_set(2),'/',class_set(2),'.0000',string(counter),'.au');
    [y, Fs] = audioread(filename{1});
    y = y(1:660000);
    dataSet = [dataSet;y'];
end
for counter = 10:99
    filename = strcat(class_set(2),'/',class_set(2),'.000',string(counter),'.au');
    [y, Fs] = audioread(filename{1});
    y = y(1:660000);
    dataSet = [dataSet;y'];
end

save('classicalDataSet','dataSet')
