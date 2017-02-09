% Gamma and color correction with OptiCal and PR connected - 07 June 2013
%
% [colorInfo, originalGuns, gammaTable] =
% GammaColorCorrection(OptiCALport,PRconnected,recordingspergun)
%
% This program will use a combination of the OptiCAL code via the
% psychtoolbox and the 3 basic readings for color/phosphor information at
% each gun max value.
%
% This program should also do the gamma correction automatically as before.
%
% Note that the OptiCAL requires the serial port, and as of yet, no testing
% has been done with converting serial to USB.
%
% Rows are guns, columns are color coordinates per gun.
%
% OptiCAL port is the port identifier you use to connect. In Windows, this
% is like 'COM1' or something like that.
%
% PRconnected is an integer identifier, where:
% 0 = manual input
% 1 = PR650 automatic input
% 3 = CRS Colorimeter input (but not available in Psychtoolbox as of 7 June
%     2013.
% 4 = PR655 automatic input
%
% PRport is the port identifier for your PR instrument. In Windows, this
% is like 'COM1' or something like that. Set to 0 if using manual input,
% but it shouldn't matter if you do.
%
% recordingspergun asks how many times should the program record the
% phosphor primary coordinates per gun; more means we can average out
% noise, but less is faster to get though.
%
% Changelog
%
% 7 June 2013:
% -Added in PR photometer support, still defaults to manual input though.
%
% -Chris Jones

function [colorInfo, gammaTable, originalGuns] = GammaColorCorrectionOpticalPRauto_Mac(OptiCALport,PRconnected,recordingspergun)

close all

Screen('Preference', 'SkipSyncTests', 1);

if nargout<2
    error(['You need 2 output variables, one each for colorInfo'...
        ' and the gammaTable.']);
end

if nargin<3
    recordingspergun = 1;
end



if nargin<2 %1 is for PR650, 3 is for CRS colorimeter, 4 is for PR655
    PRconnected = 0;
end

if nargin<1
    OptiCALport = 'COM1';%May be different for your computer.
end

try
    
    instructions = ['Instructions\n\n' ...
        'First, use the OptiCAL and it''s own ampliphier connected\n'...
        'to the serial port.\n\n'...
        'Next, place the OptiCAL near the middle of the screen, making\n'...
        'sure you have the room for using the spectrophotometer.\n\n'...
        'Press any key to continue...'];
    
    startTime = datestr(rem(now,1));
    
    cieXYZ=zeros(3,3);
    rawLums=zeros(30,1);
    recordingcount=1;
    inputrecordings=zeros(recordingspergun,3);
    
    monitorID = input('Please enter the name of the monitor you''re calibrating: ','s');
    computerID = input('Please enter the name of the computer you''re using to calibrate: ','s');
    
    %Psychtoolbox stuff
    screens=Screen('Screens');
    screenNumber=max(screens);
    %     screenNumber=1;
    
    [w, rect] = Screen('OpenWindow',screenNumber,0);%,[40 40 1024 768]);
    maxGunLevel = WhiteIndex(w);
    minGunLevel = BlackIndex(w);
    gammaTable=zeros(maxGunLevel+1,3);
    
    originalGuns=zeros(maxGunLevel+1,3);
    
    %initialize PR or colorimeter
    if PRconnected > 0
        switch PRconnected
            case 1
                retval = PR650init();
                if ~strcmp(retval,' REMOTE MODE')
                    error('PR 650 requested, but connection failed')
                end
                
            case 3
            case 4
                retval = PR655init();
                if ~strcmp(retval,' REMOTE MODE')
                    error('PR 655 requested, but connection failed')
                end
            otherwise
        end
        maxguninstruction = 'Using colorimeter to get XYZ. Please wait.';
    else
        maxguninstruction= 'Record your XYZ now.';
    end
    
    % End of Psychtoolbox stuff
    DrawFormattedText(w,'Have initialized PR655','center','center',maxGunLevel);
    Screen('Flip',w);
    WaitSecs(3);
    DrawFormattedText(w,'Have waited 3s','center','center',maxGunLevel);
    Screen('Flip',w);
    % Start of OptiCAL stuff
    handle = OptiCAL('Open',OptiCALport);
    DrawFormattedText(w,'Have initialized OptiCAL','center','center',maxGunLevel);
    Screen('Flip',w);
    WaitSecs(1);
    % Generate a short beep for the user:
    soundSteps = 1:2048;
    amplitude = .25;
    tone = amplitude*sin(soundSteps);
    lum=0;
    
    DrawFormattedText(w,instructions,'center','center',maxGunLevel);
    Screen('Flip',w);
    KbWait;
    
    % Now, let's get our animation loop started
    vbl = Screen('Flip',w);
    for guns=1:3
        for intensities=minGunLevel:maxGunLevel
            switch guns
                case 1
                    Screen('FillRect',w,[intensities,0,0]);
                case 2
                    Screen('FillRect',w,[0,intensities,0]);
                case 3
                    Screen('FillRect',w,[0,0,intensities]);
                otherwise
                    DrawFormattedText(w,['You blew it son!\n'...
                        'Press any key to quit.'],'center','center');
                    Screen('Flip',w);
                    KbWait;
                    sca
                    return
            end
            
            displayString=['Last luminance: ' num2str(lum) ' cd/m^2.'...
                ' Level ' num2str(intensities) ' of ' num2str(maxGunLevel)];
            
            Screen('FillRect',w,0,[0 rect(4)-45 rect(3) rect(4)]);
            DrawFormattedText(w,displayString,...
                'center',rect(4)-40,maxGunLevel);
            
            vbl = Screen('Flip',w,vbl+.050);
            
            if intensities==0
                %Let the monitor get back to zero
                WaitSecs(5);
            end
            
            %Take a reading
            for i=1:30
                rawLums(i)=OptiCAL('Read',handle);
            end
            
            lum=mean(rawLums);
            originalGuns(intensities+1,guns) = lum;
            %        originalGuns(intensities+1,guns) = intensities; %used for debugging.
            
            if intensities == maxGunLevel
                
                
                
                % Tell user we need photometer reading for XYZ
                switch guns
                    case 1
                        Screen('FillRect',w,[intensities,0,0]);
                    case 2
                        Screen('FillRect',w,[0,intensities,0]);
                    case 3
                        Screen('FillRect',w,[0,0,intensities]);
                end
                Screen('FillRect',w,0,[0 rect(4)-45 rect(3) rect(4)]);
                
                DrawFormattedText(w,maxguninstruction,...
                    'center',rect(4)-40,maxGunLevel);
                Screen('Flip',w);
                
                %To Do: Error checking for input.
                for i=1:recordingspergun
                    disp(['Recording ' num2str(recordingcount) ...
                        ' of ' num2str(recordingspergun)]);
                    switch PRconnected
                        case 0 %No PR connected, manual input
                            sound(tone); %Play a tone to get user attention.
                            inputrecordings(recordingcount,1) = input('Please tell me the X coordinate: ');
                            inputrecordings(recordingcount,2) = input('Please tell me the Y coordinate: ');
                            inputrecordings(recordingcount,3) = input('Please tell me the Z coordinate: ');
                        case {1, 3, 4}
                            XYZtemp = MeasXYZ(PRconnected);
                            inputrecordings(recordingcount,:)=XYZtemp'; %comes out as 3x1, need a 1x3 vector
                        otherwise %wrong choice, get out
                            disp('Error!')
                    end
                    
                    recordingcount=recordingcount+1;
                end
                recordingcount=1;
                
                if recordingspergun>1
                    meanrecordings = mean(inputrecordings,1);
                else
                    meanrecordings = inputrecordings;
                end
                
                cieXYZ(guns,:) = meanrecordings;
                vbl = Screen('Flip',w);
                
            end
        end
    end
    
    %Save the gun outputs before replacing the max lum in the next step
    rawOutputNoPR = originalGuns;
    
    %Before normalizing, replace each max value per gun by the PR655's
    %measurement of the same.
    originalGuns(256,1) = cieXYZ(1,2);
    originalGuns(256,2) = cieXYZ(2,2);
    originalGuns(256,3) = cieXYZ(3,2);
    
    %Re-save now that the max lums have been replaced
    rawOutputWithPR = originalGuns;
    
    OptiCAL('CloseAll');
    WaitSecs(1);
    switch PRconnected
        case 1
            PR650close;
        case 3
            %Dunno, not in PsychHardware, and I don't have the right device
            %to test it anyway...
        case 4
            PR655close;
    end
    WaitSecs(1);
    Screen('FillRect',w,0);
    
    DrawFormattedText(w,'Calculating...','center','center');
    Screen('Flip',w);
    WaitSecs(1);
    Screen('CloseAll')
    save('calib_intermediate1');
    disp('Data_Saved\n');

    save('calib_intermediate2');
    
    disp('Orig_data_backed_up into Origguns1\n');
    
    %Get Lum values to normalized percentages...
    for i=1:guns
        originalGuns(:,i) = (originalGuns(:,i) - min(originalGuns(:,i)))/...
            (max(originalGuns(:,i))-min(originalGuns(:,i)));
    end
    
    disp('Orig_data scaled\n');
    save('calib_intermediate3');
    
    %Now, let's linearize the guns
    for i=1:guns
        vals = originalGuns(:,i); %just to make the below easier for copypasta
        inputV = [0:(maxGunLevel)/(intensities):maxGunLevel]; %#ok<NBRAK>
        inputV(end) = maxGunLevel;
        
        displayBaseline = min(vals);
        
        %Normalize values
        vals = (vals - displayBaseline)/(max(vals) - min(vals));
        inputV = inputV/maxGunLevel;
        
        if ~exist('fittype'); %#ok<EXIST>
            fprintf('This function needs fittype() for automatic fitting. This function is missing on your setup.\n');
            fprintf('Therefore i can''t proceed, but the input values for a curve fit are available to you by\n');
            fprintf('defining "global vals;" and "global inputV" on the command prompt, with "vals" being the displayed\n');
            fprintf('values and "inputV" being user input from the measurement. Both are normalized to 0-1 range.\n\n');
            error('Required function fittype() unsupported. You need the curve-fitting toolbox for this to work.\n');
        end
        
        %Gamma function fitting
        g = fittype('x^g');
        fittedmodel = fit(inputV',vals,g); %could have problem here. Play with the apostrophes (inverses).
        temp = ((([0:maxGunLevel]'/maxGunLevel))).^(1/fittedmodel.g); %#ok<NBRAK>
        gammaTable(1:maxGunLevel+1,i) = temp';
        
        clear vals temp %Just in case
    end
    disp('linearized\n');
    save('calib_intermediate3');
    
    endTime = datestr(rem(now,1));
    
    %Finally, let's create our colorInfo variable instead of loading a file.
    %This version will NOT use spectrum information as it's not terribly
    %helpful. colorInfo.Wavelength and colorInfo.Intensity will therefore be
    %missing.
    
    colorInfo.CalibrationDate = [date ' ' endTime];
    %colorInfo.RefreshRate = Screen('FrameRate',w);
    colorInfo.Monitor = monitorID;
    colorInfo.ComputerUsed = computerID;
    colorInfo.XYZMatrix = cieXYZ;
    colorInfo.MaxLuminance = [cieXYZ(1,2) cieXYZ(2,2) cieXYZ(3,2)];
    colorInfo.RGBMatrix = CreateRGBMatrix(colorInfo.XYZMatrix);
    colorInfo.Resolution = [num2str(rect(3)) 'x' num2str(rect(4))];
    colorInfo.rawOutputNoPR = rawOutputNoPR;
    colorInfo.rawOutputWithPR = rawOutputWithPR;
    
    % xyL coordinates from XYZ
    xyL = zeros(3,3);
    for i=1:3
        xyL(i,1:3) = ConvertColors('XYZxyL',colorInfo.XYZMatrix(i,:));
    end
    
    for i=1:3
        colorInfo.CIEx(i) = xyL(i,1);
        colorInfo.CIEy(i) = xyL(i,2);
    end
    
    %Reference white for CIE Lab
    colorInfo.ReferenceWhite = sum(colorInfo.XYZMatrix);
    
    %Color matching functions if you want them.
    colorInfo.ColorMatchingFunctions = LoadColorMatchingFunctions();
    
    
    
    disp('Done!')
    disp(['Started @ ' startTime])
    disp(['Ended   @ ' endTime])
    
    sound(tone);
    
    plot(minGunLevel:maxGunLevel,originalGuns(:,1),'r');
    hold on
    plot(minGunLevel:maxGunLevel,originalGuns(:,2),'g');
    plot(minGunLevel:maxGunLevel,originalGuns(:,3),'b');
    plot(minGunLevel:maxGunLevel,gammaTable(:,1),'r--');
    plot(minGunLevel:maxGunLevel,gammaTable(:,2),'g--');
    plot(minGunLevel:maxGunLevel,gammaTable(:,3),'b--');
    ylabel('Percent of gun maximum')
    xlabel('Levels of guns')
    title('Gun normalized luminances and their gamma inverse')
    axis square
    legend('Red gun','Green gun','Blue gun','Red gamma','Green gamma','Blue gamma','Location','SouthEast');
    
    workspaceFilename = input('Please choose a sensible name for the calibration file: ','s');
    save(workspaceFilename);
    
catch me
    OptiCAL('CloseAll')
    Screen('CloseAll')
    rethrow(me)
end
end