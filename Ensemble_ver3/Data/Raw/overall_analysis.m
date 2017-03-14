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

data_raw = cell(subjectNum,5,16);
data_normed_byFace = cell(subjectNum,5,16);
data_normed_byIden = cell(subjectNum,5,16);

ensumCon      = input('ensumble faces (1 white 2 balck 3 both) : ');
targetCon     = input('target faces (1 white 2 black 3 both) : ');
exclude       = input('exclude the two wired faces? 1 yes 2 no :');


%********************************************%
%     Here the 3 10*5*4 matrix you need      %
%********************************************%
    avg_raw = zeros(subjectNum,5,4);
    avg_normed_byIden = zeros(subjectNum,5,4);
    avg_normed_byFace = zeros(subjectNum,5,4);
%********************************************%


%===== Read in data & Exclude Outlier======%

    % exclude outlier based on subject's own std
    raw_byFace_forOutlierDetection = cell(16);
    mapping = zeros(subjectNum,16);
    legitFaces = cell(16);
    for subject = 1:subjectNum
        [trial cond ensFace testFace judgement Break stairCase s1 s2 s3 s4 t1 t2 t3 t4]= textread(files(subject).name,'%d %d %d %d %d %d %d %d %d %d %d %f %f %f %f');
        dataPerSubject_byFace = cell(16);
        
        for i=1:length(trial)
            if ~Break(i) && islegit(ensumCon, targetCon, exclude, ensFace(i), testFace(i))
                dataPerSubject_byFace{testFace(i)}(end+1) = judgement(i);
            end
        end
        
        outlier_low = zeros(16);
        outlier_high = zeros(16);
        
        for i = 1:16
            outlier_low(i) = mean(dataPerSubject_byFace{i}) - singleOutlierStd * std(dataPerSubject_byFace{i});
            outlier_high(i) = mean(dataPerSubject_byFace{i}) + singleOutlierStd * std(dataPerSubject_byFace{i});
        end
        
        for i=1:length(trial)
            isOutlier = judgement(i)< outlier_low(testFace(i)) && judgement(i) > outlier_high(testFace(i));
            if ~Break(i) && ~isOutlier && islegit(ensumCon, targetCon, exclude, ensFace(i), testFace(i))
                raw_byFace_forOutlierDetection{testFace(i)}(end+1) = judgement(i);
                legitFaces{testFace(i)}(end+1) = judgement(i);
            end
        end
        
        % create mapping due to subject's own arbitrary standard
        avgFace = zeros(16,2);
        for face = 1:16
            avgFace(face,:) = [face mean(legitFaces{face})];
        end   
        
        for iden = 1:4
            temp = avgFace(iden*4-3:iden*4,:);
            sortrows(temp,2);
            for idx = 1:4
                mapping(subject,temp(idx,1)) = idx; end
        end
    end
    
    % exclude outlier based on overall distribution
    for i=1:16
        upperbound(i) = mean(raw_byFace_forOutlierDetection{i}) + overallOutlierStd *std(raw_byFace_forOutlierDetection{i});
        lowerbound(i) = mean(raw_byFace_forOutlierDetection{i}) - overallOutlierStd *std(raw_byFace_forOutlierDetection{i});
    end

    for subject = 1:subjectNum
         [trial cond ensFace testFace judgement Break stairCase s1 s2 s3 s4 t1 t2 t3 t4]= textread(files(subject).name,'%d %d %d %d %d %d %d %d %d %d %d %f %f %f %f');
        for i=1:length(trial)
            isOutlier = judgement(i)>upperbound(testFace(i)) || judgement(i)<lowerbound(testFace(i));
            if ~Break(i) && ~isOutlier  && islegit(ensumCon, targetCon, exclude, ensFace(i), testFace(i))
                data_raw{subject,cond(i),testFace(i)}(end+1) = judgement(i);
            end
        end
    end
    
