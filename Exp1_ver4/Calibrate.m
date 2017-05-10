clear all;
close all;
addpath('./function/');

Screen('Preference', 'SkipSyncTests', 1);

try
    
%====== Input ======%

    dominantEye               = input('Dominant Eye (1/right 2/left):');
    ensemble                  = input('Supressed Faces (1/4H 5/4F):');
    keyboard                  = input('Keyboard (1/MAC 2/Dell 3/EEG):');

%====== initial condition =====% 

    faceOpc = [1 1 1 1];
    maskOpc = 1;
    disX = 210;

    lowerBound = 0.02; 
    upperBound = 1.00;     
    stepsize_down = 0.1;
    stepsize_up = 0.1;   
    stairCase_up = 2;
    
    TRUE = 1;
    FALSE = 0;

%====== Setup Screen & Keyboard ======%
    screid = max(Screen('Screens'));
    [wPtr, screenRect]=Screen('OpenWindow',screid, 0,[],32,2);
    [width, height] = Screen('WindowSize', wPtr);

    if keyboard==1,
        targetUsageName = 'Keyboard';
        targetProduct = 'Apple Keyboard';
        dev=PsychHID('Devices');
        devInd = find(strcmpi(targetUsageName, {dev.usageName}) & strcmpi(targetProduct, {dev.product}));
    elseif keyboard==2, 
        targetUsageName = 'Keyboard';
        targetProduct = 'USB Keykoard';
        dev=PsychHID('Devices');
        devInd = find(strcmpi(targetUsageName, {dev.usageName}) & strcmpi(targetProduct, {dev.product}));
    elseif keyboard==3,
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
        
        placeKey{1} = 'a';
        placeKey{2} = 's';
        placeKey{3} = 'z';
        placeKey{4} = 'x';
    
