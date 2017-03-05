function [] = SelectionBar(wPtr,L_cenX,R_cenX,BoxcenY,boxsize,answer)


lineColor = [255 255 255];
lineLength = boxsize-20;
stepsizeX = lineLength/10;
lineY = BoxcenY+45;
answerbarX_L = L_cenX + answer*stepsizeX;
answerbarX_R = R_cenX + answer*stepsizeX;
lineWidth = 2;


%|------|-----|


Screen('DrawLine', wPtr, lineColor, L_cenX+lineLength, lineY, L_cenX-lineLength, lineY, lineWidth);
Screen('DrawLine', wPtr, lineColor, L_cenX+lineLength, lineY+10, L_cenX+lineLength, lineY-10, lineWidth);
Screen('DrawLine', wPtr, lineColor, L_cenX-lineLength, lineY+10, L_cenX-lineLength, lineY-10, lineWidth);
Screen('DrawLine', wPtr, lineColor, L_cenX, lineY+10, L_cenX, lineY-10, lineWidth);
Screen('DrawLine', wPtr, lineColor, answerbarX_L, lineY+10, answerbarX_L, lineY-10, lineWidth);

Screen('DrawLine', wPtr, lineColor, R_cenX+lineLength, lineY, R_cenX-lineLength, lineY, lineWidth);
Screen('DrawLine', wPtr, lineColor, R_cenX+lineLength, lineY+10, R_cenX+lineLength, lineY-10, lineWidth);
Screen('DrawLine', wPtr, lineColor, R_cenX-lineLength, lineY+10, R_cenX-lineLength, lineY-10, lineWidth);
Screen('DrawLine', wPtr, lineColor, R_cenX, lineY+10, R_cenX, lineY-10, lineWidth);
Screen('DrawLine', wPtr, lineColor, answerbarX_R, lineY+10, answerbarX_R, lineY-10, lineWidth);

end