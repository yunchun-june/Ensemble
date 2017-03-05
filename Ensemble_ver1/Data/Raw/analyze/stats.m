clear all;
close all;

    % RESULT TEXT FILE
    % 1 TRIALNO
    % 2 cond  1:all negative 5:all positive
    % 3 testface 1:sadest face 7:happy face
    % 4 stimuli face used
    % 5 test face used
    % 6 percieved emotion
    % 7 there are faces seen

files = dir( 'Ensem_result_*.txt');
num = length(files);

dataset = cell(5,7);
average = zeros(5,7);
sd = zeros(5,7);

for filenum = 1:num
    
    [trial cond faceIdx ensFace testFace judgement noBreak]= textread(files(filenum).name,'%d %d %d %d %d %d %d ');

    dataPax = cell(5,7);
    meanPax = [0 0 0 0 0 0 0];
    sdPax = [0 0 0 0 0 0 0];
    
    for i=1:length(trial)
        if ~noBreak(i),
            dataPax{cond(i),faceIdx(i)} (end+1) = judgement(i);
        end
    end
    
    for i=1:7
        for j=1:5
            meanPax(i) = meanPax(i) + mean(dataPax{j,i})/5;
            sdPax(i) = sdPax(i)+std(dataPax{j,i})/5;
        end
    end
    
    
    
    for i= 1:5
        for j=1:7
            for k=1:size(dataPax{i,j});
                dataset{i,j}(end+1) = (dataPax{i,j}(k)-meanPax(j))/sdPax(j);
            end
        end
    end
    
end

    for i=1:5
        for j=1:7
           average(i,j) = mean(dataset{i,j});
        end
    end

    
    for i=1:5
        for j=1:7
           sd(i,j) = std(dataset{i,j});
        end
    end

    disp(average)
    disp(sd)

    figure
    for i=1:5
       scatter(1:7,average(i,:),i);
       hold on;
    end
