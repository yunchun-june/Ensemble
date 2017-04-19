clear all;
close all;
 
singleOutlierStd= 2; 
overallOutlierStd = 2.5;
 
files = dir( 'Ensem_result_*.txt');
subjectNum = length(files);
 
data_raw = cell(subjectNum,5,6);
data_normed_byFace = cell(subjectNum,5,6);
data_normed_byIden = cell(subjectNum,5,6);
 
%====== these are the matrix you need ======%
avg_raw = zeros(subjectNum,5,3);
avg_normed_byFace = zeros(subjectNum,5,3);
avg_normed_byIden = zeros(subjectNum,5,3);
%===========================================%
 
 
%===== Read in data & Exclude Outlier======%
 
    
    % readin data excluding outlier based on subject's own std
    raw_byFace_computeOutlier = cell(6);
    sub_low = zeros(subjectNum,6);
    sub_high = zeros(subjectNum,6);
    sub_mean = zeros(subjectNum,6);
    
    for sub = 1:subjectNum
        [isExp cond target judgement noBreak stairCase t1 t2 t3 t4 s1 s2 s3 s4 rep p1 p2 p3 p4]= textread(files(sub).name,'%d %d %d %d %d %d %f %f %f %f %d %d %d %d %d %d %d %d %d');
        temp_byFace = cell(6);
 
        false = 0;
        %compute outlier
        for i=1:length(isExp)
            if noBreak(i) && isExp(i)
                temp_byFace{target(i)}(end+1) = judgement(i);
            end
            
            if ~noBreak(i) && ~isExp(i)
                false = false+1;
            end
        end
        disp(['subject ' files(sub).name ' false alarm: ' num2str(false)]);
         
        for i = 1:6
            sub_low(sub,i) = mean(temp_byFace{i}) - singleOutlierStd * std(temp_byFace{i});
            sub_high(sub,i) = mean(temp_byFace{i}) + singleOutlierStd * std(temp_byFace{i});
        end
         
        for i=1:length(isExp)
            if isExp(i)
                isOutlier = judgement(i)< sub_low(sub,target(i)) && judgement(i) > sub_high(sub,target(i));
                if noBreak(i) && isExp(i) && ~isOutlier
                    data_raw{sub,cond(i),target(i)}(end+1) = judgement(i);
                end
            end
        end
    end
    
    %excluding subjects base on group
    
    for sub = 1:subjectNum
        for face = 1:6
            temp = [];
            for ensum = 1:5
                for i = 1: length(data_raw{sub,ensum,face}) temp(end+1) = data_raw{sub,ensum,face}(i); end
            end
            sub_mean(sub,face) = mean(temp);
            sub_std(sub,face) = std(temp);
        end
    end
    
    deleted = 0;
    for sub = 1:subjectNum
        for face = 1:6
            z = ( sub_mean(sub,face) - mean(sub_mean(:,face)) ) / std(sub_mean(:,face));
            if z>overallOutlierStd || z< -overallOutlierStd
                disp(['subject' files(sub-deleted).name ' is excluded based on judgement on face ' num2str(face)]);
                data_raw(sub-deleted,:,:) = [];
                subjectNum = subjectNum - 1;
                deleted = deleted+1;
            end
        end
    end
     
%====== Normalized Data By Identity ========%
 
    % get average & std for each identity
    for sub = 1:subjectNum
         
    for identity = 1:2
        temp = [];
        for face = 3*identity-2 : 3*identity
                for ensum = 1:5
                    for i = 1:length(data_raw{sub,ensum,face})
                    temp(end+1) = data_raw{sub,ensum,face}(i); end
                end
        end
        avg_iden(identity) = nanmean(temp);
        std_iden(identity) = nanstd(temp);
    end
 
    % nomalization
        for face = 1:6
            if face >= 1 && face <= 3 iden = 1; end
            if face >= 4 && face <= 6 iden = 2; end
                for ensum = 1:5
                    for i = 1:length(data_raw{sub,ensum,face})
                    data_normed_byIden{sub,ensum,face}(i) = (data_raw{sub,ensum,face}(i)-avg_iden(iden))/ std_iden(iden); end
                end
         end
    end
 
%======Normalized Data By Face ========%
 
