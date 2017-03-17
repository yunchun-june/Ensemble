
clear all;
close all;
 
try
    
    %====== Input ======%
        keymode               = input('keymode1 MAC keymode2 Dell:');
        
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
            
        end
        KbQueueCreate(devInd);  
        KbQueueStart(devInd);
        
    %======Keyboard======%
     
        KbName('UnifyKeyNames');
        quitkey = 'ESCAPE';
        space   = 'space';
    
    %====== Load image ======%
            
            folder = './exampler/';
            exampler.file = dir([folder '*.jpg']);
            for i= 1:4
               exampler.img{i} = imread([folder exampler.file(i).name]);
               exampler.tex{i} = Screen('MakeTexture',wPtr,exampler.img{i});        
            end
 
    %====== Position ======%

        % general setup
            cenX = width/2;
            cenY = height/2-150;
            disX = 200;
            L_cenX = cenX - disX;
            R_cenX = cenX + disX;
            BoxcenY = cenY;
            faceW = 42; %face width 7:9
            faceH = 54; %face height

            boxcolor=[255 255 255];
            boxsize = 80;
            m = 3; %margin
            
        % for test faces
            testPosi_L = [L_cenX-faceW BoxcenY-faceH L_cenX+faceW BoxcenY+faceH];
            testPosi_R = [R_cenX-faceW BoxcenY-faceH R_cenX+faceW BoxcenY+faceH];
        
     %====== running ======%
         
         message{1}= '-10';
         message{2}= '-5';
         message{3}= '5';
         message{4}= '10';
        
         % press space to start
            while 1,
                FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                Writetext(wPtr,'press space to start ',L_cenX, R_cenX,BoxcenY, 70,60, [255 255 255],15);
                Screen('Flip',wPtr);
                KbEventFlush();
                [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);
                if secs(KbName(space)) break; end 
                if secs(KbName(quitkey))
                     Screen('CloseAll'); %Closes Screen
                     return;
                end
                
            end
        
        %delay
        FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
        Screen('Flip',wPtr);
        WaitSecs(1);
        
        sequence = randperm(8);
        
        for i= 1:8
            k= mod(sequence(i),4)+1;
            % show exampler
                FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                Writetext(wPtr,message{k} ,L_cenX, R_cenX,BoxcenY, 15,30, [255 255 255],20);
                Screen('Flip',wPtr);
                WaitSecs(1);
                
                FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                Screen('Flip',wPtr);
                WaitSecs(.5);
                
                FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                Screen('DrawTexture',wPtr, exampler.tex{k}, [], testPosi_L);
                Screen('DrawTexture',wPtr, exampler.tex{k}, [], testPosi_R);
                Screen('Flip',wPtr);
                WaitSecs(1);
                
                FixationBox(wPtr,L_cenX,R_cenX, BoxcenY,boxsize,boxcolor);
                Screen('Flip',wPtr);
                WaitSecs(1);
        end
        
        Screen('CloseAll'); %Closes Screen  
        return;

catch
    ListenChar(0); %makes it so characters typed do show up in the command window
    Screen('CloseAll'); %Closes Screen  
    ListenChar(0);
    rethrow(lasterror);
    return;
end
