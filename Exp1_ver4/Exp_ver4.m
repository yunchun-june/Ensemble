clear all;
close all;

try
    
%====== Input ======%
    subjNo                = input('subjNo: ','s');
    DemoEye               = input('DomEye Right 1 Left 2:');
    keymode               = input('keymode1 MAC keymode2 Dell 3 EEG:');
    fName = ['./Data/Ensem_result_' subjNo '.txt'];

%====== initial condition =====% 

    % white faces
    faceOpc{1}(1,1) = 0.8;  faceOpc{1}(2,1) = 0.4;
    faceOpc{1}(1,2) = 0.8;  faceOpc{1}(2,2) = 0.4;
    faceOpc{1}(1,3) = 0.8;  faceOpc{1}(2,3) = 0.4;
    faceOpc{1}(1,4) = 0.8;  faceOpc{1}(2,4) = 0.4;

    maskOpc = 0.5;
    disX = 240;

    lowerBound = 0.02;
    upperBound = 1.00;     
    stepsize_down = 0.1; 
    stepsize_up = 0.1 ;    
    stairCase_up = 2;

%====== Setup Screen & Keyboard ======%
    screid = max(Screen('Screens'));
    [wPtr, screenRect]=Screen('OpenWindow',screid, 0,[],32,2); % open screen
    [width, height] = Screen('WindowSize', wPtr); %get windows size 

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
    breakKey = '0';

    leftkey = '1';
    rightkey = '3';

    placeKey{1} = '4';
    placeKey{2} = '5';
    placeKey{3} = '1';
    placeKey{4} = '2';
    
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
    conditionNum = 5;
    rep = 6;
    catch_rep = 5;
    expTrialNum = targetFaceNum*conditionNum*rep;
    catchTrialNum = targetFaceNum*catch_rep;
    trials = expTrialNum + catchTrialNum;
    
    
%     1 trial
%     2 expTrial 0 catchTrial
%     3 ensumble condition
%     4 target face
%     5 response
%     6 break
%     7 staircase number
%     8-11 opacity
%     12-15 seen
%     16 done how many times

    condList = zeros(0,16);
    block_random = randperm(5);
    for block = block_random
        temp = zeros(trials/5,16);
        temp(1:expTrialNum/5,2) = 1;
        temp(1:trials/5,3) = block;
        temp(1:expTrialNum/5,4) = repmat(1:6,1,expTrialNum/(5*6));
        temp(1:expTrialNum/5,7) = repmat(1:2,1,expTrialNum/(5*2));
        temp(expTrialNum/5+1:trials/5,2) = 0;
        temp(expTrialNum/5+1:trials/5,4) = 1:6;
       
        temp_random = randperm(trials/5);
        
        for i = 1:trials/5
            condList(end+1,2:16) = temp(temp_random(i),2:16);
        end
    end

    for i = 1:length(condList) condList(i,1) = i; end
    
%====== Time & Freq ======%
    monitorFlipInterval =Screen('GetFlipInterval', wPtr);
    refreshRate = round(1/monitorFlipInterval); % Monitor refreshrate
    MondFreq = 10; %Hz
    MondN  = round(refreshRate/MondFreq); % frames/img
    ConIncr= 7.5 /(10*refreshRate); % 7.5% increase per second

    
%===== Write Results and Quit =====%
    CreateFile(fName, condList);
    Screen('CloseAll'); %Closes Screen  
    return;
    
catch
    disp('****** Error *****')
    CreateFile(fName, condList);
    Screen('CloseAll');
    return;
end