%====== Position ======%

    % general setup
        cenX = width/2;
        cenY = height/2-150;
        L_cenX = cenX - disX;
        R_cenX = cenX + disX;
        BoxcenY = cenY;
        faceW = 56; %face width 7:9
        faceH = 63; %face height

        boxcolor=[255 255 255];
        boxsize = 80;
        m = 3; %margin

    % for stimuli face
        if dominantEye == 1 %Left eye
            facePosi = [
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

        if dominantEye == 2 % Right eye
            facePosi = [
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
        targetPosi_L = [L_cenX-faceW BoxcenY-faceH L_cenX+faceW BoxcenY+faceH];
        targetPosi_R = [R_cenX-faceW BoxcenY-faceH R_cenX+faceW BoxcenY+faceH];

    % for reporting seen faces
        reportboxsize = 13;        
        reportdis = 30;
        L_reportbox = [ [L_cenX-reportdis-15 BoxcenY-reportdis-10];
                      [L_cenX+reportdis-15 BoxcenY-reportdis-10];
                      [L_cenX-reportdis-15 BoxcenY+reportdis-10];
                      [L_cenX+reportdis-15 BoxcenY+reportdis-10];
                    ];
        R_reportbox = [ [R_cenX-reportdis-15 BoxcenY-reportdis-10];
                      [R_cenX+reportdis-15 BoxcenY-reportdis-10];
                      [R_cenX-reportdis-15 BoxcenY+reportdis-10];
                      [R_cenX+reportdis-15 BoxcenY+reportdis-10];
                    ];
    
%====== Experimental Condition ======%

    targetFaceNum = 6;
    catchFaceNum = 10;
    conditionNum = 5;
    rep = 6;
    catch_rep = 10;
    expTrialNum = targetFaceNum*conditionNum*rep;
    catchTrialNum = catchFaceNum*catch_rep;
    
    trials = expTrialNum + catchTrialNum;
    
    EXP_CATCH   =1;
    ENSEM       =2;
    TARGET      =3;
    RESPONSE    =4;
    DONE        =5;
    STAIR       =6;
    OPC(1)      =7;
    OPC(2)      =8;
    OPC(3)      =9;
    OPC(4)      =10;
    SEEN(1)     =11;
    SEEN(2)     =12;
    SEEN(3)     =13;
    SEEN(4)     =14;
    REPEAT      =15;
    
    
    condList = cell(5);
    for block = 1:5
        temp = zeros(trials/5,15);
        temp(1:expTrialNum/5,EXP_CATCH) = 1;
        temp(1:trials/5,ENSEM) = block;
        temp(1:expTrialNum/5,TARGET) = repmat(1:6,1,expTrialNum/(5*6));
        temp(1:expTrialNum/5,STAIR) = repmat(1:2,1,expTrialNum/(5*2));
        
        temp(expTrialNum/5+1:trials/5,EXP_CATCH) = 0;
        temp(expTrialNum/5+1:trials/5,TARGET) =  repmat(1:catchFaceNum,1,2);
        temp(expTrialNum/5+1:trials/5,STAIR) = 1;
       
        temp_random = randperm(trials/5);
        
        for i = 1:trials/5
            condList{block}(end+1,:) = temp(temp_random(i),:);
        end
    end
    
    thrList = zeros(0,5);
    
%====== Time & Freq ======%
    monitorFlipInterval =Screen('GetFlipInterval', wPtr);
    refreshRate = round(1/monitorFlipInterval); % Monitor refreshrate
    MondFreq = 10; %Hz
    MondN  = round(refreshRate/MondFreq); % frames/img
    ConIncr= 7.5 /(10*refreshRate); % 7.5% increase per second

%====== Load image ======% 
     
    % ensumble faces
    folder = './faces/ensem/';
        for i = 1:5
            ensemFace.file = dir([folder 'con' num2str(i) '_*.jpg']);
            for posi = 1:4
            ensemFace.img{i,posi} = imread([folder ensemFace.file(posi).name]);
            ensemFace.tex{i,posi} = Screen('MakeTexture',wPtr,ensemFace.img{i,posi});
            end
        end
        
    % mondrians
    mon.file = dir('./Mon/*.JPG');
    for i= 1:10
       mon.img{i} = imread(['./Mon/' mon.file(i).name]);
       mon.tex{i} = Screen('MakeTexture',wPtr,mon.img{i});        
    end
    
%====== Experiment running ======%
    
    breakRate = [];
    numReportUnseen = [0 0 0 0];
    
    block = ensemble;
    %======== start of the block =======% 
        
        while TRUE
            for i = 1:trials/5  
                if condList{block}(i,EXP_CATCH)==0 continue; end
                if condList{block}(i,DONE) continue; end
                
                % --------press space to start----------%
                while TRUE
                    FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                    Writetext(wPtr,'press space to start ',L_cenX, R_cenX,BoxcenY, 70,60, [255 255 255],15);
                    Screen('Flip',wPtr);
                    KbEventFlush();
                    [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);
                    if secs(KbName(space)) break; end 
                end
                
                %delay
                FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                Screen('Flip',wPtr);
                WaitSecs(1);
                
                % --------Show faces and Mon ------------%
                
                     noBreak = TRUE;
                     seen = [FALSE FALSE FALSE FALSE];

                     % inititialize group face & Mon
                     randPlace = randperm(4);
                     ensemIdx = condList{block}(i,ENSEM);
                     targetIdx = condList{block}(i,TARGET);
                     isExp = condList{block}(i,EXP_CATCH);

                     MonIdx=1;
                     MonTimer = 0;
                     contrast = [0 0 0 0]; %initial contrast
                     timezero = GetSecs;

                     %show supressed faces for 1 sec
                     while GetSecs - timezero < 1 && noBreak
                        FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                        Screen('BlendFunction', wPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

                        %adjust contract and draw faces
                        if isExp
                            for p = 1:4
                                if contrast(p)< faceOpc(p), contrast(p) = contrast(p)+ConIncr;end
                                if contrast(p)>= faceOpc(p), contrast(p) = faceOpc(p); end
                                Screen('DrawTexture', wPtr, ensemFace.tex{ensemIdx,p}, [], facePosi(randPlace(p),:),[],[],contrast(randPlace(p)));
                            end
                        end

                        %draw and adjust mondrians
                        for p = 1:4
                            Screen('DrawTexture', wPtr, mon.tex{MonIdx}, [], monPosi(p,:),[],[],maskOpc); end
                        if MonTimer == 0
                            MonIdx = MonIdx+1 ;
                            if MonIdx == 11, MonIdx = 1; end         
                        end
                        MonTimer = MonTimer +1;
                        MonTimer = mod(MonTimer,MondN);

                        % make visible on Screen
                        Screen('Flip',wPtr);

                        % catch response
                        KbEventFlush();
                        [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);
                        if secs(KbName(quitkey))
                            Screen('CloseAll'); %Closes Screen  
                            return;
                        end
                     end
                 
            
                    % delay 500ms
                    while GetSecs-timezero < 1.5 && noBreak
                        FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                        Screen('Flip',wPtr);
                        KbEventFlush();
                    end
                     
                    
                %-------Break Trials & Report visible locations------%
            
                    waitForAnswer = TRUE; 
                    while waitForAnswer
                       % show visibility report screen
                            FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                            Writetext(wPtr,'Location',L_cenX, R_cenX,BoxcenY, 25,70, [255 255 255],14);
                            Writetext(wPtr,'1',L_cenX, R_cenX,BoxcenY, reportdis+5,reportdis+5, [255 255 255],14);
                            Writetext(wPtr,'2',L_cenX, R_cenX,BoxcenY, -reportdis+5,reportdis+5, [255 255 255],14);
                            Writetext(wPtr,'3',L_cenX, R_cenX,BoxcenY, reportdis+5,-reportdis+5, [255 255 255],14);
                            Writetext(wPtr,'4',L_cenX, R_cenX,BoxcenY, -reportdis+5,-reportdis+5, [255 255 255],14);
                            for posi = 1:4 
                                if seen(posi) SelectionBox(wPtr,L_reportbox(posi,1),R_reportbox(posi,1), L_reportbox(posi,2),reportboxsize,boxcolor); end
                            end
                            Screen('Flip',wPtr);

                        %get keyboard response
                            KbEventFlush();
                            [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);

                            if  keyIsDown
                                % report seen faces
                                for posi= 1:4
                                   if secs(KbName(placeKey{posi})) seen(posi) = ~seen(posi); end 
                                end

                                % space pressed
                                if secs(KbName(space)),  waitForAnswer = FALSE; end

                                % ESC pressed
                                if secs(KbName(quitkey))
                                    Screen('CloseAll'); %Closes Screen  
                                    return;
                                end
                            end 
                    end
                    
                %--------- Save Result to Result List----------%
                   condList{block}(i,OPC(:))  = faceOpc(:);
                   condList{block}(i,SEEN(:))  = seen(:);
                
                %---------- Monitoring ----------%
                    disp('-------------------------------')
                    disp('threshold: ');
                    disp(condList{block}(i,OPC(:)));
                    disp(condList{block}(i,SEEN(:)));
                    
                %---------- Adjust Threshold ----------%
                    for posi = 1:4
                      % seen, decrease
                      if(seen(posi)) && isExp
                         faceOpc(posi) = faceOpc(posi)-stepsize_down;
                         if faceOpc(posi) <= lowerBound, faceOpc(posi) = lowerBound; end
                         numReportUnseen(posi) = 0;
                      end

                      % unseen, increase
                      if(~seen(posi)) && isExp
                         numReportUnseen(posi) = numReportUnseen(posi) +1;
                         if numReportUnseen(posi) == stairCase_up;
                             faceOpc(posi) = faceOpc(posi) + stepsize_up;
                             if faceOpc(posi) >= upperBound, faceOpc(posi) = upperBound; end
                             numReportUnseen(posi) = 0;
                         end
                      end
                    end     
                
            end
    end

catch exception
    Screen('CloseAll'); 
    disp(getReport(exception));
    return;
end