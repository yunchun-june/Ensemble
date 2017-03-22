function[] = CreateFile(fName, resultList)


%     EXP_CATCH   =1;
%     ENSEM       =2;
%     TARGET      =3;
%     RESPONSE    =4;
%     DONE        =5;
%     STAIR       =6;
%     OPC(1)      =7;
%     OPC(2)      =8;
%     OPC(3)      =9;
%     OPC(4)      =10;
%     SEEN(1)     =11;
%     SEEN(2)     =12;
%     SEEN(3)     =13;
%     SEEN(4)     =14;
%     REPEAT      =15;
%     PLACE(1)    =16;
%     PLACE(2)    =17;
%     PLACE(3)    =18;
%     PLACE(4)    =19;

    fd = fopen(fName, 'w');
    fileLength = length(resultList);
    for i=1:fileLength
        fprintf(fd, '%3d %3d %3d %3d %3d %3d %0.2f %0.2f %0.2f %0.2f %3d %3d %3d %3d %3d %3d %3d %3d %3d\n', resultList(i,:));
    end
    fclose(fd);

end
