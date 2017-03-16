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

catch_raw = cell(subNum,6);
catch_mean = zeros(subNum,6);
faceThrScore = zeros(subNum,9);
x_rawScatter = cell(3);
y_rawScatter = cell(3);
x_meanScatter = cell(3);
y_meanScatter = cell(3);
rating_raw = cell(subNum,9);
rating_mean = zeros(subNum,9);

for sub = 1:subNum

[trial isExpTrial cond testFace judgement Break stairCase t1 t2 t3 t4 t5 t6 s1 s2 s3 s4 s5 s6]= textread(files(sub).name,'%d %d %d %d %d %d %d  %f %f %f %f %f %f   %d %d %d %d %d %d ');
    
    %===== compute thr score by catch trial =======%
    
    for i = 1:length(trial)
        if ~isExpTrial(i) && Break(i) == 0
            catch_raw{sub,cond(i)}(end+1) = judgement(i);
        end
    end
    
    for i  =1:6
        catch_mean(sub,i) = mean(catch_raw{sub,i}); end
    
    
    faceSet  = [[catch_mean(sub,1) catch_mean(sub,2) catch_mean(sub,3) catch_mean(sub,5) ]
                   [catch_mean(sub,1) catch_mean(sub,3) catch_mean(sub,4) catch_mean(sub,6) ]
                   [catch_mean(sub,2) catch_mean(sub,4) catch_mean(sub,5) catch_mean(sub,6) ]
                   [catch_mean(sub,1) catch_mean(sub,2) catch_mean(sub,3) catch_mean(sub,5) ]
                   [catch_mean(sub,1) catch_mean(sub,3) catch_mean(sub,4) catch_mean(sub,6) ]
                   [catch_mean(sub,2) catch_mean(sub,4) catch_mean(sub,5) catch_mean(sub,6) ]
                   [catch_mean(sub,1) catch_mean(sub,2) catch_mean(sub,3) catch_mean(sub,5) ]
                   [catch_mean(sub,1) catch_mean(sub,3) catch_mean(sub,4) catch_mean(sub,6) ]
                   [catch_mean(sub,2) catch_mean(sub,4) catch_mean(sub,5) catch_mean(sub,6) ]
                   [catch_mean(sub,1) catch_mean(sub,2) catch_mean(sub,3) catch_mean(sub,5) ]
                   [catch_mean(sub,1) catch_mean(sub,3) catch_mean(sub,4) catch_mean(sub,6) ]
                   [catch_mean(sub,2) catch_mean(sub,4) catch_mean(sub,5) catch_mean(sub,6) ]
        ];
    
    for i = 1:9
        faceThrScore(sub,i) = mean(faceSet(i,:));
    end
    
    %===== read in exp trials data =======%
    
    getUncon = [1 1 1 2 2 2 3 3 3];
    
    for i = 1:length(trial)
        if ~Break(i) && isExpTrial(i)
            unCon = getUncon(cond(i));
            y_rawScatter{unCon}(end+1) = judgement(i);
            x_rawScatter{unCon}(end+1) = faceThrScore(sub,cond(i));
            rating_raw{sub,cond(i)}(end+1) = judgement(i);
        end
    end
    
    for i = 1:9
        rating_mean(sub,i) = mean(rating_raw{sub,i});
        x_meanScatter{getUncon(i)} (end+1)= faceThrScore(sub,i);
        y_meanScatter{getUncon(i)} (end+1)= rating_mean(sub,i);
        
    end
end
    
    figure
        plot(x_rawScatter{1},y_rawScatter{1},'rx');       
        hold on;
        plot(x_rawScatter{2},y_rawScatter{2},'mo');
        plot(x_rawScatter{3},y_rawScatter{3},'b*');
        lsline;
        xlabel('Thr score based on subjects standard');
        ylabel('percieved average emotion');
        title('scatter plot based on raw data');
        legend('fearful','neutral','happy');
        
    figure
        plot(x_meanScatter{1},y_meanScatter{1},'rx');       
        hold on;
        plot(x_meanScatter{2},y_meanScatter{2},'mo');
        plot(x_meanScatter{3},y_meanScatter{3},'b*');
        lsline;
        xlabel('Thr score based on subjects standard');
        ylabel('percieved average emotion');
        title('scatter plot based on mean data');
        legend('fearful','neutral','happy');


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

