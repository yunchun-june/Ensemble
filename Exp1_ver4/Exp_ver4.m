clear all;
close all;

Screen('Preference', 'SkipSyncTests', 1);

try

%====== Customize for each subject =====% 

    faceCon(1,1) = 0.6;  faceCon(2,1) = 0.2;
    faceCon(1,2) = 0.6;  faceCon(2,2) = 0.2;
    faceCon(1,3) = 0.6;  faceCon(2,3) = 0.2;
    faceCon(1,4) = 0.6;  faceCon(2,4) = 0.2;
    maskOpc      = 1;
    boxDistance  = 210;
    
%====== Input ======%
    subjNo          = input('subjNo: ','s');
    dominantEye     = input('DonimantEye (Right 1 Left 2):');
    keyboard        = input('keyboard (MAC1 Dell2 EEG3):');
    filePath = ['./Data/Ensem_result_' subjNo '.txt'];  
    
%====== Some Constant ======%
    
    RIGHT = 1;
    LEFT = 2;
    TRUE = 1;
    FALSE = 0;
    
%====== Content of Result File =======%

%   column name    colunm number  
    IS_EXP_TRIAL    =1;
    ENSEM           =2;
    TARGET          =3;
    JUDGEMENT       =4;
    DONE            =5;
    STAIRCASE       =6;
    CON(1)          =7;
    CON(2)          =8;
    CON(3)          =9;
    CON(4)          =10;
    SEEN(1)         =11;
    SEEN(2)         =12;
    SEEN(3)         =13;
    SEEN(4)         =14;
    REPEAT          =15;
    PLACE(1)        =16; 
    PLACE(2)        =17;
    PLACE(3)        =18;
    PLACE(4)        =19;
    
    resultFileColNum = 19; 
 
%====== Experimental Design ======%
    
    %--- Thresholding Procedure ---%
    lowerBound      = 0.02;
    upperBound      = 1.00;     
    stepsize_down	= 0.04; 
    stepsize_up     = 0.02;    
    stairCase_up	= 2; %2up1down
    stairCaseNum    = 2;
    
    waitTime        = 60;
    
    %--- Experiment Condition ---%
    targetFaceNum       = 6;
    blankFaceNum        = 10;
    ensemConditionNum   = 5;
    exp_rep             = 6;
    blank_rep           = 5;
    expTrialNumInBlock      = targetFaceNum*exp_rep;
    blankTrialNumInBlock    = blankFaceNum*blank_rep/ensemConditionNum;
    trialNumInBlock         = expTrialNumInBlock + blankTrialNumInBlock;
    
    %--- Generate Condition List ---%
    condList = cell(5);
    for block = 1:ensemConditionNum
        expTrialIndex   = 1:expTrialNumInBlock;
        blankTrialIndex = expTrialNumInBlock+1:trialNumInBlock;
        
        temp = zeros(trialNumInBlock,resultFileColNum);
        temp(1:trialNumInBlock,ENSEM)         = block;
        temp(expTrialIndex    ,IS_EXP_TRIAL)  = 1;
        temp(expTrialIndex    ,TARGET)        = repmat(1:targetFaceNum,1,expTrialNumInBlock/targetFaceNum);
        temp(expTrialIndex    ,STAIRCASE)     = repmat(1:stairCaseNum,1,expTrialNumInBlock/stairCaseNum);
        
        temp(blankTrialIndex  ,IS_EXP_TRIAL) = 0;
        temp(blankTrialIndex  ,TARGET)       = repmat(1:blankFaceNum,1,blank_rep/ensemConditionNum);
        temp(blankTrialIndex  ,STAIRCASE)    = 0;
        
        randomIndex = randperm(trialNumInBlock);
        for i = 1:trialNumInBlock
            condList{block}(end+1,:) = temp(randomIndex(i),:);
        end
    end
    
%====== Setup Screen & Keyboard ======%

    screid = max(Screen('Screens'));
    [wPtr, screenRect]=Screen('OpenWindow',screid, 0,[],32,2);
    [width, height] = Screen('WindowSize', wPtr);
    
    if keyboard==1, targetProduct = 'Apple Keyboard'; end
    if keyboard==2, targetProduct = 'USB Keykoard'; end
    if keyboard==3, targetProduct = 'Dell USB Keyboard'; end
    
    targetUsageName = 'Keyboard';
    dev=PsychHID('Devices');
    devInd = find(strcmpi(targetUsageName, {dev.usageName}) & strcmpi(targetProduct, {dev.product}));
    KbQueueCreate(devInd);  
    KbQueueStart(devInd);

