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

    raw_byFace_beforeOutlierDetection = cell(16);
    for subject = 1:length(files)
        [trial cond ensFace testFace judgement Break stairCase s1 s2 s3 s4 t1 t2 t3 t4]= textread(files(subject).name,'%d %d %d %d %d %d %d %d %d %d %d %f %f %f %f');
        before_dataPerSubject = cell(16);
        after_dataPerSubject = cell(16);
        
        for i=1:length(trial)
            if ~Break(i) %&& ensFace(i) == 2
                before_dataPerSubject{testFace(i)}(end+1) = judgement(i);
            end
        end
        
        % exclude outlier based on subject's own std
        outlier_low = zeros(16);
        outlier_high = zeros(16);
        outlierStd= 2;
        for i = 1:16
            outlier_low(i) = mean(before_dataPerSubject{i}) - outlierStd * std(before_dataPerSubject{i});
            outlier_high(i) = mean(before_dataPerSubject{i}) + outlierStd * std(before_dataPerSubject{i});
        end
       
        for i=1:length(trial)
            if ~Break(i) && judgement(i)> outlier_low(testFace(i)) && judgement(i) < outlier_high(testFace(i))
                raw_byFace_beforeOutlierDetection{testFace(i)}(end+1) = judgement(i);
            end
        end
    end
    
    % thershold for outlier
        threshold = 2;
        for i=1:16
            upperbound(i) = mean(raw_byFace_beforeOutlierDetection{i}) + threshold *std(raw_byFace_beforeOutlierDetection{i});
            lowerbound(i) = mean(raw_byFace_beforeOutlierDetection{i}) - threshold *std(raw_byFace_beforeOutlierDetection{i});
        end
    
 % ======== overall distribution ==== %       
        
        figure
        for j = 1:16
        x_dis = -10:10;
        y_dis = zeros(21);
        for i = 1:length(raw_byFace_beforeOutlierDetection{j})
            index = raw_byFace_beforeOutlierDetection{j}(i) +11;
            y_dis(index) = y_dis(index)+1;
        end
        subplot(4,4,j)
            plot(x_dis,y_dis);
            axis([-10,10,0,50]);
            stat = {['mean:' num2str(mean(raw_byFace_beforeOutlierDetection{j})) '  std:' num2str(std(raw_byFace_beforeOutlierDetection{j}))]};
            text(-8,45,stat);
            text(upperbound(j),5,'|');
            text(lowerbound(j),5,'|');
            ylabel('counts');
            xlabel('emotion score');
            title(['face No.' num2str(j) ]);

        end

%===== exclude outlier, normalization ======%
    dataset_raw = cell(subjectnum,5,16);
    dataset_normed = cell(subjectnum,5,16);
    avg_unnormed = zeros(subjectnum,5,16);
    avg_normed = zeros(subjectnum,5,16);

    for subject = 1:subjectnum

        [trial cond ensFace testFace judgement Break stairCase s1 s2 s3 s4 t1 t2 t3 t4]= textread(files(subject).name,'%d %d %d %d %d %d %d %d %d %d %d %f %f %f %f');


        % put data into raw dataset
        for i=1:length(trial)
            isOutlier = judgement(i)>upperbound(testFace(i)) || judgement(i)<lowerbound(testFace(i));
            if ~Break(i) && ~isOutlier %&& ensFace(i) == 2
                dataset_raw{subject,cond(i),testFace(i)}(end+1) = judgement(i);
            end
        end

        % normalize data

            avg_byFace = zeros(16);
            std_byFace = zeros(16);
            for j = 1:16
                temp = [];  
                for i = 1:5
                    for z = 1:length(dataset_raw{subject,i,j})
                        temp(end+1) = dataset_raw{subject,i,j}(z);
                    end
                end
                avg_byFace(j) = nanmean(temp);
                std_byFace(j) = nanstd(temp);
            end

        for i = 1:5
            for j = 1:16
                for z = 1:length(dataset_raw{subject,i,j})
                    dataset_normed{subject,i,j}(z) = ( dataset_raw{subject,i,j}(z) - avg_byFace(j) )/std_byFace(j);
                end
            end
        end
    end

    
% ====  average ====== %
        for i = 1:subjectnum
            for j = 1:5
                for k = 1:16
                    avg_normed(i,j,k) = nanmean(dataset_normed{i,j,k});
                    avg_unnormed(i,j,k) = nanmean(dataset_raw{i,j,k});
                end
            end
        end
        
%==== Overall raw data =====%        

groupByEmotion_raw = zeros(subjectnum,5,4);
for ensum = 1:5
    for subject = 1:subjectnum
            temp1 = [avg_unnormed(subject,ensum,2) avg_unnormed(subject,ensum,6) avg_unnormed(subject,ensum,10) avg_unnormed(subject,ensum,14)];
            temp2 = [avg_unnormed(subject,ensum,1) avg_unnormed(subject,ensum,5) avg_unnormed(subject,ensum,9) avg_unnormed(subject,ensum,13)];
            temp3 = [avg_unnormed(subject,ensum,3) avg_unnormed(subject,ensum,7) avg_unnormed(subject,ensum,11) avg_unnormed(subject,ensum,15)];
            temp4 = [avg_unnormed(subject,ensum,4) avg_unnormed(subject,ensum,8) avg_unnormed(subject,ensum,12) avg_unnormed(subject,ensum,16)];
            
            groupByEmotion_raw(subject,ensum,1) = nanmean(temp1);
            groupByEmotion_raw(subject,ensum,2) = nanmean(temp2);
            groupByEmotion_raw(subject,ensum,3) = nanmean(temp3);
            groupByEmotion_raw(subject,ensum,4) = nanmean(temp4);
    end
