

    % RESULT TEXT FILE
    
    %1 trial number
    %2 isExptrial 1 / isCatchTrial 0
    %3 condition
    %4 face used
    %5 judgement
    %6 break
    %7 staircase
    %8-11 contrast 
    
    files = dir( 'Ensem_result_1703194.txt');
    [a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15]= textread(files.name,'%3d %3d %3d %3d %3d %3d %f %f %f %f %d %d %d %d %d');
    
    condList = zeros(0,19);
    for i = 1:length(a1)
        temp = [a1(i) a2(i) a3(i) a4(i) a5(i) a6(i) a7(i) a8(i) a9(i) a10(i) a11(i) a12(i) a13(i) a14(i) a15(i)];
        condList(end+1,1:15) = temp;
        condList(end, 16:19) = [0 0 0 0];
    end
    
    fd = fopen('Ensem2_result_.txt', 'w');
    for i=1:length(condList)
        fprintf(fd, '%3d %3d %3d %3d %3d %3d %0.2f %0.2f %0.2f %0.2f %d %d %d %d %d %d %d %d %d \n', condList(i,:));
    end
    fclose(fd);

