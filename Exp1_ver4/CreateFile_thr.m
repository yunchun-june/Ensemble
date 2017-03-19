function[] = CreateFile(fName, thrList)


    %1 nobreak
    %2~5 thr
    %6 staircase

    fd = fopen(fName, 'w');
    for i=1:length(thrList)
        fprintf(fd, '%3d %0.2f %0.2f %0.2f %0.2f %3d \n', thrList(i,:));
    end
    fclose(fd);

end
