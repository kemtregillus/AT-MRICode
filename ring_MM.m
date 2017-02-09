% Clear the workspace and the screen

close all;
clear all;
clearvars;
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);
screens = Screen('Screens');
% set up keys
KbName('UnifyKeyNames');
upKey = KbName('UpArrow');
downKey = KbName('DownArrow');
enterKey = KbName('RETURN');
escapeKey = KbName('ESCAPE');
% get subj 
% prompt = 'Subject initials: ';
% subj = input(prompt);
% window and screen set up
%load the calibration file
load colorInfo_Renown;

%determine the highest screen number
screenNumber = max(Screen('Screens'));

[MWLcenter] = ConvertColors('mwlrgb',[0 0 18])%,colorInfo);
%open a window on the designated monitor
[w, screenRect]= Screen('OpenWindow',screenNumber, MWLcenter.*255);%,[0 0 1000 1000 ]);

%create a backup of the default color lookup tables (CLUTs)
BackupCluts(screenNumber);

%load the customized gamma table
Screen('LoadNormalizedGammaTable', w, gammaTable);

%At this point, you are taking advantage of the monitor calibration;
%now you would show your stimuli, collect data, etc. At the end of your
%program (and/or in a catch statement, if you use those), you would
%have this next line:

%Restore the default lookup tables
RestoreCluts;

%And that's it! Note that if you're using the Matlab ConvertColors
%functions then things become a bit more complicated, but I don't know if
%anybody outside of the Croglab uses those, so I tried to keep it simple.
[screenXpixels, screenYpixels] = Screen('WindowSize', w);
[xCenter, yCenter] = RectCenter(screenRect);%%center points

fixation = [0 0 20 20];
stepSize = .01;
lumCon = .2;
lumVal = -lumCon:stepSize:lumCon;
numTrials = 4;

Screen('DrawText',w,'Press Key to Continue',xCenter-150,yCenter+30,[1 1 1])
Screen('Flip', w);
% HideCursor();

% % 
[textureLM1] = stimGen(0,.5,0,stepSize,lumCon,w,screenRect,xCenter,yCenter,fixation,MWLcenter,screenNumber);
[textureLM2] = stimGen(0,1,0,stepSize,lumCon,w,screenRect,xCenter,yCenter,fixation,MWLcenter,screenNumber);
[textureS1] = stimGen(90,.5,0,stepSize,lumCon,w,screenRect,xCenter,yCenter,fixation,MWLcenter,screenNumber);
[textureS2] = stimGen(90,1,0,stepSize,lumCon,w,screenRect,xCenter,yCenter,fixation,MWLcenter,screenNumber); 
[textureA1] = stimGen(0,.5,1,stepSize,lumCon,w,screenRect,xCenter,yCenter,fixation,MWLcenter,screenNumber);
[textureA2] = stimGen(0,1,1,stepSize,lumCon,w,screenRect,xCenter,yCenter,fixation,MWLcenter,screenNumber);
  

  
  
Screen('DrawText',w,'Textures Generated. Press Key to Continue',xCenter-250,yCenter+30,[1 1 1])
Screen('Flip', w);
KbStrokeWait
 
curTime = GetSecs();
time = GetSecs();

delay = .1 ;
delayTimer = delay;

ti = 0;
textPoint = randi(size(lumVal));
down = 0;
changeText = 0;
run = 1;
texture1 = textureLM1;
texture2 = textureLM2;
c = 1;
trial = 1;
KbQueueCreate();
KbQueueStart();
for i = 1:numTrials
    
    while run == 1
        [keyIsDown, secs, keyCode] = KbQueueCheck();
        if keyCode(upKey) && down == 0
            if textPoint < size(lumVal,2)
                textPoint = textPoint+1
            end
            down = 1;
        elseif keyCode(downKey) && down ==0
            if textPoint > 1
                textPoint = textPoint-1
            end
            down = 1;
        elseif keyCode(enterKey) && down ==0
            lumAmp(trial,c) = lumVal(textPoint);
            run = 0;
            down = 1;
        elseif keyIsDown == 0
            down = 0;
        end
        
        delayTimer = delayTimer - (GetSecs - time);
        time = GetSecs;
        if delayTimer <= 0
            ti = ti+1;
            delayTimer = delay;
        end
        switch mod(ti,4)
            case 0
                Screen('DrawTexture',w,texture1(textPoint))
            case 1
                Screen('DrawTexture',w,textureA1(1))
            case 2
                Screen('DrawTexture',w,texture2(textPoint))
            case 3
                Screen('DrawTexture',w,textureA2(1))
        end
        Screen('Flip',w);
    end
    if texture1 == textureLM1
        texture1 = textureS1;
        texture2 = textureS2;
        c = 2;
        run = 1;
    elseif texture1 == textureS1
        texture1 = textureLM1;
        texture2 = textureLM2;
        trial = trial + 1;
        c = 1;
        run = 1;
    end
end
save lumAmp;
sca

