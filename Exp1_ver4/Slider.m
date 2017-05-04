function [] = Slider(wPtr,L_cenX,R_cenX,BoxcenY,boxsize,answer)


lineColor = [255 255 255];
lineLength = boxsize-20;
stepsizeX = lineLength/10;
lineY = BoxcenY+boxsize/2;
answerY = boxsize/6+40;
vLineHeight = boxsize/6;
answerbarX_L = L_cenX + answer*stepsizeX;
answerbarX_R = R_cenX + answer*stepsizeX;
lineWidth = 2;

%slider in left window
Screen('DrawLine', wPtr, lineColor, L_cenX+lineLength, lineY, L_cenX-lineLength, lineY, lineWidth);
Screen('DrawLine', wPtr, lineColor, L_cenX+lineLength, lineY+vLineHeight, L_cenX+lineLength, lineY-vLineHeight, lineWidth);
Screen('DrawLine', wPtr, lineColor, L_cenX-lineLength, lineY+vLineHeight, L_cenX-lineLength, lineY-vLineHeight, lineWidth);
Screen('DrawLine', wPtr, lineColor, L_cenX, lineY+10, L_cenX, lineY-10, lineWidth);
Screen('DrawLine', wPtr, lineColor, answerbarX_L, lineY+10, answerbarX_L, lineY-10, lineWidth);

%slider right window
Screen('DrawLine', wPtr, lineColor, R_cenX+lineLength, lineY, R_cenX-lineLength, lineY, lineWidth);
Screen('DrawLine', wPtr, lineColor, R_cenX+lineLength, lineY+vLineHeight, R_cenX+lineLength, lineY-vLineHeight, lineWidth);
Screen('DrawLine', wPtr, lineColor, R_cenX-lineLength, lineY+vLineHeight, R_cenX-lineLength, lineY-vLineHeight, lineWidth);
Screen('DrawLine', wPtr, lineColor, R_cenX, lineY+10, R_cenX, lineY-10, lineWidth);
Screen('DrawLine', wPtr, lineColor, answerbarX_R, lineY+10, answerbarX_R, lineY-10, lineWidth);

Writetext(wPtr, num2str(answer), L_cenX, R_cenX, BoxcenY, 5-answer*stepsizeX,-answerY, [255 255 255],15);

end