%======Keyboard Setup======%

    KbName('UnifyKeyNames');
    quitkey     = 'ESCAPE';
    space       = 'space';
    breakKey    = 'DownArrow';
    leftkey     = 'LeftArrow';
    rightkey	= 'RightArrow';

    placeKey(1) = '4';
    placeKey(2) = '5';
    placeKey(3) = '1';
    placeKey(4) = '2';
    
%====== Position ======%

    % general setup
    cenX = width/2;
    cenY = height/2-150;
    L_cenX = cenX - boxDistance;
    R_cenX = cenX + boxDistance;
    BoxcenY = cenY;

    ensumFaceWidth = 56;
    ensumFaceHeight = 63;
    boxcolor=[255 255 255];
    boxsize = 80;
    margin = 3;
   
    if dominantEye == RIGHT
        ensemFacePosi = [
            [L_cenX-ensumFaceWidth	BoxcenY-ensumFaceHeight	L_cenX-margin           BoxcenY-margin];
            [L_cenX+margin          BoxcenY-ensumFaceHeight	L_cenX+ensumFaceWidth   BoxcenY-margin];
            [L_cenX-ensumFaceWidth	BoxcenY+margin          L_cenX-margin           BoxcenY+ensumFaceHeight];
            [L_cenX+margin          BoxcenY+margin          L_cenX+ensumFaceWidth	BoxcenY+ensumFaceHeight];
        ];

        monPosi = [
            [R_cenX-ensumFaceWidth  BoxcenY-ensumFaceHeight R_cenX-margin           BoxcenY-margin];
            [R_cenX+margin          BoxcenY-ensumFaceHeight R_cenX+ensumFaceWidth	BoxcenY-margin];
            [R_cenX-ensumFaceWidth  BoxcenY+margin          R_cenX-margin           BoxcenY+ensumFaceHeight]; 
            [R_cenX+margin          BoxcenY+margin          R_cenX+ensumFaceWidth	BoxcenY+ensumFaceHeight];
        ];
    end        

    if dominantEye == LEFT
        ensemFacePosi = [
            [R_cenX-ensumFaceWidth  BoxcenY-ensumFaceHeight	R_cenX-margin           BoxcenY-margin];
            [R_cenX+margin          BoxcenY-ensumFaceHeight	R_cenX+ensumFaceWidth	BoxcenY-margin];
            [R_cenX-ensumFaceWidth	BoxcenY+margin          R_cenX-margin           BoxcenY+ensumFaceHeight];
            [R_cenX+margin          BoxcenY+margin          R_cenX+ensumFaceWidth	BoxcenY+ensumFaceHeight];
        ];
        monPosi = [
            [L_cenX-ensumFaceWidth	BoxcenY-ensumFaceHeight	L_cenX-margin           BoxcenY-margin];
            [L_cenX+margin          BoxcenY-ensumFaceHeight	L_cenX+ensumFaceWidth	BoxcenY-margin];
            [L_cenX-ensumFaceWidth	BoxcenY+margin          L_cenX-margin           BoxcenY+ensumFaceHeight];
            [L_cenX+margin          BoxcenY+margin          L_cenX+ensumFaceWidth	BoxcenY+ensumFaceHeight];
        ];
    end     

    targetFacePosi_L = [L_cenX-ensumFaceWidth BoxcenY-ensumFaceHeight L_cenX+ensumFaceWidth BoxcenY+ensumFaceHeight];
    targetFacePosi_R = [R_cenX-ensumFaceWidth BoxcenY-ensumFaceHeight R_cenX+ensumFaceWidth BoxcenY+ensumFaceHeight];

    % the selection box for reporting seen faces
    reportBoxSize = 13;        
    reportdis = 30;
    L_reportBoxPosi = [ [L_cenX-reportdis-15 BoxcenY-reportdis-10];
                        [L_cenX+reportdis-15 BoxcenY-reportdis-10];
                        [L_cenX-reportdis-15 BoxcenY+reportdis-10];
                        [L_cenX+reportdis-15 BoxcenY+reportdis-10];
                      ];
    R_reportBoxPosi = [ [R_cenX-reportdis-15 BoxcenY-reportdis-10];
                        [R_cenX+reportdis-15 BoxcenY-reportdis-10];
                        [R_cenX-reportdis-15 BoxcenY+reportdis-10];
                        [R_cenX+reportdis-15 BoxcenY+reportdis-10];
                      ];

%====== Time & Freq ======%

    monitorFlipInterval =Screen('GetFlipInterval', wPtr);
    refreshRate = round(1/monitorFlipInterval); % Monitor refreshrate
    MondFreq = 10; %Hz
    MondN  = round(refreshRate/MondFreq); % frames/img
    ConIncr= 7.5 /(10*refreshRate); % 7.5% increase per second

