
clear all;
close all;

try

    %====== Input ======%
        subjNo                = input('subjNo: ','s');
        DemoEye               = input('DomEye Right 1 Left 2:');
        keymode               = input('keymode1 MAC keymode2 Dell 3 EEG:');
        fName = ['./Data/Ensem2_result_' subjNo '.txt'];
        
    %====== initial condition =====% 
        initialThr = [0.7 0.8 0.7 0.7 0.7 0.7];
    
        for i = 1:6
            faceOpc{1}(1,i) = initialThr(i);  faceOpc{1}(2,i) = initialThr(i)-0.35;  % white faces
            faceOpc{2}(1,i) = initialThr(i);  faceOpc{2}(2,i) = initialThr(i)-0.3;  % black faces
        end
        
        conOpc = 1;
        maskOpc = 1;
        
        lowerBound = 0.02;
        upperBound = 1.00;
        stepsize_down = 0.05;
        stepsize_up = 0.03;
        stairCase_up = 2;
        
    %====== Setup Screen ======%
        screid = max(Screen('Screens'));
        [wPtr, screenRect]=Screen('OpenWindow',1, 0,[],32,2); % open screen
        [width, height] = Screen('WindowSize', wPtr); %get windows size 

    %===== Devices======%
        
        if keymode==1,
            targetUsageName = 'Keyboard';
            targetProduct = 'Apple Keyboard';
            dev=PsychHID('Devices');
            devInd = find(strcmpi(targetUsageName, {dev.usageName}) & strcmpi(targetProduct, {dev.product}));
        elseif keymode==2,
            targetUsageName = 'Keyboard';
            targetProduct = 'USB Keykoard';
            dev=PsychHID('Devices');
            devInd = find(strcmpi(targetUsageName, {dev.usageName}) & strcmpi(targetProduct, {dev.product}));
        elseif keymode==3,
            targetUsageName = 'Keyboard';
            targetProduct = 'Dell USB Keyboard';
            dev=PsychHID('Devices');
            devInd = find(strcmpi(targetUsageName, {dev.usageName}) & strcmpi(targetProduct, {dev.product}));
        end
        KbQueueCreate(devInd);  
        KbQueueStart(devInd);
        
    %======Keyboard======%
     
        KbName('UnifyKeyNames');
        quitkey = 'ESCAPE';
        space   = 'space';
        breakKey = 'DownArrow';

        leftkey = '1';
        rightkey = '3';
        
        placeKey{1} = '4';
        placeKey{2} = '5';
        placeKey{3} = '6';
        placeKey{4} = '1';
        placeKey{5} = '2';
        placeKey{6} = '3';
        placeKey{7} = '0';

     %====== Experimental Condition ======%

        repeatNum = 16;
        repeat_catch = 3;
        condNum = 9; 
        person_used = 2;

        expTrial = repeatNum * condNum * person_used;
        catchTrial = 6 * person_used * repeat_catch;

                     %conscious   unconscious
                     %frea happy  fear happy

