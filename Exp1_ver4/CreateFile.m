function[] = CreateFile(fName, condList)

%     1 trial
%     2 expTrial 0 catchTrial
%     3 ensumble condition
%     4 target face
%     5 response
%     6 break
%     7 staircase number
%     8-11 opacity
%     12-15 seen
%     16 done how many times

    fd = fopen(fName, 'w');
    for i=1:length(condList)
        fprintf(fd, '%3d %3d %3d %3d %3d %3d %3d %0.2f %0.2f %0.2f %0.2f %3d %3d %3d %3d %3d\n', condList(i,:));
    end
    fclose(fd);

end
