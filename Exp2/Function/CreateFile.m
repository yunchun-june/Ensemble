function[] = CreateFile(fName, condList)

%     %====== result list  ======%
%         TRIAL = 1;
%         IS_EXP = 2;
%         COND = 3;
%         JUDGEMNET = 4;
%         BREAK  =5;
%         STAIRCASE = 6;
%         CON = 7:12;
%         SEEN = 13:18;
%         POSI = 19:24;
%         COL_NUM = 24;

    fd = fopen(fName, 'w');
    [row col] = size(condList);
    for i=1:row
        fprintf(fd, '%3d %3d %3d %3d %3d %3d %0.2f %0.2f %0.2f %0.2f %0.2f %0.2f %d %d %d %d %d %d %d %d %d %d %d %d\r\n', condList(i,:));
    end
    fclose(fd);

end
