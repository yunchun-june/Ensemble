clear all;
close all;

    % RESULT TEXT FILE
    %1 trialnumver 
    %2 condition
    %3 stimuli face
    %4 testface
    %5 result
    %6 isBreakTrials
    %7 which staircase is used
    %8-11 where does it break
    %12-15 threshold presented

ID = '1703051';
targetfile = dir( ['Ensem_result_' ID '.txt']);
files = dir( ['Ensem_result_*.txt']);
    
    
[trial cond ensFace testFace judgement noBreak stairCase s1 s2 s3 s4 t1 t2 t3 t4]= textread(targetfile.name,'%d %d %d %d %d %d %d %d %d %d %d %f %f %f %f');

    %======staircase data=======%
    
        for position = 1:4
            for sc = 1:2; %staircase
                whiteSC{sc,position} = [];
                blackSC{sc,position} = [];
            end
        end
    
        for i=1:length(trial)
            if ~noBreak(i),

                if ensFace(i) == 1
                    whiteSC{stairCase(i),1}(end+1) = t1(i);
                    whiteSC{stairCase(i),2}(end+1) = t2(i);
                    whiteSC{stairCase(i),3}(end+1) = t3(i);
                    whiteSC{stairCase(i),4}(end+1) = t4(i);
                end

                if ensFace(i) == 2
                    blackSC{stairCase(i),1}(end+1) = t1(i);
                    blackSC{stairCase(i),2}(end+1) = t2(i);
                    blackSC{stairCase(i),3}(end+1) = t3(i);
                    blackSC{stairCase(i),4}(end+1) = t4(i);
                end

            end
        end
    

        sc_w{1} = 1:length(whiteSC{1,1});
        sc_w{2} = 1:length(whiteSC{2,1});
        sc_b{1} = 1:length(blackSC{1,1});
        sc_b{2} = 1:length(blackSC{2,1});


        figure
        white_x1 = sc_w{1};
        white_x2 = sc_w{2};
        black_x1 = sc_b{1};
        black_x2 = sc_b{2};

        for position = 1:4

            subplot(4,2,position)
            plot(white_x1,whiteSC{1,position},white_x2, whiteSC{2,position});
            axis([0,120,0,1]);
            xlabel('trials');
            ylabel('contrast');
            if position == 1 title(['white faces' ID]); end
        end

        for  position = 1:4
            subplot(4,2,position+4)
            plot(black_x1,blackSC{1,position},black_x2, blackSC{2,position});
            axis([0,120,0,1]);
            xlabel('trials');
            ylabel('contrast');
            if position == 1 title(['black faces' ID]); end
        end
        
        suptitle(['Staircases  subject ID:' ID]);
        

    %=====break rate=====%
        disp('break rate: ');
        disp(mean(noBreak));
        
    %====effect from this target subject=====&
        
        target_rawdata = cell(5,16);
        target_normalized = cell(5,16);
        face_mean = [];
        face_std = [];
        target_mean = zeros(5,16);
        target_std = zeros(5,16);

        for i=1:length(trial)
            if ~noBreak(i),
                target_rawdata{cond(i),testFace(i)}(end+1) = judgement(i);
            end
        end

    
        % compute mean, std for each condition
        
        scoreFromSameFace = cell(16); 
        for j = 1:16
            for i = 1:5
                for z = 1:length(target_rawdata{i,j})
                    scoreFromSameFace{j}(end+1) = target_rawdata{i,j}(z);
                end
            end
            
                face_mean(j) = mean(scoreFromSameFace{j});
                face_std(j) = std(scoreFromSameFace{j});
        end
    
        %normalize data
        for i = 1:5
            for j = 1:16
                for z = 1:length(target_rawdata{i,j})
                        target_normalized{i,j}(end+1) = ( target_rawdata{i,j}(z) - face_mean(j) )/face_std(j);
                end
            end
        end
    
        %compute mean and std
        for i = 1:5
            for j = 1:16
                target_mean(i,j) = nanmean(target_normalized{i,j});
                target_std(i,j) = nanstd(target_normalized{i,j});
            end
        end

        overAllMean = [];
        overAllStd = [];

        for i=1:5
            temp = [];
            for j = 1:16
                for k = 1:length(target_normalized{i,j})
                    temp(end+1) = target_normalized{i,j}(k);
                end
            end
            overAllMean(i) = mean(temp);
            overAllStd(i) = std(temp);
        end

        disp('top row: all negative faces, buttom row: all positive faces');
        disp('-----stats for all 16 faces-----');
        disp('[average]');
        disp(target_mean);
        disp('[std]');
        disp(target_std);
        disp('-------------overall--------------')
        disp('[average]');
        disp(overAllMean);
        disp('[std]');
        disp(overAllStd);
        
    % ======== raw distribution of each face ==== %
    figure
    for j = 1:16
        x = -10:10;
        y = zeros(21);
        for i = 1:length(scoreFromSameFace{j})
            index = scoreFromSameFace{j}(i) +11;
            y(index) = y(index)+1;
        end
        subplot(4,4,j)
            plot(x,y);
            str = {['mean:' num2str(face_mean(j)) '  std:' num2str(face_std(j))]};
            text(-8,13,str);
            axis([-10,10,0,15]);
            ylabel('counts');
            xlabel('emotion score');
            title(['face No.' num2str(j) ]);
            
    end
    suptitle(['Distribution of Emotion Score  subject ID:' ID]);
    

    
    % ======== outlier detection ========%
%     
%         %overall data
%         rawdata = cell(16);
%         rawdata_mean = zeros(16);
%         rawdata_std = zeros(16);
% 
% 
%         for filenum = 1:length(files)
%             [trial cond ensFace testFace judgement noBreak stairCase s1 s2 s3 s4 t1 t2 t3 t4]= textread(files(filenum).name,'%d %d %d %d %d %d %d %d %d %d %d %f %f %f %f');
%             for i=1:length(trial)
%                 if ~noBreak(i),
%                     rawdata{testFace(i)}(end+1) = judgement(i);
%                 end
%             end
% 
%         end
% 
%         for j = 1:16
%             rawdata_mean(j) =  mean(rawdata{j});
%             rawdata_std(j) = std(rawdata{j});
%         end
% 
%         
%         outlierNum = zeros(5,16);
%         for i = 1:5  
%             for j = 1:16
%                 boundry = 3*rawdata_std(j);
%                 for k = 1:length(target_rawdata{i,j})
%                     if target_rawdata{i,j}(k) - rawdata_mean(j) > boundry outlierNum(i,j) = outlierNum(i,j)+1; end
%                     if target_rawdata{i,j}(k) - rawdata_mean(j) < boundry outlierNum(i,j) = outlierNum(i,j)+1; end
%                 end
%             end
%         end
%         
%         disp('outlier number');
%         disp(outlierNum);

%extreme value (rate a negative face positive vice versa)
%     extremeValue = cell(5,16);
%         for i = 1:5  
%             for j = 1:16
%                 for k = 1:length(target_rawdata{i,j})
%                     
%                     if mod(j,4) == 1 || mod(j,4) == 2 %negative face
%                         if target_rawdata{i,j}(k)>0
%                            extremeValue{i,j} (end+1) = target_rawdata{i,j}(k);
%                         end
%                     end
%                     
%                     
%                     if mod(j,4) == 3 || mod(j,4) == 0 %positive face
%                         if target_rawdata{i,j}(k)<0
%                            extremeValue{i,j} (end+1) = target_rawdata{i,j}(k);
%                         end
%                     end
%                         
%                 end
%             end
%         end
%         
%     
%     