end

figure
x = 1:4;
for ensum = 1:5
    temp = cell(4);
    for emotion = 1:4
        for j = 1:10 
            temp{emotion}(end+1) = groupByEmotion_raw(j,ensum,emotion);
        end
        y(emotion) = nanmean(temp{emotion});
        e(emotion) = nanstd(temp{emotion})/sqrt(length(temp{emotion}));
    end
errorbar(x,y,e,'.k');
scatter(x,y);
lsline;
hold on;
axis([0,5,-10,10]);
xlabel('emotion');
ylabel('raw rating');
end

%==== Overall normalized data =====%

groupByEmotion_raw = zeros(subjectnum,5,4);
for ensum = 1:5
    for subject = 1:subjectnum
            temp1 = [avg_normed(subject,ensum,2) avg_normed(subject,ensum,6) avg_normed(subject,ensum,10) avg_normed(subject,ensum,14)];
            temp2 = [avg_normed(subject,ensum,1) avg_normed(subject,ensum,5) avg_normed(subject,ensum,9) avg_normed(subject,ensum,13)];
            temp3 = [avg_normed(subject,ensum,3) avg_normed(subject,ensum,7) avg_normed(subject,ensum,11) avg_normed(subject,ensum,15)];
            temp4 = [avg_normed(subject,ensum,4) avg_normed(subject,ensum,8) avg_normed(subject,ensum,12) avg_normed(subject,ensum,16)];
            
            groupByEmotion_raw(subject,ensum,1) = nanmean(temp1);
            groupByEmotion_raw(subject,ensum,2) = nanmean(temp2);
            groupByEmotion_raw(subject,ensum,3) = nanmean(temp3);
            groupByEmotion_raw(subject,ensum,4) = nanmean(temp4);
    end
end

figure
hold on;
x = 1:4;
for ensum = 1:5
    temp = cell(4);
    for emotion = 1:4
        for j = 1:10 
            temp{emotion}(end+1) = groupByEmotion_raw(j,ensum,emotion);
        end
        y(emotion) = nanmean(temp{emotion});
        e(emotion) = nanstd(temp{emotion})/sqrt(length(temp{emotion}));
    end
errorbar(x,y,e,'.k');
grp(ensum) = scatter(x,y);
end

hold off
axis([0,5, -0.5,0.5]);
xlabel('emotion');
ylabel('normalized rating');

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
           sd(i,j) = std(dataset_raw{i,j});
        end
    end

    
%==== over all result =====%    
    overAllMean = zeros(5,1);
    overAllStd = zeros(5,1);
    
%     for j = 1:5        
%         overAllMean(j) = nanmean(resultByFaces(j,:));
%     end

    for k = 1:5
        temp = resultBySubject(k,:);
%         for j = 1:subjectnum
%             for i  =1:16
%                 for z = 1:length(dataset_normed{j,k,i})
%                     temp(end+1) = dataset_normed{j,k,i}(z);
%                 end
%             end
%         end
        overAllMean(k) = mean(temp);
        overAllStd(k) = std(temp)/sqrt(10);
    end
    
    disp('-------over all---------');
    disp(overAllMean);
    disp(overAllStd);
    
    
% %==== raw data scatter plot =====%
%     
% figure
% norming  =[-5,  -7.4, 4, 5.9, -4,  -6,5, 6.9,  -5.1,-7,5,7,-4,-5.8,3.9,6];
% for i = 1:5
%     dataX = [];
%     dataY = [];
%     for subject = 1:subjectnum
%        for j = 1:16
%            for z = 1:length(dataset{subject,i,j})
%                dataX(end+1) = norming(j);
%                dataY(end+1) = dataset{subject,i,j}(z);
%            end
%        end
%     end
%         
%     scatter(dataX,dataY);
%     hold on;
%     lsline;
% end
% title('raw data scatter plot each')
% xlabel('emotion score from norming data');
% ylabel('emotion score');
%     
% %==== raw mean scatter plot =====%
%     
% figure
% norming  =[-5,  -7.4, 4, 5.9, -4,  -6,5, 6.9,  -5.1, -7,5,7,-4,-5.8,3.9,6];
% for i = 1:5
%     dataX = [];
%     dataY = [];
%     for subject = 1:subjectnum
%        for j = 1:16
%             dataX(end+1) = norming(j);
%             dataY(end+1) = avg_unnormed(subject,i,j);
%        end
%     end
%         
%     scatter(dataX,dataY);
%     hold on;
%     lsline;
% end
% title('raw data mean scatter plot')
% xlabel('emotion score from norming data');
% ylabel('emotion score(mean)');

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


