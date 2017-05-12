function[] = CreateFile(fName, condList)

    % RESULT TEXT FILE
    
    %1 trial number
    %2 isExptrial 1 / isCatchTrial 0
    %3 condition
    %4 face used
    %5 judgement
    %6 break
    %7 staircase
    %8-11 contrast 

    fd = fopen(fName, 'w');
    for i=1:length(condList)
        fprintf(fd, '%3d %3d %3d %3d %3d %3d %3d     %0.2f %0.2f %0.2f %0.2f %0.2f %0.2f    %d %d %d %d %d %d\n', condList(i,:));
    end
    fclose(fd);

end