% ======== Draw Overall Distribution Chart==== %      
%         figure
%         for j = 1:16
%         x_dis = -10:10;
%         y_dis = zeros(21);
%         for i = 1:length(raw_byFace_forOutlierDetection{j})
%             iden = raw_byFace_forOutlierDetection{j}(i) +11;
%             y_dis(iden) = y_dis(iden)+1;
%         end
%         subplot(4,4,j)
%             plot(x_dis,y_dis);
%             axis([-10,10,0,50]);
%             stat = {['mean:' num2str(mean(raw_byFace_forOutlierDetection{j})) '  std:' num2str(std(raw_byFace_forOutlierDetection{j}))]};
%             text(-8,45,stat);
%             text(upperbound(j),5,'|');
%             text(lowerbound(j),5,'|');
%             ylabel('counts');
%             xlabel('emotion score');
%             title(['face No.' num2str(j) ]);
% 
%         end
    
%====== Normalized Data By Identity ========%

    % get average & std for each identity
    for identity = 1:4
        temp = [];
        for face = 4*identity-3 : 4*identity
            for subject = 1:subjectNum
                for ensum = 1:5
                    for i = 1:length(data_raw{subject,ensum,face})
                    temp(end+1) = data_raw{subject,ensum,face}(i); end
                end
            end
        end
        avg_iden(identity) = nanmean(temp);
        std_iden(identity) = nanstd(temp);
    end

    % nomalization
    for face = 1:16
        if face >= 1 && face <= 4 iden = 1; end
        if face >= 5 && face <= 8 iden = 2; end
        if face >= 9 && face <= 12 iden = 3; end
        if face >= 13 && face <= 16 iden = 4; end

            for subject = 1:subjectNum
                for ensum = 1:5
                    for i = 1:length(data_raw{subject,ensum,face})
                    data_normed_byIden{subject,ensum,face}(i) = (data_raw{subject,ensum,face}(i)-avg_iden(iden)) / std_iden(iden); end
                end
            end
    end

%======Normalized Data By Face ========%

% get average & std for each identity
    avg_face = [];
    std_face = [];
    for subject = 1:subjectNum
        for face = 1:16
            temp = [];
            for ensum = 1:5
                for i = 1:length(data_raw{subject,ensum,face})
                temp(end+1) = data_raw{subject,ensum,face}(i); end
            end
            avg_face(face) = nanmean(temp);
            std_face(face) = nanstd(temp);
        end
    end

    % nomalization
    for face = 1:16
        for subject = 1:subjectNum
            for ensum = 1:5
                for i = 1:length(data_raw{subject,ensum,face})
                data_normed_byFace{subject,ensum,face}(i) = (data_raw{subject,ensum,face}(i)-avg_face(face)) / std_face(face); end
            end
        end
    end
    
%==== Get Mean ====%    
    
  
if targetCon == 1 legitFaces = 1:8; end
if targetCon == 2 && exclude == 1 legitFaces = [9 11 12 13 14 16]; end
if targetCon == 2 && exclude == 2 legitFaces = 9:16; end
if targetCon == 3 && exclude == 1 legitFaces = [1 2 3 4 5 6 7 8 9 11 12 13 14 16]; end
if targetCon == 3 && exclude == 2 legitFaces = 1:16; end
faceNum = length(legitFaces);

    avg_raw = zeros(subjectNum,5,4);
    avg_normed_byIden = zeros(subjectNum,5,4);
    avg_normed_byFace = zeros(subjectNum,5,4);
    temp_raw = cell(subjectNum,5,4);
    temp_normed_byIden = cell(subjectNum,5,4);
    temp_normed_byFace = cell(subjectNum,5,4);
    
    for face = legitFaces
        for subject = 1:subjectNum
            for ensum = 1:5
                temp_raw{subject,ensum,mapping(subject,face)} (end+1) = nanmean(data_raw{subject,ensum,face});
                temp_normed_byIden{subject,ensum,mapping(subject,face)} (end+1) = nanmean(data_normed_byIden{subject,ensum,face});
                temp_normed_byFace{subject,ensum,mapping(subject,face)} (end+1) = nanmean(data_normed_byFace{subject,ensum,face});
            end
        end
    end
    
    for emotion = 1:4
        for subject = 1:subjectNum
            for ensum = 1:5 
                avg_raw(subject,ensum,emotion) = nanmean(temp_raw{subject,ensum,emotion});
                avg_normed_byIden(subject,ensum,emotion) = nanmean(temp_normed_byIden{subject,ensum,emotion});
                avg_normed_byFace(subject,ensum,emotion) = nanmean(temp_normed_byFace{subject,ensum,emotion});
            end
        end
    end

