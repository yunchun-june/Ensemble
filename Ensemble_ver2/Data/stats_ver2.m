clear all;
close all;

    % RESULT TEXT FILE
    % 1 TRIALNO
    % 2 cond  1:all negative 5:all positive
    % 3 faces for group faces
    % 4 face use for emotion judgement
	% 5 emotion judgement
    % 6 is break trials

files = dir( 'Ensem_result_*.txt');
num = length(files);

dataset = cell(5,16);
average = zeros(5,16);
sd = zeros(5,16);

for filenum = 1:num
    
    [trial cond ensFace testFace judgement noBreak]= textread(files(filenum).name,'%d %d %d %d %d %d ');
    
    datasetPax = cell(5,16);
    averagePax = zeros(16,1);
    sdPax = zeros(16,1);
    
    % put data into dataset
    for i=1:length(trial)
        if ~noBreak(i),
            datasetPax{cond(i),testFace(i)}(end+1) = judgement(i);
        end
    end
    
    % compute mean, std for each condition
      
      
        for j = 1:16
            datasetFace = [];  
            for i = 1:5
                for z = 1:length(datasetPax{i,j})
                    datasetFace(end+1) = datasetPax{i,j}(z);
                end
            end
            averagePax(j) = mean(datasetFace);
            sdPax(j) = std(datasetFace);
        end
    
    %normalize data
    for i = 1:5
        for j = 1:16
            datasetFace = [];  
            for z = 1:length(datasetPax{i,j})
                if(sdPax(j) ~= 0)
                dataset{i,j}(end+1) = ( datasetPax{i,j}(z) - averagePax(j) )/sdPax(j); end
                if(sdPax(j) == 0)
                    dataset{i,j}(end+1) = datasetPax{i,j}(z) - averagePax(j); end
            end
        end
    end
    
end

    for i=1:5
        for j=1:16
           average(i,j) = mean(dataset{i,j});
        end
    end

    
    for i=1:5
        for j=1:16
           sd(i,j) = std(dataset{i,j});
        end
    end

    overAllMean = zeros(5,1);
    overAllStd = zeros(5,1);
    
    for i=1:5
        overAllMean(i) = mean(average(i,1:16));
        overAllStd(i) = std(average(i,1:16));
    end
    
    disp('top row: all negative faces, buttom row: all positive faces');
    disp('-----stats for all 16 faces-----');
    disp('[average]');
    disp(average);
    disp('[std]');
    disp(sd);
    disp('-------------overall--------------')
    disp('[average]');
    disp(overAllMean);
    disp('[std]');
    disp(overAllStd);

