% Luminance based linearization
%
% This program will take the luminance measures from a PR655 for each
% gun, and calculate the proper inverse gamma function for the
% Psychtoolbox LoadNormalizedGammaTable function within Screen.
% This program requires the Psychtoolbox (http://psychtoolbox.org) and the 
% Curve Fitting Toolbox from Mathworks.

function [gammaTable, gunsbeforecorrection] = Create_Gamma_Table_Luminances(intensities, COM_port)

if nargin<2
    error('Not enough input arguments you silly person you!')
end

% COM_port = 'COM3';
% intensities = 9;

try
    PR655init(COM_port); %COM3 for my computer, may be different for yours.
catch me
    error(me)
end

dos('FlipSS /off') %Turns screensaver off

guns=3;
AssertOpenGL;
screens=Screen('Screens');
screenNumber=max(screens);
[window screenRect]=Screen('OpenWindow', screenNumber, [128 128 128]);
output_texture = Screen('MakeTexture', window, [128 128 128]); %just for later

priorityLevel=MaxPriority(window);
Priority(priorityLevel);

screenWidth = screenRect(3);
screenHeight = screenRect(4);

bitmap(screenHeight,screenWidth,3)=zeros;

startTime = datestr(rem(now,1));

gunsbeforecorrection(guns,intensities)=zeros;
gammaTable(256,guns)=zeros;

for guncount=1:guns
    for intensitycount=1:intensities
        switch guncount
            case 1
                bitmap(:,:,1)=floor((intensitycount/intensities)*255);
                bitmap(:,:,2)=0;
                bitmap(:,:,3)=0;
            case 2
                bitmap(:,:,1)=0;
                bitmap(:,:,2)=floor((intensitycount/intensities)*255);
                bitmap(:,:,3)=0;
            case 3
                bitmap(:,:,1)=0;
                bitmap(:,:,2)=0;
                bitmap(:,:,3)=floor((intensitycount/intensities)*255);
            otherwise
                error('Error in switch statement!')
        end
        
        Screen('Close', output_texture);
        output_texture = Screen('MakeTexture', window, bitmap);
        Screen('DrawTexture', window, output_texture);
        Screen('Flip', window); %shouldn't need super serious timing.
        WaitSecs(.05); %make sure it's up with 50 ms wait
        
        try
            [XYZ,qual] = PR655measxyz;
        catch me  %Whoops, no data. That's okay, put zeros in
            disp(me);
            disp('Could not read XYZ, most likely due to low light levels.')
            disp('Zeros will be placed in the data for this.')
            XYZ(3,1)=zeros;
        end
        
        gunsbeforecorrection(guncount,intensitycount)=XYZ(2); %get the Y coordinate for luminance
        clear XYZ
    end
end

PR655close();

Priority(0);
Screen('CloseAll');
dos('FlipSS /on')
beep;

%Now we use the information gathered
% Note, this is from the CalibrateMonitorPhotometer function of the
% psychtoolbox.

for i=1:guns
    vals = gunsbeforecorrection(i,:); %just to make the below easier for copypasta
    inputV = [0:256/(intensities - 1):256]; %#ok<NBRAK>
    inputV(end) = 255;
    
    displayBaseline = min(vals);
    
    %Normalize values
    vals = (vals - displayBaseline)/(max(vals) - min(vals));
    inputV = inputV/255;
    
    if ~exist('fittype'); %#ok<EXIST>
        fprintf('This function needs fittype() for automatic fitting. This function is missing on your setup.\n');
        fprintf('Therefore i can''t proceed, but the input values for a curve fit are available to you by\n');
        fprintf('defining "global vals;" and "global inputV" on the command prompt, with "vals" being the displayed\n');
        fprintf('values and "inputV" being user input from the measurement. Both are normalized to 0-1 range.\n\n');
        error('Required function fittype() unsupported. You need the curve-fitting toolbox for this to work.\n');
    end
    
    %Gamma function fitting
    g = fittype('x^g');
    fittedmodel = fit(inputV',vals',g); %could have problem here. Play with the apostrophes (inverses).
    temp = ((([0:255]'/255))).^(1/fittedmodel.g); %#ok<NBRAK>
    gammaTable(1:256,i) = temp';
    
    clear vals temp %Just in case
end
endTime = datestr(rem(now,1));

disp('Monitor luminances acquired and inverted!')
disp(['Started @ ' startTime])
disp(['Ended   @ ' endTime])

beep

return

