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

threshold_file = dir( 'Ensem_thr_1702244.txt');
datafile = dir('Ensem_result_1702244.txt');

for position = 1:4
     SC{position} = [];
end

    
    [t1 t2 t3 t4 s1 s2 s3 s4 ]= textread(threshold_file.name,' %f %f %f %f %d %d %d %d');
    [trial cond ensFace testFace judgement noBreak]= textread(datafile.name,'%d %d %d %d %d %d ');
    
    % put data into dataset

    for i=1:length(trial)
        if ~noBreak(i),

                SC{1}(end+1) = t1(i);
                SC{2}(end+1) = t2(i);
                SC{3}(end+1) = t3(i);
                SC{4}(end+1) = t4(i);
            
        end
    end
    
disp('break rate: ');
disp(1-mean(noBreak));

n = 1:length(SC{1});


figure

for position = 1:4
    subplot(2,2,position)
    plot(n,SC{position});
    axis([0,240,0,1]);
end

