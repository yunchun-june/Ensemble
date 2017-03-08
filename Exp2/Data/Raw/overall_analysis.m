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

files = dir( 'Ensem2_result_*.txt');
subjectnum = length(files);

% ======== Read in all data ====== %

for subject = 1:length(files)
[trial isExpTrial cond testFace judgement Break stairCase t1 t2 t3 t4 t5 t6]= textread(files(subject).name,'%d %d %d %d %d %d %d  %f %f %f %f %f %f');


end
 