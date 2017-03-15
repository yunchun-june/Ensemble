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

                     %conscious   unconscious
                     %frea happy  fear happy

%         con     = [ [ 3    1       2   0 ] -1 1
%                     [ 2    2       2   0 ] 0  0
%                     [ 1    3       2   0 ] 1   -1
%                     [ 3    1       1   1 ]
%                     [ 2    2       1   1 ]
%                     [ 1    3       1   1 ]
%                     [ 3    1       0   2 ]
%                     [ 2    2       0   2 ]
%                     [ 1    3       0   2 ]];

% break 0 no break 1 break 2~4 useless trials

faceVariable = [[-0.5  -1]
                [ 0    -1]
                [ 0.5  -1]
                [-0.5   0]
                [ 0     0]
                [ 0.5   0]
                [-0.5   1]
                [   0   1]
                [ 0.5   1]
    ];

ID = '1703111';
targetfile = dir( ['Ensem2_result_' ID '.txt']);
files = dir( ['Ensem_result_*.txt']);
subjectnum = length(files);

% ======== Read in all data ====== %

[trial isExpTrial cond testFace judgement Break stairCase t1 t2 t3 t4 t5 t6 s1 s2 s3 s4 s5 s6 p1 p2 p3 p4 p5 p6]= textread(targetfile.name,'%d %d %d %d %d %d %d  %f %f %f %f %f %f %d %d %d %d %d %d %d %d %d %d %d %d');

    num = 1;
    for i = 1:length(trial)
        if Break(i) == 0 && isExpTrial(i)
            score(num) = judgement(i);
            stimuli(num,1) = faceVariable(cond(i),1);
            stimuli(num,2) = faceVariable(cond(i),2);
            num = num+1;
        end
    end
 
fitting = fitlm(score,stimuli,'linear','RobustOpts','on')
% fitting2 = fitlm(thScore{2},average)
% figure
% scatter(average,thScore{1});
% lsline;