%====== Load image ======%

    % ------Target Faces(exp trials)-----%
    folder = './faces/target/';
    load mandrill
        targetFace.file = dir([folder 'target*.jpg']);
        for i= 1:length(targetFace.file)
           targetFace.img{i} = imread([folder targetFace.file(i).name]);
           targetFace.tex{i} = Screen('MakeTexture',wPtr,targetFace.img{i});
           
           %create scramble mask
           im =  double(targetFace.img{i})/255;
           targetMask.img{i} = imscramble(im,0.75,'range');
           im = uint8(targetMask.img{i}*255);
           targetMask.tex{i} = Screen('MakeTexture',wPtr,im);
        end
    
    % ------ Target Faces(blank trials) ------%
    folder = './faces/blank/';
    load mandrill
        blankFace.file = dir([folder 'blank*.jpg']);
        for i= 1:length(blankFace.file)
           blankFace.img{i} = imread([folder blankFace.file(i).name]);
           blankFace.tex{i} = Screen('MakeTexture',wPtr,blankFace.img{i});
           
           %create scramble mask
           im =  double(blankFace.img{i})/255;
           catchMask.img{i} = imscramble(im,0.75,'range');
           im = uint8(catchMask.img{i}*255);
           catchMask.tex{i} = Screen('MakeTexture',wPtr,im);
        end   
     
    % -------- Ensemble Faces ---------%
    folder = './faces/ensem/';
        for i = 1:5
            ensemFace.file = dir([folder 'con' num2str(i) '_*.jpg']);
            for p = 1:4
            ensemFace.img{i,p} = imread([folder ensemFace.file(p).name]);
            ensemFace.tex{i,p} = Screen('MakeTexture',wPtr,ensemFace.img{i,p});
            end
        end
        
    % --------Mondrians--------%
    mon.file = dir('./Mon/*.JPG');
    for i= 1:10
       mon.img{i} = imread(['./Mon/' mon.file(i).name]);
       mon.tex{i} = Screen('MakeTexture',wPtr,mon.img{i});        
    end
    
