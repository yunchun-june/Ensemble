function[] = CreateFile(fName, condList)

    % RESULT TEXT FILE
    % 1-4 threshold
    % 5-8 seen or not

    fd = fopen(fName, 'w');
    for i=1:length(condList)
        fprintf(fd, '%0.2f %0.2f %0.2f %0.2f %d %d %d %d\n', condList(i,:));
    end
    fclose(fd);

end
