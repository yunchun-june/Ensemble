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

singleOutlierStd= 2; 
overallOutlierStd = 2;

files = dir( 'Ensem_result_*.txt');
subjectNum = length(files);

data_raw = cell(subjectNum,5,6);
data_normed_byFace = cell(subjectNum,5,6);
data_normed_byIden = cell(subjectNum,5,6);

avg_raw = zeros(subjectNum,5,6);
avg_normed_byFace = zeros(subjectNum,5,6);
avg_normed_byIden = zeros(subjectNum,5,6);

%===== Read in data & Exclude Outlier======%

    % exclude outlier based on subject's own std
    raw_byFace_computeOutlier = cell(6);
    sub_low = zeros(subjectNum,6);
    sub_high = zeros(subjectNum,6);

    for sub = 1:subjectNum
        [isExp cond target judgement noBreak stairCase t1 t2 t3 t4 s1 s2 s3 s4 rep p1 p2 p3 p4]= textread(files(sub).name,'%d %d %d %d %d %d %f %f %f %f %d %d %d %d %d %d %d %d %d');
        temp_byFace = cell(6);

        for i=1:length(isExp)
            if noBreak(i) && isExp(i)
                temp_byFace{target(i)}(end+1) = judgement(i);
            end
        end
        
        for i = 1:6
            sub_low(sub,i) = mean(temp_byFace{i}) - singleOutlierStd * std(temp_byFace{i});
            sub_high(sub,i) = mean(temp_byFace{i}) + singleOutlierStd * std(temp_byFace{i});
        end
        
        for i=1:length(isExp)
            if isExp(i)
                isOutlier = judgement(i)< sub_low(sub,target(i)) && judgement(i) > sub_high(sub,target(i));
                if noBreak(i) && isExp(i) && ~isOutlier
                    raw_byFace_computeOutlier{target(i)}(end+1) = judgement(i);
                end
            end
        end
        
    end
    
    % exclude outlier based on overall distribution
    all_high = [];
    all_low = [];
    for i=1:6
        all_high(i) = mean(raw_byFace_computeOutlier{i}) + overallOutlierStd *std(raw_byFace_computeOutlier{i});
        all_low(i) = mean(raw_byFace_computeOutlier{i}) - overallOutlierStd *std(raw_byFace_computeOutlier{i});
    end

    for sub = 1:subjectNum
         [isExp cond target judgement noBreak stairCase t1 t2 t3 t4 s1 s2 s3 s4 rep p1 p2 p3 p4]= textread(files(sub).name,'%d %d %d %d %d %d %f %f %f %f %d %d %d %d %d %d %d %d %d');
         for i=1:length(isExp)
            if isExp(i) && noBreak(i)
                isOutlier_sub = judgement(i)>sub_high(sub,target(i)) || judgement(i)<sub_low(sub,target(i));
                isOutlier_all = judgement(i)>all_high(target(i)) || judgement(i)<all_low(target(i));
                if noBreak(i) && ~isOutlier_all  && ~isOutlier_sub
                    data_raw{sub,cond(i),target(i)}(end+1) = judgement(i);
                end
            end
        end
    end
    
% ======== Draw Overall Distribution Chart==== %      

figure
        for j = 1:6
        x_dis = -10:10;
        y_dis = zeros(21);
        
        for i = 1:length(raw_byFace_computeOutlier{j})
            iden = raw_byFace_computeOutlier{j}(i) +11;
            y_dis(iden) = y_dis(iden)+1;
        end
        
        subplot(2,3,j)
            plot(x_dis,y_dis);
            axis([-10,10,0,70]);
            stat = {['mean:' num2str(mean(raw_byFace_computeOutlier{j})) '  std:' num2str(std(raw_byFace_computeOutlier{j}))]};
            text(-8,45,stat);
            text(all_high(j),5,'|');
            text(all_low(j),5,'|');
            ylabel('counts');
            xlabel('emotion score');
            title(['face No.' num2str(j) ]);

        end
    
%====== Normalized Data By Identity ========%

    % get average & std for each identity
    for identity = 1:2
        temp = [];
        for face = 3*identity-2 : 3*identity
            for sub = 1:subjectNum
                for ensum = 1:5
                    for i = 1:length(data_raw{sub,ensum,face})
                    temp(end+1) = data_raw{sub,ensum,face}(i); end
                end
            end
        end
        avg_iden(identity) = nanmean(temp);
        std_iden(identity) = nanstd(temp);
    end

    % nomalization
    for face = 1:6
        if face >= 1 && face <= 3 iden = 1; end
        if face >= 4 && face <= 6 iden = 2; end

            for sub = 1:subjectNum
                for ensum = 1:5
                    for i = 1:length(data_raw{sub,ensum,face})
                    data_normed_byIden{sub,ensum,face}(i) = (data_raw{sub,ensum,face}(i)-avg_iden(iden)) / std_iden(iden); end
                end
            end
    end

%======Normalized Data By Face ========%

% get average & std for each identity
    avg_face = [];
    std_face = [];
    for sub = 1:subjectNum
        for face = 1:6
            temp = [];
            for ensum = 1:5
                for i = 1:length(data_raw{sub,ensum,face})
                temp(end+1) = data_raw{sub,ensum,face}(i); end
            end
            avg_face(face) = nanmean(temp);
            std_face(face) = nanstd(temp);
        end
    end

    % nomalization
    for face = 1:6
        for sub = 1:subjectNum
            for ensum = 1:5
                for i = 1:length(data_raw{sub,ensum,face})
                data_normed_byFace{sub,ensum,face}(i) = (data_raw{sub,ensum,face}(i)-avg_face(face)) / std_face(face); end
            end
        end
    end
    
%==== Get Mean ====%    

    avg_raw = zeros(subjectNum,5,3);
    avg_normed_byIden = zeros(subjectNum,5,3);
    avg_normed_byFace = zeros(subjectNum,5,3);
    temp_raw = cell(subjectNum,5,3);
    temp_normed_byIden = cell(subjectNum,5,3);
    temp_normed_byFace = cell(subjectNum,5,3);
    
    for face = 1:6
        for sub = 1:subjectNum
            for ensum = 1:5
            avg_raw(sub,ensum,face) = mean(data_raw{sub,ensum,face});
            avg_normed_byFace(sub,ensum,face) = mean(data_normed_byFace{sub,ensum,face});
            avg_normed_byIden(sub,ensum,face) = mean(data_normed_byIden{sub,ensum,face});
            end
        end
    end
    
    
    
    
    disp(avg_raw);
    
    
    