% get average & std for each identity
 
    for sub = 1:subjectNum
        avg_face = [];
        std_face = [];
   
        for face = 1:6
            temp = [];
            for ensum = 1:5
                for i = 1:length(data_raw{sub,ensum,face})
                temp(end+1) = data_raw{sub,ensum,face}(i); end
            end
            avg_face(face) = nanmean(temp);
            std_face(face) = nanstd(temp);
        end
 
        % nomalization
        for face = 1:6
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
        if face == 1 || face == 4 emotion = 1; end
        if face == 2 || face == 5 emotion = 2; end
        if face == 3 || face == 6 emotion = 3; end
             
        for sub = 1:subjectNum
            for ensum = 1:5
            temp_raw{sub,ensum,emotion}(end+1) = mean(data_raw{sub,ensum,face});
            temp_normed_byFace{sub,ensum,emotion}(end+1) = mean(data_normed_byFace{sub,ensum,face});
            temp_normed_byIden{sub,ensum,emotion}(end+1) = mean(data_normed_byIden{sub,ensum,face});
            end
        end
    end
     
    for emotion = 1:3
        for sub = 1:subjectNum
            for ensum = 1:5
            avg_raw(sub,ensum,emotion) = mean(temp_raw{sub,ensum,emotion});
            avg_normed_byFace(sub,ensum,emotion) = mean(temp_normed_byFace{sub,ensum,emotion});
            avg_normed_byIden(sub,ensum,emotion) = mean(temp_normed_byIden{sub,ensum,emotion});
            end
        end
    end
    
    %===== for each subject(all emotion) =====%
    
    overall = zeros(subjectNum,5);
    overallStd = zeros(subjectNum,5);
    
    for ensum = 1:5
        for sub = 1:subjectNum
            temp = [];
            for emotion  = 1:3
                temp(end+1) = avg_normed_byFace(sub,ensum,emotion);
            end
            overall(sub,ensum) = mean(temp);
            overallStd(sub,ensum) = std(temp)/sqrt(30);
        end
    end
    
    figure
    
    x = 1:5;
    
    for sub = 1:subjectNum
        subplot(4,4,sub);
        %errorbar(y,overall(sub,:),overallStd(sub,:));
        scatter(x,overall(sub,:));
        lsline;
        set(gca,'XTickLabel', {'4F','3F1H','2F2H','1F3H','4H'});
        xlabel('Ensemble condition');
        ylabel('Emotion rating ');
        axis([1 5 -1 1]);
        rsqare = getr2(x,overall(sub,:));
        title(['R2 = ' num2str(rsqare)]);
    end
    
    suptitle('trend for each subjects(across emotion)');
    
    %===== for each subject (neutral)=====%
    
    overall = zeros(subjectNum,5);
    overallStd = zeros(subjectNum,5);
    
    for ensum = 1:5
        for sub = 1:subjectNum
            temp = [];
            for emotion  = 2
                temp(end+1) = avg_normed_byFace(sub,ensum,emotion);
            end
            overall(sub,ensum) = mean(temp);
            overallStd(sub,ensum) = std(temp)/sqrt(30);
        end
    end
    
    figure
    
    x = 1:5;
    
    for sub = 1:subjectNum
        subplot(4,4,sub);
        %errorbar(y,overall(sub,:),overallStd(sub,:));
        scatter(x,overall(sub,:));
        lsline;
        set(gca,'XTickLabel', {'4F','3F1H','2F2H','1F3H','4H'});
        xlabel('Ensemble condition');
        ylabel('Emotion rating ');
        axis([1 5 -1 1]);
        rsqare = getr2(x,overall(sub,:));
        title(['R2 = ' num2str(rsqare)]);
    end
    
    suptitle('trend for each subjects(neutral face only)');
    
    

    %=====overall (across emotion )=====%
    
    overall = [];
    overallStd = [];
    for ensum = 1:5
        temp = [];
        for sub = 1:subjectNum
            for emotion  = 1:3
                temp(end+1) = avg_normed_byFace(sub,ensum,emotion);
            end
        end
        overall(ensum) = mean(temp);
        overallStd(ensum) = std(temp)/sqrt(6*subjectNum);
    end
    
    figure
    x = 1:5;
    %plot(overall);
    errorbar(x,overall,overallStd);
    set(gca,'XTickLabel', {'','4F','','3F1H','','2F2H','','1F3H','','4H'});
    xlabel('Ensemble condition');
    ylabel('Emotion rating (nomalized by face)');
    title('Overall Result (across emotions)');
    
    %=====overall (neutral face only)=====%
    
    overall = [];
    overallStd = [];
    for ensum = 1:5
        temp = [];
        for sub = 1:subjectNum
            for emotion  = 2
                temp(end+1) = avg_normed_byFace(sub,ensum,emotion);
            end
        end
        overall(ensum) = mean(temp);
        overallStd(ensum) = std(temp)/sqrt(2*subjectNum);
    end
    
    figure
    x = 1:5;
    %plot(overall);
    errorbar(x,overall,overallStd);
    set(gca,'XTickLabel', {'','4F','','3F1H','','2F2H','','1F3H','','4H'});
    xlabel('Ensemble condition');
    ylabel('Emotion rating (nomalized by face)');
    title('Overall Result (neutral face only)');
    
   %===== for each subject (neutral)=====%
    
    overall = zeros(subjectNum,5);
    overallStd = zeros(subjectNum,5);
    
    x = [];
    y = [];
    
    for ensum = 1:5
        for sub = 1:subjectNum
            for emotion  = 2
                x(end+1) = ensum;
                y(end+1) = avg_normed_byFace(sub,ensum,emotion);
            end
        end
    end
    
    figure
    
        scatter(x,y);
        lsline;
        set(gca,'XTickLabel', {'4F','3F1H','2F2H','1F3H','4H'});
        xlabel('Ensemble condition');
        ylabel('Emotion rating ');
        axis([1 5 -1 1]);
        rsqare = getr2(x,y);
        title(['R2 = ' num2str(rsqare)]);

    
    %=== ANOVA ====%
    anova = zeros(0,4);
    
    for ensum = 1:5
        for sub = 1:subjectNum
            for emotion  = 1:3
                temp = [avg_normed_byFace(sub,ensum,emotion) ensum emotion sub];
                anova(end+1,:) = temp;
            end
        end
    end
    
    RMAOV2(anova);
    
    
    %=== ANOVA have feaful/ all happy ====%
    anova = zeros(0,4);
    
    for ensum = 1:5
        for sub = 1:subjectNum
            for emotion  = 1:3
                if ensum == 5, condition = 1;
                else condition = 2; end
                temp = [avg_normed_byFace(sub,ensum,emotion) condition emotion sub];
                anova(end+1,:) = temp;
            end
        end
    end
    
    RMAOV2(anova);
    
    %=== ANOVA diff number of fearful faces ====%
    anova = zeros(0,4);
    
    for ensum = 1:4
        for sub = 1:subjectNum
            for emotion  = 1:3
                temp = [avg_normed_byFace(sub,ensum,emotion) ensum emotion sub];
                anova(end+1,:) = temp;
            end
        end
    end
    
    RMAOV2(anova);
    