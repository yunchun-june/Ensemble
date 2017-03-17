
clear all;
close all;

try
    
    %====== Input ======%
        subjNo                = input('subjNo: ','s');
        DemoEye               = input('DomEye Right 1 Left 2:');
        keymode               = input('keymode1 MAC keymode2 Dell:');
        fName_1 = ['./Data/prac_result_' subjNo '.txt'];
        fName_2 = ['./Data/prac_thr_' subjNo '.txt'];
    
    %====== initial threshold =====% 
        faceOpc(1) = 1.5;
        faceOpc(2) = 1.5;
        faceOpc(3) = 1.5;
        faceOpc(4) = 1.5;
        stepsize = 0.04;
        
    %====== Setup Screen ======%
        screid = max(Screen('Screens'));
        [wPtr, screenRect]=Screen('OpenWindow',screid, 0,[],32,2); % open screen
        [width, height] = Screen('WindowSize', wPtr); %get windows size 
        
    %===== Devices======%
    
        if keymode==1
            targetUsageName = 'Keyboard';
            targetProduct = 'Apple Keyboard';
            dev=PsychHID('Devices');
            devInd = find(strcmpi(targetUsageName, {dev.usageName}) & strcmpi(targetProduct, {dev.product}));
        elseif keymode==2
            targetUsageName = 'Keyboard';
            targetProduct = 'USB Keykoard';
            dev=PsychHID('Devices');
            devInd = find(strcmpi(targetUsageName, {dev.usageName}) & strcmpi(targetProduct, {dev.product}));
        end
        KbQueueCreate(devInd);  
        KbQueueStart(devInd);
    %======Keyboard======%
     
        KbName('UnifyKeyNames');
        quitkey = 'ESCAPE';
        space   = 'space';   

        leftkey = 'LeftArrow';
        rightkey = 'RightArrow';
        
        placeKey{1} = '4';
        placeKey{2} = '5';
        placeKey{3} = '1';
        placeKey{4} = '2';
    
    %====== Load image ======%
    
        % stimuli faces
        folder = './faces/';
        
        for i=1:2
            faceNum = num2str(i);
            happyface.img{i} = imread([folder 'happy' faceNum '.jpg']);
            happyface.tex{i} = Screen('MakeTexture',wPtr,happyface.img{i});
            fearfulface.img{i} = imread([folder 'fearful' faceNum '.jpg']); 
            fearfulface.tex{i} = Screen('MakeTexture',wPtr,fearfulface.img{i});
        end
        
        % test faces
        for j=1:2
            faceNum = num2str(j);
            test{j}.file = dir([folder 'test' faceNum '_*.jpg']);
            for i= 1:7
               test{j}.img{i} = imread([folder test{j}.file(i).name]);
               test{j}.tex{i} = Screen('MakeTexture',wPtr,test{j}.img{i});        
            end
        end

        % mondrians
        mon.file = dir('./Mon/*.JPG');
        for i= 1:10
           mon.img{i} = imread(['./Mon/' mon.file(i).name]);
           mon.tex{i} = Screen('MakeTexture',wPtr,mon.img{i});        
        end
 
    %====== Position ======%

        % general setup
            cenX = width/2;
            cenY = height/2-150;
            disX = 220;
            L_cenX = cenX - disX;
            R_cenX = cenX + disX;
            BoxcenY = cenY;
            faceW = 56; %face width 7:9
            faceH = 63; %face height

            boxcolor=[255 255 255];
            boxsize = 80;
            m = 3; %margin
        
        % for stimuli face
            if DemoEye == 1 %Left eye
                postList = [
                    [L_cenX-faceW BoxcenY-faceH L_cenX-m BoxcenY-m];   %  face1 face2 
                    [L_cenX+m BoxcenY-faceH L_cenX+faceW BoxcenY-m];   %     center
                    [L_cenX-faceW BoxcenY+m   L_cenX-m BoxcenY+faceH]; %  face3 face4
                    [L_cenX+m BoxcenY+m   L_cenX+faceW BoxcenY+faceH];
                ];
                %monPosi = [R_cenX-faceW BoxcenY-faceH R_cenX+faceW BoxcenY+faceH];
                monPosi = [
                    [R_cenX-faceW BoxcenY-faceH R_cenX-m BoxcenY-m];
                    [R_cenX+m BoxcenY-faceH R_cenX+faceW BoxcenY-m];
                    [R_cenX-faceW BoxcenY+m   R_cenX-m BoxcenY+faceH]; 
                    [R_cenX+m BoxcenY+m   R_cenX+faceW BoxcenY+faceH];
                ];
            end        

            if DemoEye == 2 % Right eye
                postList = [
                    [R_cenX-faceW BoxcenY-faceH R_cenX-m BoxcenY-m];
                    [R_cenX+m BoxcenY-faceH R_cenX+faceW BoxcenY-m];
                    [R_cenX-faceW BoxcenY+m   R_cenX-m BoxcenY+faceH];
                    [R_cenX+m BoxcenY+m   R_cenX+faceW BoxcenY+faceH];
                ];
                %monPosi = [L_cenX-faceW BoxcenY-faceH L_cenX+faceW BoxcenY+faceH];
                monPosi = [
                    [L_cenX-faceW BoxcenY-faceH L_cenX-m BoxcenY-m];   %  face1 face2 
                    [L_cenX+m BoxcenY-faceH L_cenX+faceW BoxcenY-m];   %     center
                    [L_cenX-faceW BoxcenY+m   L_cenX-m BoxcenY+faceH]; %  face3 face4
                    [L_cenX+m BoxcenY+m   L_cenX+faceW BoxcenY+faceH];
                ];
            end     
        
        % for test faces
            testPosi_L = [L_cenX-faceW BoxcenY-faceH L_cenX+faceW BoxcenY+faceH];
            testPosi_R = [R_cenX-faceW BoxcenY-faceH R_cenX+faceW BoxcenY+faceH];
        
        % for reporting seen faces
            reportboxsize = 13;        
            reportdis = 30;
            L_report = [ [L_cenX-reportdis-15 BoxcenY-reportdis-10];
                          [L_cenX+reportdis-15 BoxcenY-reportdis-10];
                          [L_cenX-reportdis-15 BoxcenY+reportdis-10];
                          [L_cenX+reportdis-15 BoxcenY+reportdis-10];
                        ];
            R_report = [ [R_cenX-reportdis-15 BoxcenY-reportdis-10];
                          [R_cenX+reportdis-15 BoxcenY-reportdis-10];
                          [R_cenX-reportdis-15 BoxcenY+reportdis-10];
                          [R_cenX+reportdis-15 BoxcenY+reportdis-10];
                        ];
    
    %====== Experimental Condition ======%
        
        repeat = 5;
        testfaceNum = 7;
        facesUsed = 2;
        condNum = 5;
        expTrials = repeat * testfaceNum * condNum * facesUsed;
        
        condition = [%fearful  happy
                      [ 4       0 ]    %1
                      [ 3       1 ]    %2
                      [ 2       2 ]    %3
                      [ 1       3 ]    %4
                      [ 0       4 ] ]; %5

        % set up condition lists
            %1 trialnumver 
            %2 condition
            %3 testfaceNum
            %4 stimuli face
            %5 test face
            %6 result
            %7 isBreakTrials
        
            temp = zeros(expTrials,7); 
            temp(1:expTrials,3) = repmat(1:7,1, expTrials/7);
            for i=1:5
                temp((i-1)*expTrials/condNum+1 : i*expTrials/condNum , 2) = repmat(i,1,expTrials/condNum); end
            for i            =1:5
                temp(70*(i-1)+1: 70*i-35, 4) = ones(1, repeat*7);
                temp(70*(i-1)+1: 70*i-35, 5) = repmat(2, 1, repeat*7);
                temp(70*i-34: 70*i,4) = repmat(2, 1, repeat*7);
                temp(70*i-34: 70*i,5) = ones(1, repeat*7);
            end
           
            randInx = randperm(expTrials); % random permutation
            condList = zeros(expTrials,7);
            
            for i= 1:expTrials
                condList(i,1) = i;
                condList(i,2:5) = temp(randInx(i),2:5);
                %condList(i,6) = condList(i,3)+condList(i,2);
            end 

     %====== Time & Freq ======%
        monitorFlipInterval =Screen('GetFlipInterval', wPtr);
        refreshRate = round(1/monitorFlipInterval); % Monitor refreshrate
        MondFreq = 10; %Hz
        MondN  = round(refreshRate/MondFreq); % frames/img
        
     %====== Stimuli Face Threshold ======%
        % =======
        % | 1 2 |
        % | 3 4 |
        % =======
        
        ConIncr= 7.5 /(10*refreshRate); % 7.5% increase per second
        
        numReportUnseen = [0 0 0 0];
        thresholdData = zeros(expTrials,8);
        
     %====== Experiment running ======%
        
        breakRate = [];
     
        for i= 1:30
            
             % press space to start
                while 1
                    FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                    Writetext(wPtr,'press space to start ',L_cenX, R_cenX,BoxcenY, 70,60, [255 255 255],15);
                    if i== 70, Writetext(wPtr,'20% done',L_cenX, R_cenX,BoxcenY, 70,0, [255 255 255],24); end
                    if i== 140, Writetext(wPtr,'40% done',L_cenX, R_cenX,BoxcenY, 70,0, [255 255 255],24); end
                    if i== 210, Writetext(wPtr,'60% done',L_cenX, R_cenX,BoxcenY, 70,0, [255 255 255],24); end
                    if i== 280, Writetext(wPtr,'80% done',L_cenX, R_cenX,BoxcenY, 70,0, [255 255 255],24); end

                    Screen('Flip',wPtr);
                    KbEventFlush();
                    [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);
                    if secs(KbName(space))
                        break; end 
                end
                
                %delay
                FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                Screen('Flip',wPtr);
                WaitSecs(1);
                
             % Show faces and Mon
                    
                 place = randperm(4);
                 fearfulNum = condition(condList(i,2),1); %how many fearful faces
                 happyNum = condition(condList(i,2),2); %how many happy faces
                 stimuliIdx = condList(i,4); %which face to use
                 testIdx = condList(i,5); %which face to use
                 
                 MonIdx=1;
                 MonTimer = 0;
                 contrast = [0 0 0 0];
                 timezero = GetSecs;
                 noBreak = 1;
                 
                 while GetSecs - timezero < 1 && noBreak  %show faces for 1 sec
                    FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                    Screen('BlendFunction', wPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
                    
                    for j = 1:4 %adjust contrast
                        if contrast(j)< faceOpc(j), contrast(j) = contrast(j)+ConIncr;end
                        if contrast(j)> faceOpc(j), contrast(j) = faceOpc(j); end
                    end
                    
                    %draw faces
                        j=1;
                        if fearfulNum ~= 0
                             for k=1:fearfulNum
                                Screen('DrawTexture', wPtr, fearfulface.tex{stimuliIdx}, [], postList(place(j),:),[],[],contrast(place(j)));
                                j = j+1;
                             end
                        end

                        if happyNum ~= 0
                             for k=1:happyNum
                                 Screen('DrawTexture', wPtr, happyface.tex{stimuliIdx}, [], postList(place(j),:),[],[],contrast(place(j)));
                                j = j+1;
                             end
                        end

                    %draw Mondrians
                    for j=1:4
                        Screen('DrawTexture', wPtr, mon.tex{MonIdx}, [], monPosi(j,:),[],[],2-faceOpc(j));
                    end
                    
                    if MonTimer == 0
                        MonIdx = MonIdx+1 ;
                        if MonIdx == 11, MonIdx = 1; end
                    end
                    MonTimer = MonTimer +1;
                    MonTimer = mod(MonTimer,MondN);
                    
                    Screen('Flip',wPtr); % now visible on screen
                    
                    KbEventFlush();
                    [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);
                    if secs(KbName(space))-timezero > 0, noBreak = 0; end
                    if secs(KbName(quitkey))
                            CreateFile(fName_1, condList);
                            CreateFile_thr(fName_2, thresholdData);
                            ListenChar(0); %makes it so characters typed do show up in the command window
                            Screen('CloseAll'); %Closes Screen
                            return;
                    end
                    
                 end
                 
            
                % delay
                while GetSecs-timezero < 1.8
                    FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                    Screen('Flip',wPtr); % now visible on screen
                    KbEventFlush();
                    [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);
                    if secs(KbName(space))-timezero > 0, noBreak = 0; end
                    
                end
            
            answer = 0;
            if noBreak == 1 %didnt break mon, make emotion judgement
                 

            % show test face for 100ms
                timeShow = GetSecs;
                FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                Screen('DrawTexture',wPtr, test{testIdx}.tex{condList(i,3)}, [], testPosi_L);
                Screen('DrawTexture',wPtr, test{testIdx}.tex{condList(i,3)}, [], testPosi_R);
                Screen('Flip',wPtr);
                WaitSecs(.1);
            
            % delay
                FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                Screen('Flip',wPtr); % now visible on screen
                WaitSecs(.5);        
            
            % make judgement    
                waitForAnswer = 1;
                timezero = GetSecs;
                 while waitForAnswer
                    KbEventFlush();
                    [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);

                    if  keyIsDown
                        % left right
                        if secs(KbName(leftkey))
                            if answer > -10, answer = answer-1; end
                        end
                        if secs(KbName(rightkey))
                            if answer < 10, answer = answer+1; end
                        end
                            
                        % down pressed
                        if secs(KbName(space))-timezero>0, waitForAnswer = 0;
                           
                        end
                        
                        % ESC pressed
                        if secs(KbName(quitkey))
                            CreateFile(fName_1, condList);
                            CreateFile_thr(fName_2, thresholdData);
                            ListenChar(0); %makes it so characters typed do show up in the command window
                            Screen('CloseAll'); %Closes Screen
                            return;
                        end

                    end 
                    
                    % show text and current answer
                    FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                    Writetext(wPtr,'Emotion',L_cenX, R_cenX,BoxcenY, 30,60, [255 255 255],15);
                    Writetext(wPtr,'very',L_cenX, R_cenX,BoxcenY, 65,10, [255 255 255],15);
                    Writetext(wPtr,'negative',L_cenX, R_cenX,BoxcenY, 70,-10, [255 255 255],15);
                    Writetext(wPtr,'very',L_cenX, R_cenX,BoxcenY, -25,10, [255 255 255],15);
                    Writetext(wPtr,'positive',L_cenX, R_cenX,BoxcenY, -20,-10, [255 255 255],15);
                    Writetext(wPtr, num2str(answer), L_cenX, R_cenX, BoxcenY, 5-answer*(boxsize-20)/10,-60, [255 255 255],15);
                    
                    SelectionBar(wPtr,L_cenX,R_cenX,BoxcenY, boxsize, answer);
                    
                    Screen('Flip',wPtr);
                 end
            
            end      
            
            Seen = [0 0 0 0];
            
            if noBreak == 0
                
            % Report Faces Visibility
             waitForAnswer = 1;
                 while waitForAnswer
                    KbEventFlush();
                    [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);

                    if  keyIsDown
                        % report seen faces
                        for j= 1:4
                           if secs(KbName(placeKey{j})) Seen(j) = ~Seen(j); end 
                        end
                        
                        % space pressed
                        if secs(KbName(space)),  waitForAnswer = 0; end
                        
                        % ESC pressed
                        if secs(KbName(quitkey))
                            CreateFile(fName_1, condList);
                            CreateFile_thr(fName_2, thresholdData);
                            ListenChar(0); %makes it so characters typed do show up in the command window
                            Screen('CloseAll'); %Closes Screen
                            return;
                        end

                    end
                    
                    %show text and current answer
                        FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                        Writetext(wPtr,'Location',L_cenX, R_cenX,BoxcenY, 25,70, [255 255 255],14);
                        Writetext(wPtr,'1',L_cenX, R_cenX,BoxcenY, reportdis+5,reportdis+5, [255 255 255],14);
                        Writetext(wPtr,'2',L_cenX, R_cenX,BoxcenY, -reportdis+5,reportdis+5, [255 255 255],14);
                        Writetext(wPtr,'3',L_cenX, R_cenX,BoxcenY, reportdis+5,-reportdis+5, [255 255 255],14);
                        Writetext(wPtr,'4',L_cenX, R_cenX,BoxcenY, -reportdis+5,-reportdis+5, [255 255 255],14);
                        for j = 1:4 
                            if Seen(j) SelectionBox(wPtr,L_report(j,1),R_report(j,1), L_report(j,2),reportboxsize,boxcolor); end
                        end
                        Screen('Flip',wPtr);
                    end    
            end
            
            
            % Save Result
             condList(i,6) = answer;
             condList(i,7) = ~noBreak;
             breakRate(end+1) = noBreak;
             for j=1:4 thresholdData(i,j) = faceOpc(j); end
             thresholdData(i,5:8) = Seen(1:4);
             
            %online monitor
             disp('-------------------------------')
             disp('trial condition: ');
             disp(condList(i,1:7));
             disp('threshold: ');
             disp(thresholdData(i,1:4));
             disp('break rate:');
             disp(1-mean(breakRate));
            
            %adjust upperbound
            for j = 1:4
                  if(Seen(j))
                     faceOpc(j) = faceOpc(j)-stepsize;
                     if faceOpc(j)<0, faceOpc(j)=0; end
                     numReportUnseen(j) = 0;
                  end
                  
                  if(~Seen(j))
                     numReportUnseen(j) = numReportUnseen(j) +1;
                     if numReportUnseen(j) == 2
                         faceOpc(j) = faceOpc(j) + stepsize;
                         if faceOpc(j) >= 2, faceOpc(j) = 2; end
                         numReportUnseen(j) = 0;
                     end
                  end
            end

        end %end of experiment

    %===== Write Results and Quit =====%
        CreateFile(fName_1, condList);
        CreateFile_thr(fName_2, thresholdData);
        ListenChar(0); %makes it so characters typed do show up in the command window
        Screen('CloseAll'); %Closes Screen  
        return;

catch
    CreateFile(fName_1, condList);
    CreateFile_thr(fName_2, thresholdData);
    ListenChar(0); %makes it so characters typed do show up in the command window
    Screen('CloseAll'); %Closes Screen
    return;
end




