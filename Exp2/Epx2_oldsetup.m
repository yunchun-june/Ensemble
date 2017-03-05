
clear all;
close all;

try
    
    %====== Input ======%
        subjNo                = input('subjNo: ','s');
        DemoEye               = input('DomEye Right 1 Left 2:');
        keymode               = input('keymode1 MAC keymode2 Dell 3 EEG:');
        fName = ['./Data/Ensem2_result_' subjNo '.txt'];
        
    %====== initial condition =====% 
        
        
        
        for i = 1:6
            faceOpc{1}(1,i) = 0.2;  faceOpc{1}(2,i) = 0.1;  % white faces
            faceOpc{2}(1,i) = 0.7;  faceOpc{2}(2,i) = 0.3;  % black faces
        end
        
        maskOpc = 1;
        runTrials = 480;
        disX = 165;
        
        lowerBound = 0.02;
        upperBound = 1.00;
        stepsize_down = 0.04;
        stepsize_up = 0.02;
        stairCase_up = 2;
        
        
    %====== Setup Screen ======%
        screid = max(Screen('Screens'));
        [wPtr, screenRect]=Screen('OpenWindow',screid, 0,[],32,2); % open screen
        [width height] = Screen('WindowSize', wPtr); %get windows size

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

        leftkey = 'LeftArrow';
        rightkey = 'RightArrow';
        
        placeKey{1} = '4';
        placeKey{2} = '5';
        placeKey{3} = '6';
        placeKey{4} = '1';
        placeKey{5} = '2';
        placeKey{6} = '3';

     %====== Experimental Condition ======%

            repeatNum = 15;
            condNum = 9;
            person_used = 2;

            nTrials = repeatNum * condNum;

                     %conscious   unconscious
                     %frea happy  fear happy

            contemp = [ [ 3    1       2   0 ]
                        [ 2    2       2   0 ]
                        [ 1    3       2   0 ]
                        [ 3    1       1   1 ]
                        [ 2    2       1   1 ]
                        [ 1    3       1   1 ]
                        [ 3    1       0   2 ]
                        [ 2    2       0   2 ]
                        [ 1    3       0   2 ] ];

            for i=1:9
                cond.conF{i} = contemp(i,1);
                cond.conH{i} = contemp(i,2);
                cond.unconF{i} = contemp(i,3);
                cond.unconH{i} = contemp(i,4);
            end

            % set up condition list

                %[condList]
                %1 trial number
                %2 condition
                %3 face Used
                %4 judgement
                %5 break
                %6 staircase
                %7-12 contrast 

                temp = zeros(nTrials,9);
                temp(1:nTrials,2) = repmat(1:9,1,repeatNum);
                randInx = randperm(nTrials);

                condList = zeros(nTrials,9); % nTrial cond testfaceNum judgement
                for i=1:nTrials
                    condList(i,1) = i;
                    condList(i,2) = temp(randInx(i),2);
                end

                %decide face index
                for i = 1:nTrials
                    %conscious faces
                    condition = condList(i,2);

                    if cond.conF{condition} == 3
                        randNum = randi([1 23]);
                        conIdx = [25 -25 -25+randNum -25-randNum];
                    end

                    if cond.conF{condition} == 2
                        randNum = randi([2 50], 1, 2);
                        conIdx = [randNum(1) randNum(2) -randNum(1) -randNum(2)];

                    end

                    if cond.conF{condition} == 1
                        randNum = randi([1 23]);
                        conIdx = [-25 25 25+randNum 25-randNum];    
                    end

                    %unconscious faces
                    unconIdx = [ 0 0 ];
                    if cond.unconF{condition} == 0, unconIdx = [ 50  50]; end
                    if cond.unconF{condition} == 1, unconIdx = [-50  50]; end
                    if cond.unconF{condition} == 2, unconIdx = [-50 -50]; end

                    index = [ conIdx unconIdx];                                

                    condList(i,3:8) = repmat(index,1,1);
                end                 
        
                
                disp(condList);
                
    %====== Load image ======%
        
        folder = './faces/';
        % faces
        whiteHappy.file = dir([folder 'Ahappy*.jpg']);
        for i= 1:50
           whiteHappy.img{i} = imread([folder whiteHappy.file(i).name]);
           whiteHappy.tex{i} = Screen('MakeTexture',wPtr,whiteHappy.img{i});        
        end        
        
        whiteFearful.file = dir([folder 'Afear*.jpg']);
        for i= 1:50
           whiteFearful.img{i} = imread([folder whiteFearful.file(i).name]);
           whiteFearful.tex{i} = Screen('MakeTexture',wPtr,whiteFearful.img{i});        
        end          
        
        blackHappy.file = dir([folder 'Fhappy*.jpg']);
        for i= 1:50
           blackHappy.img{i} = imread([folder blackHappy.file(i).name]);
           blackHappy.tex{i} = Screen('MakeTexture',wPtr,blackHappy.img{i});        
        end        
        
        blackFearful.file = dir([folder 'Afear*.jpg']);
        for i= 1:50
           blackFearful.img{i} = imread([folder blackFearful.file(i).name]);
           blackFearful.tex{i} = Screen('MakeTexture',wPtr,blackFearful.img{i});        
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
        boxsize = 80;
        disX = 165;
        
        %general posi
        cenX = width/2;
        cenY = height/2-150;
        L_cenX = cenX - disX;
        R_cenX = cenX + disX;
        BoxcenY = cenY;
        
        % pic size
        faceW = 20; %face half width 7:9
        faceH = 34; %face half height
        monW = 24;
        monH = 37;
        disX = 52;
        disY = 39;
        
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
            reportboxsize = 13;        
            reportdis = 30;
            L_reportbox = [[L_cenX-disX-15  BoxcenY-disY-10];
                          [      L_cenX-15  BoxcenY-disY-10];
                          [ L_cenX+disX-15  BoxcenY-disY-10];
                          [ L_cenX-disX-15  BoxcenY+disY-10];
                          [      L_cenX-15  BoxcenY+disY-10];
                          [ L_cenX+disX-15  BoxcenY+disY-10];
                        ];
            R_reportbox = [[R_cenX-disX-15  BoxcenY-disY-10];
                          [      R_cenX-15  BoxcenY-disY-10];
                          [ R_cenX+disX-15  BoxcenY-disY-10];
                          [ R_cenX-disX-15  BoxcenY+disY-10];
                          [      R_cenX-15  BoxcenY+disY-10];
                          [ R_cenX+disX-15  BoxcenY+disY-10];
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
        
        for i= 1:100
            
            % -------hint for progress & taking break-------%
             
             if mod(i,100) == 1 && i~= 1
                 while 1
                    FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                    if i== 101, Writetext(wPtr,'20% done',L_cenX, R_cenX,BoxcenY, 70,50, [255 255 255],20); end
                    if i== 201, Writetext(wPtr,'40% done',L_cenX, R_cenX,BoxcenY, 70,50, [255 255 255],20); end
                    if i== 301, Writetext(wPtr,'60% done',L_cenX, R_cenX,BoxcenY, 70,50, [255 255 255],20); end
                    if i== 401, Writetext(wPtr,'80% done',L_cenX, R_cenX,BoxcenY, 70,50, [255 255 255],20); end
                    
                    Writetext(wPtr,'take a break',L_cenX, R_cenX,BoxcenY, 70,15, [255 255 255],20);
                    Writetext(wPtr,'press down to start',L_cenX, R_cenX,BoxcenY, 70,-25, [255 255 255],15);
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
                    Writetext(wPtr,'press space to start ',L_cenX, R_cenX,BoxcenY, 70,60, [255 255 255],15);
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
                 Seen = [0 0 0 0 0 0];
            
             % -------  Show faces and Mon ------%
                 conIdx = condList(i,3:6);
                 unconIdx = condList(i,7:8);
                 place = randperm(6);
                 MonIdx=1;
                 MonTimer = 0;
                 contrast = [0 0 0 0 0 0];
                 stimuliIdx = 1;
                 stairCaseToUse = 1;

                 timezero = GetSecs; 
                 while GetSecs - timezero < 1.5  %show faces for one sec
                    Screen('BlendFunction', wPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
                    FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                    
                    %adjust contrast
                    for j = 1:4
                        contrast(place(j)) = contrast(place(j)) + ConIncr;
                    end
                    
                    for j = 5:6
                        if contrast(place(j))< faceOpc{stimuliIdx}(stairCaseToUse,j), contrast(place(j)) = contrast(place(j))+ConIncr;end
                        if contrast(place(j))>= faceOpc{stimuliIdx}(stairCaseToUse,j), contrast(place(j)) = faceOpc{stimuliIdx}(stairCaseToUse,j); end
                    end
                    
                    
                        %draw mondrians
                        
                            for k = 1:4 %for conscious faces
                                Screen('DrawTexture', wPtr, mon.tex{MonIdx}, [], conMonPosi{place(k)},[],[],maskOpc); end              
                            for k = 5:6 %for unconscious faces
                                Screen('DrawTexture', wPtr, mon.tex{MonIdx}, [], unconMonPosi{place(k)},[],[],maskOpc); end

                        %draw faces

                        for k=1:4 %conscious faces
                            if conIdx(k) >0 
                                Screen('DrawTexture', wPtr, whiteHappy.tex{conIdx(k)}, [], FacePosi{place(k)},[],[],maskOpc); end
                            if conIdx(k) <0 
                                Screen('DrawTexture', wPtr, whiteFearful.tex{-conIdx(k)}, [], FacePosi{place(k)},[],[],maskOpc); end
                        end;

                        for k=1:2 %unconscious faces
                            if unconIdx(k) >0 
                                Screen('DrawTexture', wPtr, whiteHappy.tex{50}, [], FacePosi{place(k+4)},[],[],contrast(place(k+4))); end
                            if unconIdx(k) <0 
                                Screen('DrawTexture', wPtr, whiteFearful.tex{50}, [], FacePosi{place(k+4)},[],[],contrast(place(k+4))); end
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
                        Writetext(wPtr,'Emotion',L_cenX, R_cenX,BoxcenY, 30,60, [255 255 255],15);
                        Writetext(wPtr,'very',L_cenX, R_cenX,BoxcenY, 65,10, [255 255 255],15);
                        Writetext(wPtr,'negative',L_cenX, R_cenX,BoxcenY, 70,-10, [255 255 255],15);
                        Writetext(wPtr,'very',L_cenX, R_cenX,BoxcenY, -25,10, [255 255 255],15);
                        Writetext(wPtr,'positive',L_cenX, R_cenX,BoxcenY, -20,-10, [255 255 255],15);
                        Writetext(wPtr, num2str(answer), L_cenX, R_cenX, BoxcenY, 5-answer*(boxsize-20)/10,-60, [255 255 255],15);
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
                            if secs(KbName(rightkey))-timezero > 0
                                if answer < 10, answer = answer+1; end
                            end

                            % space pressed
                            if secs(KbName(space))-timezero>0, waitForAnswer = 0;

                            end
                            % break key pressed
                            if secs(KbName(breakKey))-timezero > 0, noBreak = 0; end

                            % ESC pressed
                            if secs(KbName(quitkey))
                                CreateFile(fName, condList);
                                Screen('CloseAll'); %Closes Screen
                                return;
                            end
                        end 
                end
                
          %-------Break Trials & Report visible locations------%

            waitForAnswer = 1; 
            while waitForAnswer
               % show visibility report screen
                    FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                    Writetext(wPtr,'Location',L_cenX, R_cenX,BoxcenY, 25,70, [255 255 255],14);
                    Writetext(wPtr,'1',L_cenX, R_cenX,BoxcenY,  disX+5,  disY+5, [255 255 255],14);
                    Writetext(wPtr,'2',L_cenX, R_cenX,BoxcenY,       5,  disY+5, [255 255 255],14);
                    Writetext(wPtr,'3',L_cenX, R_cenX,BoxcenY, -disX+5,  disY+5, [255 255 255],14);
                    Writetext(wPtr,'4',L_cenX, R_cenX,BoxcenY,  disX+5, -disY+5, [255 255 255],14);
                    Writetext(wPtr,'5',L_cenX, R_cenX,BoxcenY,       5, -disY+5, [255 255 255],14);
                    Writetext(wPtr,'6',L_cenX, R_cenX,BoxcenY, -disX+5, -disY+5, [255 255 255],14);
                    
                    for j = 1:6
                        if Seen(j) SelectionBox(wPtr,L_reportbox(j,1),R_reportbox(j,1), L_reportbox(j,2),reportboxsize,boxcolor); end
                    end
                    Screen('Flip',wPtr);

                %get keyboard response
                    KbEventFlush();
                    [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);

                    if  keyIsDown
                        % report seen faces
                        for j= 1:6
                           if secs(KbName(placeKey{j})) Seen(j) = ~Seen(j); end 
                        end

                        % space pressed
                        if secs(KbName(space)),  waitForAnswer = 0; end

                    end 
            end
             
             %------ Adjust Threshold -----%
                for j = 1:6
                  % seen, decrease
                  if(Seen(j))
                     faceOpc{stimuliIdx}(stairCaseToUse,j) = faceOpc{stimuliIdx}(stairCaseToUse,j)-stepsize_down;
                     if faceOpc{stimuliIdx}(stairCaseToUse,j) <= lowerBound, faceOpc{stimuliIdx}(stairCaseToUse,j) = lowerBound; end
                     numReportUnseen{stimuliIdx,stairCaseToUse}(j) = 0;
                  end
                    
                  % unseen, increase
                  if(~Seen(j))
                     numReportUnseen{stimuliIdx,stairCaseToUse}(j) = numReportUnseen{stimuliIdx,stairCaseToUse}(j) +1;
                     if numReportUnseen{stimuliIdx,stairCaseToUse}(j) == stairCase_up;
                         faceOpc{stimuliIdx}(stairCaseToUse,j) = faceOpc{stimuliIdx}(stairCaseToUse,j) + stepsize_up;
                         if faceOpc{stimuliIdx}(stairCaseToUse,j) >= upperBound, faceOpc{stimuliIdx}(stairCaseToUse,j) = upperBound; end
                         numReportUnseen{stimuliIdx,stairCaseToUse}(j) = 0;
                     end
                  end
                end 
            

        end %end of experiment
        
        
        

    %===== Write Results and Quit =====%
        CreateFile(fName, condList);
        Screen('CloseAll');
        return;

catch
    Screen('CloseAll');
    rethrow(lasterror);
    return;
end
        