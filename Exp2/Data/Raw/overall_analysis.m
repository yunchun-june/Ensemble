clear all;
close all;

% RESULT TEXT FILE
    %1 trial number
    %2 isExptrial 1 / isCatchTrial 0
    %3 condition
    %4 face used
    %5 judgement
    %6 break
    %7 staircase
    %8-13 contrast
    %14-19 seen

                     %conscious   unconscious
                     %frea happy  fear happy

%         con     = [ [ 3    1       2   0 ]
%                     [ 2    2       2   0 ]
%                     [ 1    3       2   0 ]
%                     [ 3    1       1   1 ]
%                     [ 2    2       1   1 ]
%                     [ 1    3       1   1 ]
%                     [ 3    1       0   2 ]
%                     [ 2    2       0   2 ]
%                     [ 1    3       0   2 ]];

% break 0 no break 1 break 2~4 useless trials



ID = '1703111';
targetfile = dir( ['Ensem2_result_' ID '.txt']);
files = dir( ['Ensem2_result_*.txt']);
subNum = length(files);

% ======== Read in all data ====== %

rating_raw = cell(subNum,6);
rating_mean = zeros(subNum,6);


for sub = 1:subNum

[trial isExpTrial cond testFace judgement Break stairCase t1 t2 t3 t4 t5 t6 s1 s2 s3 s4 s5 s6]= textread(files(sub).name,'%d %d %d %d %d %d %d  %f %f %f %f %f %f   %d %d %d %d %d %d ');
    
    for i = 1:length(trial)
        if ~isExpTrial(i) && Break(i) == 0
            rating_raw{sub,cond(i)}(end+1) = judgement(i);
        end
    end
    
    for i  =1:6
        rating_mean(sub,i) = mean(rating_raw{sub,i}); end
    
    faceThrScore = zeros(sub,9);
    faceSet  = [[rating_mean(sub,1) rating_mean(sub,2) rating_mean(sub,3) rating_mean(sub,5) ]
                   [rating_mean(sub,1) rating_mean(sub,3) rating_mean(sub,4) rating_mean(sub,6) ]
                   [rating_mean(sub,2) rating_mean(sub,4) rating_mean(sub,5) rating_mean(sub,6) ]
                   [rating_mean(sub,1) rating_mean(sub,2) rating_mean(sub,3) rating_mean(sub,5) ]
                   [rating_mean(sub,1) rating_mean(sub,3) rating_mean(sub,4) rating_mean(sub,6) ]
                   [rating_mean(sub,2) rating_mean(sub,4) rating_mean(sub,5) rating_mean(sub,6) ]
                   [rating_mean(sub,1) rating_mean(sub,2) rating_mean(sub,3) rating_mean(sub,5) ]
                   [rating_mean(sub,1) rating_mean(sub,3) rating_mean(sub,4) rating_mean(sub,6) ]
                   [rating_mean(sub,2) rating_mean(sub,4) rating_mean(sub,5) rating_mean(sub,6) ]
                   [rating_mean(sub,1) rating_mean(sub,2) rating_mean(sub,3) rating_mean(sub,5) ]
                   [rating_mean(sub,1) rating_mean(sub,3) rating_mean(sub,4) rating_mean(sub,6) ]
                   [rating_mean(sub,2) rating_mean(sub,4) rating_mean(sub,5) rating_mean(sub,6) ]
        ];
    
    for i = 1:9
        faceThrScore(sub,i) = mean(faceSet(i,:));
    end
    
    x = cell(3);
    y = cell(3);
    
    for i = 1:length(trial)
        if ~Break(i) && isExpTrial(i)
                 condition = cond(i);
                 if condition == 1, conCon = 1; unCon = 1; end
                 if condition == 2, conCon = 2; unCon = 1; end
                 if condition == 3, conCon = 3; unCon = 1; end
                 if condition == 4, conCon = 1; unCon = 2; end
                 if condition == 5, conCon = 2; unCon = 2; end
                 if condition == 6, conCon = 3; unCon = 2; end
                 if condition == 7, conCon = 1; unCon = 3; end
                 if condition == 8, conCon = 2; unCon = 3; end
                 if condition == 9, conCon = 3; unCon = 3; end
            y{unCon}(end+1) = judgement(i);
            x{unCon}(end+1) = faceThrScore(sub,cond(i));
        end
    end
end
    
    figure
    for i = 1:3
        scatter(x{i},y{i});
        lsline;
        hold on;
    end



%     num = 1;
%     for i = 1:length(trial)
%         if Break(i) == 0 && isExpTrial(i)
%             score(num,1) = judgement(i);
%             con(num,1) = faceVariable(cond(i),1);
%             uncon(num,1) = faceVariable(cond(i),2);
%             num = num+1;
%         end
%     end

% table = table(score, con, uncon,'VariableNames',{'score','con','uncon'});
% lm = fitlm(table,'score~con+uncon')

