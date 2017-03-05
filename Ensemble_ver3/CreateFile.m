function[] = CreateFile(fName, condList)

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

    fd = fopen(fName, 'w');
    for i=1:length(condList)
        fprintf(fd, '%3d %3d %3d %3d %3d %3d %3d %d %d %d %d %0.2f %0.2f %0.2f %0.2f\n', condList(i,:));
    end
    fclose(fd);

end
