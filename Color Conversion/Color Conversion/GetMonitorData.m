function success = Get_Monitor_Data()
% Get_Monitor_Data()
%
% Makes ___ many readings with ___ many guns at __ many intensities to get a
% file that Load_Monitor_Data can handle.  Requires use of a PR 655 at this
% time. The PR 650 should work without problems, just Find and Replace to
% change the code.
%
% Must have already made a linearized lookup table, or else the colors
% later will be (obvious to the naked eye) incorrect.

%%%%%%%Editable info%%%%%%
guns=3; intensities = 9; readings = 2;
filename = 'output';
COM_port = 'COM3'; %find this in Device Manager
gammaTableMAT = 'gammaTable.mat'; %later assumes gammaTable is inside
%%%%%%%%%%%%%%%%%%%%%%%%%%

success = 'False';

try
    PR655init(COM_port); %COM3 for my computer, may be different for yours.
catch me
    %PR655close();
    error(me)
end

try
    dos('FlipSS /off')
    
    load(gammaTableMAT)
    
    CMF = Load_Color_Matching_Functions('Color Matching Functions.txt');
    
    AssertOpenGL;
    screens=Screen('Screens');
	screenNumber=max(screens);
    [window screenRect]=Screen('OpenWindow', screenNumber, [128 128 128], [0 0 640 480]);
    Screen('LoadNormalizedGammaTable', window, gammaTable); %So long as the cal file was saved prior.
    output_texture = Screen('MakeTexture', window, [128 128 128]); %just for later
    
    priorityLevel=MaxPriority(window);
    Priority(priorityLevel);
    refreshrate=Screen('FrameRate',screenNumber);
   
    screenWidth = screenRect(3);
    screenHeight = screenRect(4);
    
    bitmap(screenHeight,screenWidth,3)=zeros;
    
    junkinput = input(['Move your window and focus your photometer\n' ...
        'Press Enter to continue'],'s');%#ok<NASGU>
    
    disp('You now have 10 seconds to leave the room.');
    
    WaitSecs(10);
    
    startTime = datestr(rem(now,1));
    
    fid = fopen([filename, ' ' num2str(screenWidth), 'x', ...
        num2str(screenHeight), ' ', date,'.cal'],'w');
    fprintf(fid, 'Calibration performed on %s\r\n', date);
    fprintf(fid, 'Refresh rate\t%u\r\n',refreshrate);
    fprintf(fid, 'Guns\t%u\tIntensities\t%u\tReadings\t%u\r\n',guns,intensities,readings);
    fprintf(fid, 'Gun\tIntensity\tReading\tX\tY\tZ\tx\ty\tLum\t'); %just print the headers.
    
    wavelengths=(380:4:780);
    
    for i=1:size(wavelengths,2);
        fprintf(fid,'%u',wavelengths(i));
        if i == size(wavelengths,2)
            fprintf(fid,'\r\n');
        else
            fprintf(fid,'\t');
        end
    end
    
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
            
            for readingcount=1:readings
%                 try
%                     [XYZ,qual] = PR655measxyz; %#ok<NASGU>
%                 catch %Whoops, no data. That's okay, put zeros in
%                     disp('Could not read XYZ, most likely due to low light levels.')
%                     disp('Zeros will be placed in the data for this.')
%                     XYZ(3,1)=zeros;
%                 end
%                 
%                 if XYZ == zeros
%                     xyL = zeros;
%                 else
%                     xyL = Convert_XYZ_to_xyL(XYZ);
%                 end
%                 
%                 fprintf(fid,'%u\t%u\t%u\t',guncount-1,intensitycount-1,readingcount-1);
%                 fprintf(fid,'%f\t%f\t%f\t',XYZ);
%                 fprintf(fid,'%f\t%f\t%f\t',xyL);
%                 clear XYZ xyL %just in case
                try
                    [spd, qual] = PR655measspd([380 4 101]);%#ok<NASGU> @%I think this is starting at 380 nm in steps of 4 nm for 101 total readings
                    spd = spd / 4; %the toolbox multiplies by 4 because it's in steps of 4 nm. For now, keep the original spectrum.
                catch me
                    %Whoops, no data. That's probably okay, put zeros in
                    disp('Could not read spectrum, most likely due to low light levels.')
                    disp('Zeros will be placed in the data for this.')
                    disp(me)
                    spd(101,1)=zeros;
                end
                
                ColorMatchingMultiplied = [spd .* CMF(:,1)*2732, spd .* CMF(:,2)*2732, spd .* CMF(:,3)*2732]; %Times 2732 to match Kyle's code.
                ColorMatchingSum = sum(ColorMatchingMultiplied,1); %should sum all the rows, keeping columns separate. 
                
                XYZ(3) = zeros;
                XYZ(1) = ColorMatchingSum(1);
                XYZ(2) = ColorMatchingSum(2);
                XYZ(3) = ColorMatchingSum(3);
                
                if XYZ == zeros
                    xyL = zeros;
                else
                    xyL = Convert_XYZ_to_xyL(XYZ);
                end
                
                fprintf(fid,'%u\t%u\t%u\t',guncount-1,intensitycount-1,readingcount-1);
                fprintf(fid,'%f\t%f\t%f\t',XYZ);
                fprintf(fid,'%f\t%f\t%f\t',xyL);
                clear XYZ xyL %just in case
                
                for i=1:size(spd,1)
                    fprintf(fid,'%E',spd(i)); %  '%E' for exponential 
                    if i == size(spd,1) %if at the end of the line
                        fprintf(fid,'\r\n') 
                    else %all we need is the tab
                        fprintf(fid,'\t') 
                    end
                end
                clear spd qual %just in case
            end
        end
    end
    
    PR655close();
    fclose(fid);
    
    success = 'True';
    Priority(0);
    Screen('CloseAll');
    
    endTime = datestr(rem(now,1));
    
    dos('FlipSS /on')
    
    disp('Monitor data acquired!')
    disp(['Started @ ' startTime])
    disp(['Ended   @ ' endTime]);  
    
    return
    
catch
    Priority(0);
    PR655close();
    Screen('CloseAll');
    dos('FlipSS /on')
    psychrethrow(psychlasterror);
end