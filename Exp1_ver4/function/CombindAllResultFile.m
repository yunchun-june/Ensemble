function [] = CombindAllResultFile(subjID)

%====== Content of Result File ======%
%   column name    colunm number  
%     IS_EXP_TRIAL    =1;
%     ENSEM           =2;
%     TARGET          =3;
%     JUDGEMENT       =4;
%     DONE            =5;
%     STAIRCASE       =6;
%     CON(1)          =7;
%     CON(2)          =8;
%     CON(3)          =9;
%     CON(4)          =10;
%     SEEN(1)         =11;
%     SEEN(2)         =12;
%     SEEN(3)         =13;
%     SEEN(4)         =14;
%     REPEAT          =15;
%     PLACE(1)        =16; 
%     PLACE(2)        =17;
%     PLACE(3)        =18;
%     PLACE(4)        =19;

    %---- read files and check file number ----%
    sourceFilepath = ['./Data/Ensem_result_' subjID '_block*.txt'];
    allFiles = dir(sourceFilepath);
    fileNum = length(allFiles);
    if(fileNum ~= 5)
        disp('result files are less then 5');
        return;
    end
    
    %----- read and write to new file ----%
    destFilepath = ['./Data/Ensem_result_' subjID '.txt'];
    destfile = fopen(destFilepath, 'w');
    
    for block = 1:5
        sourceFilepath = ['./Data/Ensem_result_' subjID '_block' num2str(block) '.txt'];
        sourcefile = fopen(sourceFilepath);
        nextLine = fgets(sourcefile);
        while ischar(nextLine)
            fprintf(destfile, '%s', nextLine);
            nextLine = fgets(sourcefile);
        end
        fclose(sourcefile);
    end
    fclose(destfile);
    
    
    
    
    

        
    
    
    format = '%d %d %d %d %d %d %f %f %f %f %d %d %d %d %d %d %d %d %d';
    [isExp cond target judgement noBreak stairCase t1 t2 t3 t4 s1 s2 s3 s4 rep p1 p2 p3 p4]= textread(sourceFilepath,format);
    row = length(isExp);
    doneEnsem = [0 0 0 0 0];
    for i = 1:row
        doneEnsem(cond) = 1;
    end
    doneBlock = sum(doneEnsem);
    
    

end
