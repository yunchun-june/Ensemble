function checkAllStandard(filename)

resultfile = dir(filename);

% Standards for excluding subjects
% Breaking rate in any quadrant below 10%
% Accuracy in blank trials (false alarm < 20%)
% Judgement on the face in catch trials is unstable (SD>5)

thr_break = 0.20;
thr_falseAlarm = 0.1;
thr_SD = 5;

%=====Data to Read=====%
    for position = 1:4
        for sc = 1:2;
            thrData{sc,position} = [];
        end
    end
    
    expData = cell(5,6);
    blankData = cell(10);
    falseAlarm = [];
    breaking = cell(4,5);

%=====Read In Data=====%
    [isExp ensem targetFace judgement noBreak staircase t1 t2 t3 t4 s1 s2 s3 s4 repeat p1 p2 p3 p4]= textread(resultfile.name,'%d %d %d %d %d %d %f %f %f %f %d %d %d %d %d %d %d %d %d ');
    fileLength = length(isExp);

    for i=1:fileLength
        if isExp(i) && noBreak(i)
            thrData{staircase(i),1}(end+1) = t1(i);
            thrData{staircase(i),2}(end+1) = t2(i);
            thrData{staircase(i),3}(end+1) = t3(i);
            thrData{staircase(i),4}(end+1) = t4(i);
            for j = 1:4 breaking{j}(end+1) = 0; end
            expData{ensem(i),targetFace(i)}(end+1) = judgement(i);
        end

        if isExp(i) && ~noBreak(i)
            breaking{1}(end+1) = s1(i);
            breaking{2}(end+1) = s2(i);
            breaking{3}(end+1) = s3(i);
            breaking{4}(end+1) = s4(i);
        end

        if ~isExp(i) && noBreak(i)
            blankData{targetFace(i)}(end+1) = judgement(i);
            falseAlarm(end+1) = 0;
        end

        if ~isExp(i) && ~noBreak(i)
            falseAlarm(end+1) = 1;
        end
    end
    
    for i = 1:10
        avg_blank(i) = mean(blankData{i});
        std_blank(i) = std(blankData{i});
    end
    
    for i = 1:4
        breakingRate(i) = mean(breaking{i});
    end
    
%====== Draw StairCases Graph =======%
%     figure
%     x1 = 1:90;
%     x2 = 1:90;
% 
%     for position = 1:4
%         subplot(2,2,position)
%         plot(x1,thrData{1,position},x2, thrData{2,position});
%         axis([0,120,0,1]);
%         xlabel('trials');
%         ylabel('contrast');
%         if position == 1 title(ID); end
%     end
    
%=== Draw Graph of Judgement on each faces ====%
%     x1 = 1:5;
%     x2 = 6:10;
%     y = [];
%     error = [];
%     
%     figure
%     errorbar(x1,avg_blank(1:5),std_blank(1:5));
%     hold on;
%     errorbar(x2,avg_blank(6:10),std_blank(6:10));
%     axis([0,11,-10,10]);
%     ylabel('judgement score');
%     xlabel('face No.');
%     title(ID);
    
%====== Check All standards =======%
    exclude = 0;
    pass = [1 1 1];
    for i=1:4 
        if breakingRate(i)<thr_break
            exclude = 1;
            pass(1) = 0;
        end
    end
    
    if falseAlarm > thr_falseAlarm
            exclude = 1;
            pass(2) = 0;
    end
    
    for i=1:10
        if std_blank(i)>thr_SD
            exclude = 1;
            pass(3) = 0;
        end
    end
    
%====== Show Result =======%
    if ~pass(1)
        disp(['Exclude ' filename ' base on breaking rate'])
        disp(breakingRate);
    end

    if ~pass(2)
        disp(['Exclude ' filename ' base on false alarm rate'])
        disp(mean(falseAlarm));
    end
    
    if ~pass(3)
        disp(['Exclude ' filename ' base on enstable standard'])
        disp(std_blank);
    end

end
    
    
    