%====== Start of the Experiment ======%

    resultList = zeros(0,19);
    breakRate = [];
    numReportUnseen{1} = [0 0 0 0];
    numReportUnseen{2} = [0 0 0 0];
    
    block_randomIndex = randperm(5);
    doneBlockNum = 0;
    
    for block = block_randomIndex
        
        %---- Conpulsory Resting Between Blocks ---%
        keepWaiting = TRUE;
        timeLimit = GetSecs+waitTime;
        while keepWaiting && doneBlockNum ~= 0
            remainingTime = ceil(timeLimit-GetSecs);
            FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
            if doneBlockNum == 1, Writetext(wPtr,'20% done',L_cenX, R_cenX,BoxcenY, 70,50, [255 255 255],20); end
            if doneBlockNum == 2, Writetext(wPtr,'40% done',L_cenX, R_cenX,BoxcenY, 70,50, [255 255 255],20); end
            if doneBlockNum == 3, Writetext(wPtr,'60% done',L_cenX, R_cenX,BoxcenY, 70,50, [255 255 255],20); end
            if doneBlockNum == 4, Writetext(wPtr,'80% done',L_cenX, R_cenX,BoxcenY, 70,50, [255 255 255],20); end
            Writetext(wPtr,'take a rest',L_cenX, R_cenX,BoxcenY, 70,15, [255 255 255],20);

            if remainingTime > 0
                Writetext(wPtr,[num2str(remainingTime) 's'],L_cenX, R_cenX,BoxcenY, 30,-25, [255 255 255],20);
            else
                Writetext(wPtr,'press down to start',L_cenX, R_cenX,BoxcenY, 70,-25, [255 255 255],15);  
                KbEventFlush();
                [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);
                if secs(KbName(breakKey)) keepWaiting = FALSE; end 
            end
            
            %ESC pressed
            [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);
            if secs(KbName(quitkey))
                CreateFile(filePath, resultList);
                Screen('CloseAll');
                return;
            end
            
            Screen('Flip',wPtr);
        end
        
        %======== start of the block =======% 
        
        blockUnDone = TRUE;
        while(blockUnDone)
            for i = 1:trialNumInBlock
                if condList{block}(i,DONE) continue; end
                
                %-----Initialize Trials----%

                     ensemCon   = condList{block}(i,ENSEM);
                     targetFace = condList{block}(i,TARGET);
                     stair      = condList{block}(i,STAIRCASE);
                     isExp      = condList{block}(i,IS_EXP_TRIAL);
                     
                     answer     = 0;
                     noBreak    = TRUE;
                     seen       = [FALSE FALSE FALSE FALSE];
                     randPosi   = randperm(4);
                
                % --------Press Space To Start----------%
                while TRUE
                    FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                    Writetext(wPtr,'press space to start ',L_cenX, R_cenX,BoxcenY, 70,60, [255 255 255],15);
                    Screen('Flip',wPtr);
                    
                    KbEventFlush();
                    [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);
                    if secs(KbName(space)) break; end
                    
                    %ESC pressed
                    if secs(KbName(quitkey))
                        CreateFile(filePath, resultList);
                        Screen('CloseAll');
                        return;
                    end
                end
                
                %delay
                FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                Screen('Flip',wPtr);
                WaitSecs(1);
                
                % -------- Show Ensembles Faces & CFS -----------%
                
                 MonIdx     = 1;
                 MonTimer   = 0;
                 contrast   = [0 0 0 0];
                 timezero   = GetSecs;

                 %show supressed faces for 1 sec
                 while GetSecs-timezero < 1 && noBreak
                    FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                    Screen('BlendFunction', wPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

                    %adjust contract and draw faces
                    if isExp
                        for p = 1:4
                            if contrast(p)< faceCon(stair,p), contrast(p) = contrast(p)+ConIncr;end
                            if contrast(p)>= faceCon(stair,p), contrast(p) = faceCon(stair,p); end
                            Screen('DrawTexture', wPtr, ensemFace.tex{ensemCon,p}, [], ensemFacePosi(randPosi(p),:),[],[],contrast(randPosi(p)));
                        end
                    end

                    %Draw Mondrians
                    for p = 1:4
                        Screen('DrawTexture', wPtr, mon.tex{MonIdx}, [], monPosi(p,:),[],[],maskOpc);
                    end
                    
                    % Adjust Mondrians
                    if MonTimer == 0
                        MonIdx = MonIdx+1 ;
                        if MonIdx == 11, MonIdx = 1; end         
                    end
                    MonTimer = MonTimer +1;
                    MonTimer = mod(MonTimer,MondN);

                    Screen('Flip',wPtr);

                    % catch response
                    KbEventFlush();
                    [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);
                    if secs(KbName(breakKey))-timezero > 0, noBreak = FALSE; end
                    if secs(KbName(quitkey))
                        CreateFile(filePath, resultList);
                        Screen('CloseAll');
                        return;
                    end
                 end
                 
            
                % delay 500ms
                while GetSecs-timezero < 1.5 && noBreak
                    FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                    Screen('Flip',wPtr);
                    KbEventFlush();

                    % catch response
                    [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);
                    if secs(KbName(breakKey))-timezero > 0, noBreak = 0; end
                end
                
                % --------- show target face and scramble mask---------%
                
                    timezero = GetSecs;
                    while GetSecs-timezero < 0.1 && noBreak && isExp
                        FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                        Screen('DrawTexture',wPtr, targetFace.tex{targetFace}, [], targetFacePosi_L);
                        Screen('DrawTexture',wPtr, targetFace.tex{targetFace}, [], targetFacePosi_R);
                        Screen('Flip',wPtr);
                    end
                    
                    while GetSecs-timezero < 0.2 && noBreak &&  ~isExp
                        FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                        Screen('DrawTexture',wPtr, blankFace.tex{targetFace}, [], targetFacePosi_L);
                        Screen('DrawTexture',wPtr, blankFace.tex{targetFace}, [], targetFacePosi_R);
                        Screen('Flip',wPtr);
                    end
                       
                    timezero = GetSecs;
                    while GetSecs-timezero < 0.1 && noBreak && isExp
                        FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                        Screen('DrawTexture',wPtr, targetMask.tex{targetFace}, [], targetFacePosi_L);
                        Screen('DrawTexture',wPtr, targetMask.tex{targetFace}, [], targetFacePosi_R);
                        Screen('Flip',wPtr);
                    end

                    while GetSecs-timezero < 0.1 && noBreak && ~isExp
                        FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                        Screen('DrawTexture',wPtr, catchMask.tex{targetFace}, [], targetFacePosi_L);
                        Screen('DrawTexture',wPtr, catchMask.tex{targetFace}, [], targetFacePosi_R);
                        Screen('Flip',wPtr);
                    end
                    
                    % delay
                    FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                    Screen('Flip',wPtr);
                    WaitSecs(.5);
                    
                % -------------make emotion judgement-------------%

                    waitForAnswer = TRUE;
                    timezero = GetSecs;
                    while waitForAnswer && noBreak
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
                                if secs(KbName(space))-timezero>0, waitForAnswer = 0;end

                                % break key pressed
                                if secs(KbName(breakKey))-timezero > 0, noBreak = 0; end

                                % ESC pressed
                                if secs(KbName(quitkey))
                                    CreateFile(filePath, resultList);
                                    Screen('CloseAll');
                                    return;
                                end
                            end 
                    end

                %-------Break Trials & Report visible locations------%
            
                    waitForAnswer = TRUE; 
                    while waitForAnswer && ~noBreak
                       % show visibility report screen
                            FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                            Writetext(wPtr,'Location',L_cenX, R_cenX,BoxcenY, 25,70, [255 255 255],14);
                            Writetext(wPtr,'1',L_cenX, R_cenX,BoxcenY, reportdis+5,reportdis+5, [255 255 255],14);
                            Writetext(wPtr,'2',L_cenX, R_cenX,BoxcenY, -reportdis+5,reportdis+5, [255 255 255],14);
                            Writetext(wPtr,'3',L_cenX, R_cenX,BoxcenY, reportdis+5,-reportdis+5, [255 255 255],14);
                            Writetext(wPtr,'4',L_cenX, R_cenX,BoxcenY, -reportdis+5,-reportdis+5, [255 255 255],14);
                            for p = 1:4 
                                if seen(p) SelectionBox(wPtr,L_reportBoxPosi(p,1),R_reportBoxPosi(p,1), L_reportBoxPosi(p,2),reportBoxSize,boxcolor); end
                            end
                            Screen('Flip',wPtr);

                        %get keyboard response
                            KbEventFlush();
                            [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);

                            if  keyIsDown
                                % report seen faces
                                for p= 1:4
                                   if secs(KbName(placeKey(p))) seen(p) = ~seen(p); end 
                                end

                                % space pressed
                                if secs(KbName(space)),  waitForAnswer = 0; end

                                % ESC pressed
                                if secs(KbName(quitkey))
                                    CreateFile(filePath, resultList);
                                    Screen('CloseAll'); %Closes Screen  
                                    return;
                                end
                            end 
                    end 
                    
                    
                %--------- Save Result to Result List----------%
                    condList{block}(i,JUDGEMENT)        = answer;
                    condList{block}(i,DONE)             = noBreak;
                    condList{block}(i,SEEN(:))          = seen(:);
                    condList{block}(i,PLACE(:))         = randPosi(:);
                    if isExp condList{block}(i,CON(:))  = faceCon(stair,:); end
                    condList{block}(i,REPEAT)           = condList{block}(i,REPEAT)+1;
                    resultList(end+1,:)                 = condList{block}(i,:);
                    
                %---------- Monitoring ----------%
                    disp('-------------------------------')
                    disp('trial condition: ');
                    disp(condList{block}(i,1:6));
                    disp('threshold: ');
                    disp(condList{block}(i,CON(:)));
                    disp(condList{block}(i,SEEN(:)));
                    disp('block complete');
                    disp([num2str(doneBlockNum) '   ' num2str(sum(condList{block}(:,DONE))) '/' num2str(trialNumInBlock/5)]);
                    disp('break rate')
                    disp(1-mean(resultList(:,DONE)));
                    
                %---------- Adjust Threshold ----------%
                    for p = 1:4
                      % seen, decrease
                      if(seen(p)) && isExp
                         faceCon(stair,p) = faceCon(stair,p)-stepsize_down;
                         if faceCon(stair,p) <= lowerBound, faceCon(stair,p) = lowerBound; end
                         numReportUnseen{stair}(p) = 0;
                      end

                      % unseen, increase
                      if(~seen(p)) && isExp
                         numReportUnseen{stair}(p) = numReportUnseen{stair}(p) +1;
                         if numReportUnseen{stair}(p) == stairCase_up;
                             faceCon(stair,p) = faceCon(stair,p) + stepsize_up;
                             if faceCon(stair,p) >= upperBound, faceCon(stair,p) = upperBound; end
                             numReportUnseen{stair}(p) = 0;
                         end
                      end
                    end     
                
            end %end of trials
            blockUnDone = sum(condList{block}(:,DONE)) ~= trialNumInBlock;
        end %end of the block
        
        doneBlockNum = doneBlockNum+1;
    end
        
    
%===== Write Results and Quit =====%
    
    CreateFile(filePath, resultList);
    Screen('CloseAll');
    return;

catch exception
    Screen('CloseAll');
    disp('*** ERROR DETECTED ***');
    disp(getReport(exception));
    CreateFile(filePath, resultList);
    return;
end