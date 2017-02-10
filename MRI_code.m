% Clear the workspace and the screen
%% 
close all;
clear all;
clearvars;

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
load colorInfo_Renown2;

%determine the highest screen number
screenNumber = max(Screen('Screens'));

[MWLcenter] = ConvertColors('mwlrgb',[0 0 18],colorInfo);
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
numTrials = 10;

Screen('DrawText',w,'Press Key to Continue',xCenter-150,yCenter+30,[1 1 1])
Screen('Flip', w);
% HideCursor();
load lumAveLM.mat
load lumAveS.mat
lumAmpLM = lumAveLM;
lumAmpS = lumAveS;
% % 
[textureLM1] = stimGen(0,0.5,2,stepSize,lumCon,w,screenRect,xCenter,yCenter,fixation,MWLcenter,screenNumber,lumAmpLM);
[textureLM2] = stimGen(0,1,2,stepSize,lumCon,w,screenRect,xCenter,yCenter,fixation,MWLcenter,screenNumber,lumAmpLM);
[textureS1] = stimGen(90,0.5,2,stepSize,lumCon,w,screenRect,xCenter,yCenter,fixation,MWLcenter,screenNumber,lumAmpS);
[textureS2] = stimGen(90,1,2,stepSize,lumCon,w,screenRect,xCenter,yCenter,fixation,MWLcenter,screenNumber,lumAmpS); 

%% 
numBlocks = 16;
seq = counter(8,numBlocks);
seq = seq';
seqT = insertrows(seq,zeros(4,1),0);
row = 1;
rowCount = 5;

allTextures1 = cat(2,textureLM1,textureS1);
allTextures2 = cat(2,textureLM2,textureS2);

for i = 1:numBlocks
    for j = 1:6
        seqT = insertrows(seqT,seq(row),rowCount);
        rowCount = rowCount+1;
    end
    seqT = insertrows(seqT,zeros(4,1),rowCount);
    rowCount = rowCount+5;
    row = row+1;
end
save('seqT.mat','seqT');

  
Screen('DrawText',w,'Textures Generated. Press Key to Continue',xCenter-250,yCenter+30,[1 1 1])
Screen('Flip', w);
KbStrokeWait

dur = 2;
delay = .5;
delayTimer = delay;
runStart = GetSecs;
running = true;
seqNum = 1;
numRuns = 1;
ti = 0;

while(seqNum <= numRuns && running)
    i = 1;
    curSeq = seqT(:,seqNum);
    circTime = GetSecs;
    time = GetSecs;
    imgTime = circTime;
    
    circInterval = round(rand()*5)+5;
    
    while(i < length(curSeq))
        
        delayTimer = delayTimer - (GetSecs - time);
       time = GetSecs;
        if(seqT(i) ~= 0)
            
            if delayTimer <= 0
                ti = ti+1;
                delayTimer = delay;
            end
            switch mod(ti,2)
                case 0
                    Screen('DrawTexture',w,allTextures1(seqT(seqNum)))
                case 1
                    Screen('DrawTexture',w,allTextures2(seqT(seqNum)))
            end
        end
        
        Screen('Flip',w);
        curTime = GetSecs;
        if (curTime - imgTime >= dur)
            i = i+1;
            seqNum = seqNum+1;
            imgTime = curTime;
        end
        [keyIsDown,secs,keyCode] = KbCheck;
        escapePressed = keyCode(escapeKey);
        if (keyIsDown && escapePressed) 
            running = false;
            break;
        end
        
    end
    seqNum = seqNum +1;
end

sca
