clear all;
close all;

ID = '1704132';
resultfile = dir( ['Ensem_result_' ID '.txt']);
thrfile = dir( ['Ensem_threshold_' ID '.txt']);
    
    
[isExp cond targetFace judgement noBreak staircase t1 t2 t3 t4 s1 s2 s3 s4 repeat p1 p2 p3 p4]= textread(resultfile.name,'%d %d %d %d %d %d %f %f %f %f %d %d %d %d %d %d %d %d %d ');

    %======staircase data=======%
    
        for position = 1:4
            for sc = 1:2;
                thrData{sc,position} = [];
            end
        end
    
        for i=1:length(t1)
            if isExp(i)&& noBreak(i)
                    thrData{staircase(i),1}(end+1) = t1(i);
                    thrData{staircase(i),2}(end+1) = t2(i);
                    thrData{staircase(i),3}(end+1) = t3(i);
                    thrData{staircase(i),4}(end+1) = t4(i);
            end
        end
        
        figure
        x1 = 1:length(thrData{1,1});
        x2 = 1:length(thrData{2,1});

        for position = 1:4
            subplot(2,2,position)
            plot(x1,thrData{1,position},x2, thrData{2,position});
            axis([0,120,0,1]);
            xlabel('trials');
            ylabel('contrast');
            if position == 1 title(ID); end
        end
        
        catchResponse = cell(10);
        catchMean = [];
        catchStd = [];
        data_raw = cell(5,6);
        
        for i = 1:length(isExp)
            if ~isExp(i)
                catchResponse{targetFace(i)}(end+1) = judgement(i);
            end
            
            if isExp(i)
                data_raw{cond(i),targetFace(i)}(end+1) = judgement(i);
            end
        end
        
        for i = 1:10
            catchMean(i) = mean(catchResponse{i});
            catchStd(i) = std(catchResponse{i});
        end
        
        disp(catchMean);
        disp(catchStd);
        disp(data_raw)