%%%%code written by Katie Tregillus (kemtregillus@gmail.com) 
%%%%in order to run this program you'll need stimGen.m, counter.m,
%%%%insertrows.m, xyconvert.m, as well as the color conversion folder form
%%%%Dr. Crognale's lab. This code also requires luminance values that can
%%%%be collected with ring_MM.m

% Clear the workspace and the screen
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
escapeKey = KbName('ESCAPE');KbName('UnifyKeyNames');
[dev,name] = GetKeyboardIndices;
devid = dev(strcmp(name,'Apple Internal Keyboard / Trackpad')); %test program on Apple; formal scan on Lumia box %Apple Internal Keyboard / Trackpad
%devid = dev(1); %needs to be changed
upKey = KbName('1!'); %('UpArrow');
downKey = KbName('2@');%('DownArrow');
enterKey = KbName('3#');%('RETURN');
triggerKey = KbName('6^');
escapeKey = KbName('ESCAPE');
KbQueueCreate();
KbQueueStart();
% get subj 
prompt = 'Subject initials: ';
prompt2 = 'Scan number: ';
subj = input(prompt,'s');
scan = input(prompt2,'s');

%%%%comments for this portion were taken from using_colorInfo.m
% window and screen set up
%load the calibration file
% load colorInfo
load colorInfo_Renown2;

%determine the highest screen number
screenNumber = max(Screen('Screens'));

[MWLcenter] = ConvertColors('mwlrgb',[0 0 18],colorInfo);
%open a window on the designated monitor
[w, screenRect]= Screen('OpenWindow',screenNumber, MWLcenter.*255);%,[0 0 1000 1000 ]);

%create a backup of the default color lookup tables (CLUTs)
% BackupCluts(screenNumber);

%load the customized gamma table
Screen('LoadNormalizedGammaTable', w, gammaTable);

%At this point, you are taking advantage of the monitor calibration;
%now you would show your stimuli, collect data, etc. At the end of your
%program (and/or in a catch statement, if you use those), you would
%have this next line:

% %Restore the default lookup tables
% RestoreCluts;
%And that's it! Note that if you're using the Matlab ConvertColors
%functions then things become a bit more complicated, but I don't know if
%anybody outside of the Croglab uses those, so I tried to keep it simple.

%determine window size and get the center of the screen
[screenXpixels, screenYpixels] = Screen('WindowSize', w);
[xCenter, yCenter] = RectCenter(screenRect);%%center points
Screen('DrawText',w,'Press Key to Continue',xCenter-150,yCenter+30,[1 1 1])
Screen('Flip', w);
HideCursor();

structScreen.w = w;
structScreen.screenRect = screenRect;
structScreen.xCenter = xCenter;
structScreen.yCenter = yCenter;
structScreen.MWLcenter = MWLcenter;
structScreen.screenNumber = screenNumber;

%% creating and loading textures
%load in isoluminant vals generated using ring_MM.m
load(strcat(subj,'lumAmp.mat'))
lumAmpLM = lumAveLM;
lumAmpS = lumAveS;
stepSize = .01;
lumCon = .2;
%fixation point size
fixation = [0 0 20 20];
%the stimGen function generates the rings
[textureLM1] = stimGen(0,0.5,2,structScreen,colorInfo,lumAmpLM);  %0 deg,.5 phase
[textureLM2] = stimGen(0,1,2,structScreen,colorInfo,lumAmpLM);    %0 deg, 1 phase
[textureS1] = stimGen(90,0.5,2,structScreen,colorInfo,lumAmpS);   %90 deg, .5 phase
[textureS2] = stimGen(90,1,2,structScreen,colorInfo,lumAmpS);     %90 deg, 1 phase
allTextures1 = cat(2,textureLM1,textureS1);
allTextures2 = cat(2,textureLM2,textureS2);

%% generating the sequence: 14 sec. blocks with 8 sec. gaps
numBlocks = 16; %8 stimulus levels, each are presented twice per scan = 16 blocks
seq = counter(8,numBlocks); %the counter function generates a counterbalanced sequence
seq = seq';
%the function insertrows is used here extend the sequence into a sequence
%where each row represents a TR (0 = blank, 1:4 are the LM levels, 5:8 are the S levels, 1&5 = max contrast)
seqT = insertrows(seq,zeros(4,1),0); 
row = 1;
rowCount = 5;
for i = 1:numBlocks
    for j = 1:6 
        seqT = insertrows(seqT,seq(row),rowCount);
        rowCount = rowCount+1;
    end
    seqT = insertrows(seqT,zeros(4,1),rowCount);
    rowCount = rowCount+5;
    row = row+1;
end
%save sequence
filename = strcat(subj,'_',scan,'_','seqT.mat');
save(filename,'seqT','seq');

Screen('DrawText',w,'Textures Generated. Waiting for Scanner.',xCenter-250,yCenter+30,[1 1 1])
Screen('Flip', w);
KbQueueFlush(devid);
[press, firstPress, firstRel, lastPress, lastRel] = KbQueueCheck(devid);
while ~any(lastPress(triggerKey))
    [press, firstPress, firstRel, lastPress, lastRel] = KbQueueCheck(devid);
end
seq
%KbStrokeWait;
%% timing
dur = 2; %2 sec TR 
delay = .5; %2Hz flicker
delayTimer = delay;
runStart = GetSecs;
running = true;
seqNum = 1;
numRuns = 1;
ti = 0;

while(seqNum <= numRuns && running)
    seqNum = 1;
    time = GetSecs;
    imgTime = time;
    %circTime = GetSecs;
    %circInterval = round(rand()*5)+5; %This will be used when I add the fixation task
    while(seqNum < length(seqT))
        delayTimer = delayTimer - (GetSecs - time);
        time = GetSecs;
        %draws the stimuli
        if(seqT(seqNum) ~=0)
            if delayTimer <= 0
                ti = ti+1;
                delayTimer = delay;
            end
            %rings reverse in phase
            switch mod(ti,2)
                case 0
                    Screen('DrawTexture',w,allTextures1(seqT(seqNum)))
                case 1
                    Screen('DrawTexture',w,allTextures2(seqT(seqNum)))
            end
        end
        %draw fixation
        fixRect = CenterRectOnPointd(fixation,xCenter,yCenter);
        Screen('FillOval',w, MWLcenter,fixRect);
        Screen('Flip',w);
        %updates current sequence every TR (2 sec)
        curTime = GetSecs;
        if (curTime - imgTime >= dur)
            seqNum = seqNum+1;
            imgTime = curTime;
        end
        %stops program when escape key is pressed
        [keyIsDown,secs,keyCode] = KbCheck;
        escapePressed = keyCode(escapeKey);
        if (keyIsDown && escapePressed)
%             runEnd = GetSecs;
            running = false;
            break;
        end
    end
end
runEnd = GetSecs;
runTotal = runEnd - runStart
%Restore the default lookup tables
% RestoreCluts
defaultCluts
sca