%         con     = [ [ 3    1       2   0 ]
%                     [ 2    2       2   0 ]
%                     [ 1    3       2   0 ]
%                     [ 3    1       1   1 ]
%                     [ 2    2       1   1 ]
%                     [ 1    3       1   1 ]
%                     [ 3    1       0   2 ]
%                     [ 2    2       0   2 ]
%                     [ 1    3       0   2 ]];


        % set up condition list

            %1 trial number
            %2 isExptrial 1 / isCatchTrial 0
            %3 condition
            %4 face used
            %5 judgement
            %6 break
            %7 staircase
            %8-13 contrast
            %14-19 seen
            %20-25 place

            exp_condtemp = zeros(expTrial,13);
            catch_condtemp = zeros(catchTrial,13);

            %exp trials
            exp_condtemp(1:expTrial,2) = 1;  % 2 exp trial
            exp_condtemp(1:expTrial,3) = repmat(1:9,1,expTrial/9);  % 3 conscious condition
            exp_condtemp(1:expTrial,4) = repmat(1:2,1,expTrial/2);  % 4 face used
            exp_condtemp(1:expTrial/2,7) = 1;  % 7 staircase
            exp_condtemp(expTrial/2+1:expTrial,7) = 2;

            %catch trials
            catch_condtemp(1:catchTrial,2) = 0;  %2 catch trial
            catch_condtemp(1:catchTrial,3) = repmat(1:12,1,catchTrial/12); %3 condition
            for i = 1:catchTrial
                if catch_condtemp(i,3)<= 6 catch_condtemp(i,4) = 1; end %is white face
                if catch_condtemp(i,3)> 6 catch_condtemp(i,4) = 2; end %is black face
            end
            catch_condtemp(1:catchTrial/2,7) = 1;  % 7 staircase
            catch_condtemp(catchTrial/2+1:catchTrial,7) = 2;

            randIdx = randperm(expTrial+catchTrial);

            condList = zeros(expTrial+catchTrial,19); % nTrial cond testfaceNum judgement
            for i=1:expTrial+catchTrial
                condList(i,1) = i;
                if randIdx(i) <= expTrial
                    condList(i,2:7) = exp_condtemp(randIdx(i),2:7); end
                if randIdx(i) > expTrial
                    condList(i,2:7) = catch_condtemp(randIdx(i)-expTrial,2:7);end
            end
                
    %====== Load image ======%
        
        folder = './faces/';
        
        % conscious and unconscious stimuli
        for condition = 1:3
            whiteCon.file = dir([folder 'white_con' num2str(condition) '*.jpg']);
            blackCon.file = dir([folder 'black_con' num2str(condition) '*.jpg']);
            whiteUncon.file = dir([folder 'white_uncon' num2str(condition) '*.jpg']);
            blackUncon.file = dir([folder 'black_uncon' num2str(condition) '*.jpg']);
        end
        
        
        
        for condition = 1:3
            for faceNum = 1:4 
                whiteCon.img{condition,faceNum} = imread([folder whiteCon.file(faceNum).name]);
                whiteCon.tex{condition,faceNum} = Screen('MakeTexture',wPtr,whiteCon.img{condition,faceNum});
                blackCon.img{condition,faceNum} = imread([folder blackCon.file(faceNum).name]);
                blackCon.tex{condition,faceNum} = Screen('MakeTexture',wPtr,blackCon.img{condition,faceNum});
            end
        end
        
        
        
        for condition = 1:3
            for faceNum = 1:2
                whiteUncon.img{condition,faceNum} = imread([folder whiteUncon.file(faceNum).name]);
                whiteUncon.tex{condition,faceNum} = Screen('MakeTexture',wPtr,whiteUncon.img{condition,faceNum});
                blackUncon.img{condition,faceNum} = imread([folder blackUncon.file(faceNum).name]);
                blackUncon.tex{condition,faceNum} = Screen('MakeTexture',wPtr,blackUncon.img{condition,faceNum});
            end
        end
        
        
            
        % faces for catch trials
        catchFace.file = dir([folder 'catch*.jpg']);
        for faceNum = 1:12
            catchFace.img{faceNum} = imread([folder catchFace.file(faceNum).name]);
            catchFace.tex{faceNum} = Screen('MakeTexture',wPtr,catchFace.img{faceNum});
        end
        
        % mondrians
        mon.file = dir(['./Mon/*.JPG']);
        for i= 1:10
           mon.img{i} = imread(['./Mon/' mon.file(i).name]);
           mon.tex{i} = Screen('MakeTexture',wPtr,mon.img{i});        
        end
        

    %====== Position ======%
        
        % fixation box
        boxcolor=[255 255 255];
        boxsize = 140;
        disX = 180;
        
        %general posi
        cenX = width/2;
        cenY = height/2-325;
        L_cenX = cenX - disX;
        R_cenX = cenX + disX;
        BoxcenY = cenY;
        
        % pic size
        faceW = 38; %face half width 7:9
        faceH = 60; %face half height
        monW = 42;
        monH = 65;
        disX = 91;
        disY = 68;
        
        %     |--------|
        %     |  1 2 3 |
        %     |   .    |
        %     |  4 5 6 |
        %     |--------|
        
        % position for faces and mons
            L_Cen = [ [L_cenX-disX BoxcenY-disY];           
                        [  L_cenX      BoxcenY-disY];                
                        [  L_cenX+disX BoxcenY-disY];              
                        [  L_cenX-disX BoxcenY+disY];              
                        [  L_cenX      BoxcenY+disY];             
                        [  L_cenX+disX BoxcenY+disY];
                        ];

            R_Cen = [ [R_cenX-disX BoxcenY-disY];
                      [R_cenX      BoxcenY-disY];
                      [R_cenX+disX BoxcenY-disY];
                      [R_cenX-disX BoxcenY+disY];
                      [R_cenX      BoxcenY+disY];
                      [R_cenX+disX BoxcenY+disY];
                        ];
            for i = 1:6
                L_facePosi{i} = [L_Cen(i,1)-faceW  L_Cen(i,2)-faceH  L_Cen(i,1)+faceW L_Cen(i,2)+faceH];
                R_facePosi{i} = [R_Cen(i,1)-faceW  R_Cen(i,2)-faceH  R_Cen(i,1)+faceW R_Cen(i,2)+faceH];
                R_monPosi{i} = [R_Cen(i,1)-monW  R_Cen(i,2)-monH  R_Cen(i,1)+monW R_Cen(i,2)+monH];
                L_monPosi{i} = [L_Cen(i,1)-monW  L_Cen(i,2)-monH  L_Cen(i,1)+monW L_Cen(i,2)+monH];

            end

            FacePosi = cell(4);
            conMonPosi = cell(4);
            unconMonPosi = cell(4);

            if DemoEye == 1 %right eye
                FacePosi = L_facePosi;
                conMonPosi = L_monPosi;
                unconMonPosi = R_monPosi;
            end
            if DemoEye == 2 %left eye
                FacePosi = R_facePosi;
                conMonPosi = R_monPosi;
                unconMonPosi = L_monPosi;
            end
        
        % for reporting seen faces
            reportboxsize = 15;        
            reportdis = 30;
            L_reportbox = [[L_cenX-disX-15  BoxcenY-disY-10];
                          [      L_cenX-15  BoxcenY-disY-10];
                          [ L_cenX+disX-15  BoxcenY-disY-10];
                          [ L_cenX-disX-15  BoxcenY+disY-10];
                          [      L_cenX-15  BoxcenY+disY-10];
                          [ L_cenX+disX-15  BoxcenY+disY-10];
                          [ L_cenX+0.5*disX-15  BoxcenY+1.5*disY-10];
                        ];
            R_reportbox = [[R_cenX-disX-15  BoxcenY-disY-10];
                          [      R_cenX-15  BoxcenY-disY-10];
                          [ R_cenX+disX-15  BoxcenY-disY-10];
                          [ R_cenX-disX-15  BoxcenY+disY-10];
                          [      R_cenX-15  BoxcenY+disY-10];
                          [ R_cenX+disX-15  BoxcenY+disY-10];
                          [ R_cenX+0.5*disX-15  BoxcenY+1.5*disY-10];
                        ]; 

     %====== Time & Freq ======%
        monitorFlipInterval =Screen('GetFlipInterval', wPtr);
        refreshRate = round(1/monitorFlipInterval); % Monitor refreshrate
        MondFreq = 10; %Hz
        MondN  = round(refreshRate/MondFreq); % frames/img
        ConIncr=((255/((refreshRate*10)-1))/255)* 10; % 10% increase per second   
        
     %====== Experiment running ======%
     
        breakRate = [];
        numReportUnseen{1,1} = [0 0 0 0 0 0];
        numReportUnseen{1,2} = [0 0 0 0 0 0];
        numReportUnseen{2,1} = [0 0 0 0 0 0];
        numReportUnseen{2,2} = [0 0 0 0 0 0];           
        
        for i= 1:expTrial+catchTrial
            
            % -------hint for progress & taking break-------%
             
             if mod(i,65) == 1 && i~= 1
                 while 1
                    FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                    if i== 66, Writetext(wPtr,'20% done',L_cenX, R_cenX,BoxcenY, 120,100, [255 255 255],30); end
                    if i== 131, Writetext(wPtr,'40% done',L_cenX, R_cenX,BoxcenY, 120,100, [255 255 255],30); end
                    if i== 196, Writetext(wPtr,'60% done',L_cenX, R_cenX,BoxcenY, 120,100, [255 255 255],30); end
                    if i== 261, Writetext(wPtr,'80% done',L_cenX, R_cenX,BoxcenY, 120,100, [255 255 255],30); end
                    
                    Writetext(wPtr,'take a break',L_cenX, R_cenX,BoxcenY, 120,40, [255 255 255],30);
                    Writetext(wPtr,'press down to start',L_cenX, R_cenX,BoxcenY, 120, -50, [255 255 255],25);
                    Screen('Flip',wPtr);
                    KbEventFlush();
                    [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);
                    if secs(KbName(breakKey))
                        break; end
                 end 
             
             end
            
             
             % --------- Wait press space to start --------%
                while 1,
                    FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                    Writetext(wPtr,'press space to start ',L_cenX, R_cenX,BoxcenY, 100,100, [255 255 255],20);
                    Screen('Flip',wPtr);
                    KbEventFlush();
                    [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);
                    if secs(KbName(space)) break; end 
                end
                FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                Screen('Flip',wPtr);
                WaitSecs(1);
                
             % ------- Initialize data later to be saved--------%
                 answer = 0;
                 Seen = [0 0 0 0 0 0 0];
            
             % -------  Show faces and Mon ------%
             
                 MonIdx=1;
                 MonTimer = 0;
                 contrast = [0 0 0 0 0 0];
                 place = randperm(6);
                 isExpTrial = condList(i,2);
                 stimuliIdx = condList(i,4);
                 stairCaseToUse = condList(i,7);
                 condition = condList(i,3);
                 if condition == 1, conCon = 1; unCon = 1; end
                 if condition == 2, conCon = 2; unCon = 1; end
                 if condition == 3, conCon = 3; unCon = 1; end
                 if condition == 4, conCon = 1; unCon = 2; end
                 if condition == 5, conCon = 2; unCon = 2; end
                 if condition == 6, conCon = 3; unCon = 2; end
                 if condition == 7, conCon = 1; unCon = 3; end
                 if condition == 8, conCon = 2; unCon = 3; end
                 if condition == 9, conCon = 3; unCon = 3; end

                 
                 timezero = GetSecs; 
                 while GetSecs - timezero < 2
                     
                    Screen('BlendFunction', wPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
                    FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                    
                    %adjust contrast
                        
                        if isExpTrial
                            for j = 1:4
                                contrast(place(j)) = contrast(place(j)) + ConIncr;
                            end

                            for j = 5:6
                                if contrast(place(j))< faceOpc{stimuliIdx}(stairCaseToUse,j), contrast(place(j)) = contrast(place(j))+ConIncr; end
                                if contrast(place(j))>= faceOpc{stimuliIdx}(stairCaseToUse,j), contrast(place(j)) = faceOpc{stimuliIdx}(stairCaseToUse,j); end
                            end
                        end
                    
                    
                    %draw mondrians

                        for k = 1:4 %for conscious faces
                            Screen('DrawTexture', wPtr, mon.tex{MonIdx}, [], conMonPosi{place(k)},[],[],maskOpc); end              
                        for k = 5:6 %for unconscious faces
                            Screen('DrawTexture', wPtr, mon.tex{MonIdx}, [], unconMonPosi{place(k)},[],[],maskOpc); end

                    %draw faces

                        if isExpTrial && stimuliIdx == 1 %white face
                            for k=1:4 %conscious faces
                                    Screen('DrawTexture', wPtr, whiteCon.tex{conCon,k}, [], FacePosi{place(k)},[],[],conOpc);
                            end;
                            
                            for k=1:2 %unconscious faces
                                    Screen('DrawTexture', wPtr, whiteUncon.tex{unCon,k}, [], FacePosi{place(k+4)},[],[],contrast(place(k+4)));
                            end
                        end
                        
                        if isExpTrial && stimuliIdx == 2 %blackface
                            for k=1:4 %conscious faces
                                    Screen('DrawTexture', wPtr, blackCon.tex{conCon,k}, [], FacePosi{place(k)},[],[],conOpc);
                            end;
                            
                            for k=1:2 %unconscious faces
                                    Screen('DrawTexture', wPtr, blackUncon.tex{unCon,k}, [], FacePosi{place(k+4)},[],[],contrast(place(k+4)));
                            end
                        end
                        
                        if ~isExpTrial %is catch trial
                            for k=1:4  %catch conscious faces
                                Screen('DrawTexture', wPtr, catchFace.tex{condition}, [], FacePosi{place(k)},[],[],conOpc);
                            end
                        end
                                 

                    Screen('Flip',wPtr); % now visible on screen
                    
                    %Control Mon frequency
                    if MonTimer == 0,
                        MonIdx = MonIdx+1 ;
                        if MonIdx == 11, MonIdx = 1; end
                    end
                    MonTimer = MonTimer +1;
                    MonTimer = mod(MonTimer,MondN);
                 end

            % delay
                FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                Screen('Flip',wPtr); % now visible on screen
                WaitSecs(.5);
                
            % -------------make emotion judgement-------------%
            
                waitForAnswer = 1;
                timezero = GetSecs;
                while waitForAnswer
                     
                    % show emotion judgement screen
                        FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                        Writetext(wPtr,'Emotion',L_cenX, R_cenX,BoxcenY, 40,100, [255 255 255],20);
                        Writetext(wPtr,'very',L_cenX, R_cenX,BoxcenY, 105,25, [255 255 255],20);
                        Writetext(wPtr,'negative',L_cenX, R_cenX,BoxcenY, 120,0, [255 255 255],20);
                        Writetext(wPtr,'very',L_cenX, R_cenX,BoxcenY, -55,25, [255 255 255],20);
                        Writetext(wPtr,'positive',L_cenX, R_cenX,BoxcenY, -45,0, [255 255 255],20);
                        Writetext(wPtr, num2str(answer), L_cenX, R_cenX, BoxcenY, 5-answer*(boxsize-20)/10,-60, [255 255 255],20);
                        SelectionBar(wPtr,L_cenX,R_cenX,BoxcenY, boxsize, answer);
                        Screen('Flip',wPtr);
                        
                    % get keyboard response
                        KbEventFlush();
                        [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);

                        if  keyIsDown
                            % left right
                            if secs(KbName(leftkey))-timezero > 0
                                if answer > -10, answer = answer-1; end
                            end
                            if secs(KbName(rightkey))-timezero >0
                                if answer < 10, answer = answer+1; end
                            end

                            % space pressed
                            if secs(KbName(space))-timezero>0.5, waitForAnswer = 0;
                            end

                            % ESC pressed
                            if secs(KbName(quitkey))
                                CreateFile(fName, condList);
                                Screen('CloseAll');
                                return;
                            end
                        end 
                end
                
          %-------Report visible locations------%

            waitForAnswer = 1; 
            timezero = GetSecs;
            forgetLocation = 0;
            while waitForAnswer
               % show visibility report screen
                    FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                    Writetext(wPtr,'Location',L_cenX, R_cenX,BoxcenY, 40,120, [255 255 255],20);
                    Writetext(wPtr,'1',L_cenX, R_cenX,BoxcenY,  disX+5,  disY+5, [255 255 255],20);
                    Writetext(wPtr,'2',L_cenX, R_cenX,BoxcenY,       5,  disY+5, [255 255 255],20);
                    Writetext(wPtr,'3',L_cenX, R_cenX,BoxcenY, -disX+5,  disY+5, [255 255 255],20);
                    Writetext(wPtr,'4',L_cenX, R_cenX,BoxcenY,  disX+5, -disY+5, [255 255 255],20);
                    Writetext(wPtr,'5',L_cenX, R_cenX,BoxcenY,       5, -disY+5, [255 255 255],20);
                    Writetext(wPtr,'6',L_cenX, R_cenX,BoxcenY, -disX+5, -disY+5, [255 255 255],20);
                    Writetext(wPtr,'? forget',L_cenX, R_cenX,BoxcenY, -0.5*disX+5, -1.5*disY+5, [255 255 255],20);
                    
                    for j = 1:7
                        if Seen(j) SelectionBox(wPtr,L_reportbox(j,1),R_reportbox(j,1), L_reportbox(j,2),reportboxsize,boxcolor); end
                    end
                    Screen('Flip',wPtr);

                %get keyboard response
                    KbEventFlush();
                    [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);

                    if  keyIsDown
                        % report seen faces
                        for j= 1:7
                           if secs(KbName(placeKey{j})) Seen(j) = ~Seen(j); end 
                        end

                        % space pressed
                        if secs(KbName(space))-timezero > 0.5,  waitForAnswer = 0; end
                        % ESC pressed
                        if secs(KbName(quitkey))
                            CreateFile(fName, condList);
                            Screen('CloseAll');
                            return;
                        end
                    end 
            end
            
           % decide is break trials or not
           if Seen(place(5)) || Seen(place(6))  isBreak = 1;
           else isBreak = 0; end

           for j = 1:4 % didnt report seeing conscious faces
                if ~Seen(place(j)) isBreak = 2; end
           end

           if ~isExpTrial %you see a face out of nothing?
               if Seen(place(5)) || Seen(place(6)) isBreak = 3; end
           end

           if(Seen(7))
               forgetLocation = 1;
               isBreak = 4; end

               
            %1 trial number
            %2 isExptrial 1 / isCatchTrial 0
            %3 condition
            %4 face used
            %5 judgement***
            %6 break***
            %7 staircase
            %8-13 contrast ****
            %14-19 seen
            
            % Save Result
                condList(i,5) = answer;
                condList(i,6) = isBreak;
                if isBreak~=0 breakRate(end+1) = 1; end
                for j=1:6, condList(i,j+7) = faceOpc{stimuliIdx}(stairCaseToUse,j); end
                condList(i,14:19) = Seen(1:6);
             
            % Monitoring
                disp('-------------------------------')
                disp('trial condition: ');
                disp(condList(i,1:7));
                disp('threshold: ');
                disp(condList(i,8:13));
                disp(Seen);
                disp('break rate:');
                disp(mean(breakRate));
                
             %------ Adjust Threshold -----%
             
             if isExpTrial && ~forgetLocation && (isBreak == 0 || isBreak == 1)
                for j = 5:6
                  % seen, decrease
                  idx = place(j);
                  if(Seen(idx))
                     faceOpc{stimuliIdx}(stairCaseToUse,idx) = faceOpc{stimuliIdx}(stairCaseToUse,idx)-stepsize_down;
                     if faceOpc{stimuliIdx}(stairCaseToUse,idx) <= lowerBound, faceOpc{stimuliIdx}(stairCaseToUse,idx) = lowerBound; end
                     numReportUnseen{stimuliIdx,stairCaseToUse}(idx) = 0;
                  end
                    
                  % unseen, increase
                  if(~Seen(idx)) && isBreak == 0
                     numReportUnseen{stimuliIdx,stairCaseToUse}(idx) = numReportUnseen{stimuliIdx,stairCaseToUse}(idx) +1;
                     if numReportUnseen{stimuliIdx,stairCaseToUse}(idx) == stairCase_up;
                         faceOpc{stimuliIdx}(stairCaseToUse,idx) = faceOpc{stimuliIdx}(stairCaseToUse,idx) + stepsize_up;
                         if faceOpc{stimuliIdx}(stairCaseToUse,idx) >= upperBound, faceOpc{stimuliIdx}(stairCaseToUse,idx) = upperBound; end
                         numReportUnseen{stimuliIdx,stairCaseToUse}(idx) = 0;
                     end
                  end
                end 
             end
            

        end %end of experiment

    %===== Write Results and Quit =====%
        CreateFile(fName, condList);
        Screen('CloseAll');
        return;
    

catch
    disp('*******Error Catched*******')
    Screen('CloseAll');
    CreateFile(fName, condList);
    return;
end
        