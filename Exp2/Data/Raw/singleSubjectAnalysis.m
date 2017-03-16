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

    
ID = '1703092';
targetfile = dir( ['Ensem2_result_' ID '.txt']);

%==== linear fitting =====%

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

[trial isExpTrial cond testFace judgement Break stairCase t1 t2 t3 t4 t5 t6 s1 s2 s3 s4 s5 s6]= textread(targetfile.name,'%d %d %d %d %d %d %d  %f %f %f %f %f %f   %d %d %d %d %d %d ');
    
    for i = 1:length(trial)
        if Break(i) == 0 && ~isExpTrial(i)
        end
    end

    num = 1;
    for i = 1:length(trial)
        if Break(i) == 0 && isExpTrial(i)
            score(num,1) = judgement(i);
            con(num,1) = faceVariable(cond(i),1);
            uncon(num,1) = faceVariable(cond(i),2);
            num = num+1;
        end
    end

table = table(score, con, uncon,'VariableNames',{'score','con','uncon'});
lm = fitlm(table,'score~con+uncon')

    %======staircase data=======%
    
        for position = 1:6
            for sc = 1:2; %staircase
                SC{sc,position} = [];
            end
        end
    
        for i=1:length(trial)
            if ~Break(i),
                    SC{stairCase(i),1}(end+1) = t1(i);
                    SC{stairCase(i),2}(end+1) = t2(i);
                    SC{stairCase(i),3}(end+1) = t3(i);
                    SC{stairCase(i),4}(end+1) = t4(i);
                    SC{stairCase(i),5}(end+1) = t5(i);
                    SC{stairCase(i),6}(end+1) = t6(i);
            end
        end
    
        sc_w{1} = 1:length(SC{1,1});
        sc_w{2} = 1:length(SC{2,1});

        figure
        x1 = sc_w{1};
        x2 = sc_w{2};

        for position = 1:6

            subplot(2,3,position)
            plot(x1,SC{1,position},x2, SC{2,position});
            axis([0,120,0,1]);
            xlabel('trials');
            ylabel('contrast');
        end
        suptitle(['StairCase ID:' ID]);
    
        
