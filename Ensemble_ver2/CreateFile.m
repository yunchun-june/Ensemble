function[] = CreateFile(fName, condList)

    % RESULT TEXT FILE
    % 1 TRIALNO
    % 2 cond  1:all negative 5:all positive
    % 3 testface 1:sadest face 7:happy face
    % 4 stimuli face used
    % 5 test face used
    % 6 percieved emotion
    % 7 there are faces seen

    fd = fopen(fName, 'w');
    for i=1:length(condList)
        fprintf(fd, '%3d %d %d %d %d %3d %d\n', condList(i,:));
    end
    fclose(fd);

end
