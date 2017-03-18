function[] = CreateFile(fName, thrList)


    %1~4 thr
    %5 staircase

    fd = fopen(fName, 'w');
    for i=1:length(thrList)
        fprintf(fd, '%0.2f %0.2f %0.2f %0.2f %3d \n', thrList(i,:));
    end
    fclose(fd);

end
