clear all;
close all;

    % RESULT TEXT FILE
    %1 trialnumver 
    %2 condition
    %3 stimuli face
    %4 testface
    %5 result
    %6 isBreakTrials
    %7 which staircase is used
    %8-11 where does it break
    %12-15 threshold presented

files = dir( 'Ensem_result_*.txt');
subjectnum = length(files);


% ======== Read in all data ====== %

    face_raw = cell(16);
    for subject = 1:length(files)
        [trial cond ensFace testFace judgement Break stairCase s1 s2 s3 s4 t1 t2 t3 t4]= textread(files(subject).name,'%d %d %d %d %d %d %d %d %d %d %d %f %f %f %f');
        before_dataPerSubject = cell(16);
        after_dataPerSubject = cell(16);
        
        for i=1:length(trial)
            if ~Break(i) %&& ensFace(i) == 2
                before_dataPerSubject{testFace(i)}(end+1) = judgement(i);
            end
        end
        
        % exclude outlier due based on subject's own std
        outlier_low = zeros(16);
        outlier_high = zeros(16);
        outlierStd= 2;
        for i = 1:16
            outlier_low(i) = mean(before_dataPerSubject{i}) - outlierStd * std(before_dataPerSubject{i});
            outlier_high(i) = mean(before_dataPerSubject{i}) + outlierStd * std(before_dataPerSubject{i});
        end
       
        for i=1:length(trial)
            if ~Break(i) && judgement(i)> outlier_low(testFace(i)) && judgement(i) < outlier_high(testFace(i))
                face_raw{testFace(i)}(end+1) = judgement(i);
            end
        end
    end
    
    % thershold for outlier
        threshold = 2.5;
        for i=1:16
            upperbound(i) = mean(face_raw{i}) + threshold *std(face_raw{i});
            lowerbound(i) = mean(face_raw{i}) - threshold *std(face_raw{i});
        end
    
 % ======== overall distribution ==== %       
        
        figure
        for j = 1:16
        x = -10:10;
        y = zeros(21);
        for i = 1:length(face_raw{j})
            index = face_raw{j}(i) +11;
            y(index) = y(index)+1;
        end
        subplot(4,4,j)
            plot(x,y);
            axis([-10,10,0,50]);
            stat = {['mean:' num2str(mean(face_raw{j})) '  std:' num2str(std(face_raw{j}))]};
            text(-8,45,stat);
            text(upperbound(j),5,'|');
            text(lowerbound(j),5,'|');
            ylabel('counts');
            xlabel('emotion score');
            title(['face No.' num2str(j) ]);

        end
        
%  % ======= compare with norming data =======%
%         
%         for j = 1:16
%             ourResult(j) =  mean(face_raw{j});
%         end
%         
%         figure
%         norming  =[-5,  -7.4,   4,  5.9, -4,  -6,5, 6.9,  -5.1,-7,5,7,-4,-5.8,3.9,6];
%         scatter(norming,ourResult);
%         xlabel('Norming Data');
%         ylabel('Experiment Result');
%         lsline;


%===== exclude outlier, normalization ======%
    dataset = cell(subjectnum,5,16);
    dataset_normed = cell(subjectnum,5,16);
    avg_unnormed = zeros(subjectnum,5,16);
    avg_normed = zeros(subjectnum,5,16);
    face_avg = zeros(subjectnum,16);
    face_std = zeros(subjectnum,16);

    for subject = 1:subjectnum

        [trial cond ensFace testFace judgement Break stairCase s1 s2 s3 s4 t1 t2 t3 t4]= textread(files(subject).name,'%d %d %d %d %d %d %d %d %d %d %d %f %f %f %f');


        % put data into dataset
        for i=1:length(trial)
            isOutlier = judgement(i)>upperbound(testFace(i)) || judgement(i)<lowerbound(testFace(i));
            if ~Break(i) && ~isOutlier %&& ensFace(i) == 2
                dataset{subject,cond(i),testFace(i)}(end+1) = judgement(i);
            end
        end

        % normalize data

            for j = 1:16
                temp = [];  
                for i = 1:5
                    for z = 1:length(dataset{subject,i,j})
                        temp(end+1) = dataset{subject,i,j}(z);
                    end
                end
                face_avg(subject,j) = nanmean(temp);
                face_std(subject,j) = nanstd(temp);
            end

        for i = 1:5
            for j = 1:16
                for z = 1:length(dataset{subject,i,j})
                    dataset_normed{subject,i,j}(z) = ( dataset{subject,i,j}(z) - face_avg(subject,j) )/face_std(subject,j);
                end
            end
        end
        

    end

    
% ====  average ====== %
        for i = 1:subjectnum
            for j = 1:5
                for k = 1:16
                    avg_normed(i,j,k) = nanmean(dataset_normed{i,j,k});
                    avg_unnormed(i,j,k) = nanmean(dataset{i,j,k});
                end
            end
        end

%==== result by subject =====%

    resultBySubject = zeros(5,subjectnum);
    for j=1:5
        for  i=1:subjectnum
           resultBySubject(j,i) = nanmean(avg_normed(i,j,:));
        end
    end
    
    disp('-------result by subjects---------');
    disp(resultBySubject);

%==== result by faces =====%

    resultByFaces = zeros(5,subjectnum);
    for j=1:5
        for  i = 1:16
           resultByFaces(j,i) = nanmean(avg_normed(:,j,i));
        end
    end
    
    disp('-------result by faces---------');
    disp(resultByFaces);   

    
    for i=1:5
        for j=1:16
           sd(i,j) = std(dataset{i,j});
        end
    end

    
%==== over all result =====%    
    overAllMean = zeros(5,1);
    overAllStd = zeros(5,1);
    
%     for j = 1:5        
%         overAllMean(j) = nanmean(resultByFaces(j,:));
%     end

    for k = 1:5
        temp = [];
        for j = 1:subjectnum
            for i  =1:16
                for z = 1:length(dataset_normed{j,k,i})
                    temp(end+1) = dataset_normed{j,k,i}(z);
                end
            end
        end
        overAllMean(k) = mean(temp);
    end
    
    disp('-------over all---------');
    disp(overAllMean);
    
    
%==== raw data scatter plot =====%
    
figure
norming  =[-5,  -7.4, 4, 5.9, -4,  -6,5, 6.9,  -5.1,-7,5,7,-4,-5.8,3.9,6];
for i = 1:5
    dataX = [];
    dataY = [];
    for subject = 1:subjectnum
       for j = 1:16
           for z = 1:length(dataset{subject,i,j})
               dataX(end+1) = norming(j);
               dataY(end+1) = dataset{subject,i,j}(z);
           end
       end
    end
        
    scatter(dataX,dataY);
    hold on;
    lsline;
end
title('raw data scatter plot each')
xlabel('emotion score from norming data');
ylabel('emotion score');
    
%==== raw mean scatter plot =====%
    
figure
norming  =[-5,  -7.4, 4, 5.9, -4,  -6,5, 6.9,  -5.1, -7,5,7,-4,-5.8,3.9,6];
for i = 1:5
    dataX = [];
    dataY = [];
    for subject = 1:subjectnum
       for j = 1:16
            dataX(end+1) = norming(j);
            dataY(end+1) = avg_unnormed(subject,i,j);
       end
    end
        
    scatter(dataX,dataY);
    hold on;
    lsline;
end
title('raw data mean scatter plot')
xlabel('emotion score from norming data');
ylabel('emotion score(mean)');

