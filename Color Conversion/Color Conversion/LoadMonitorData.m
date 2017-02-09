% This is part of a collection of color conversion routines designed to
% put colors into the desired color space.
%
% This function reads in monitor data and returns the color info of a
% particular monitor.
%
% This code was converted from Visual Basic to Matlab with the following
% changes:
%
% What was once called ColorInfo.Spectrum(,,).X and .Y are now called
% ColorInfo.Wavelength(,,) for X and ColorInfo.Intensity(,,) for .Y, where
% each wavelength matches one and only one intensity.
%
% '%s' is a string, '%c' is a single character, '%u' is an integer, and
% '%f' is a floating point.
%
% "%#ok<NASGU>" (without quotes) suppresses unnecessary warnings.
%
% Last updated:     13 March 2012 to include ReferenceWhite as a member of
%                   the structure.

function ColorInfo = Load_Monitor_Data(FileName)
try
    if exist('FileName','var') == 0
        %If FileName doesn't exist, use default.
        FileName = 'Default.cal'; %Must be in current directory.
    end

    fid = fopen(FileName);
    if fid > 0 %make sure file exists

        junk = textscan(fid, '%s',6);%#ok<NASGU> %One for each string (%s)
        input = textscan(fid, '%u',1);
        ColorInfo.RefreshRate = input{1,1};

        junk = textscan(fid, '%s', 1);%#ok<NASGU>
        input = textscan(fid, '%u',1);
        IntGunTotal = input{1,1};

        junk = textscan(fid, '%s', 1);%#ok<NASGU>
        input = textscan(fid, '%u',1);
        IntIntensityTotal = input{1,1};

        junk = textscan(fid, '%s', 1);%#ok<NASGU>
        input = textscan(fid, '%u',1);
        IntReadingTotal = input{1,1};

        ColorInfo.XYZMatrix(3,3) = zeros;
        ColorInfo.MaxLuminance(3) = zeros;

        ColorInfo.Wavelength(3,IntIntensityTotal,101) = zeros;
        ColorInfo.Intensity(3,IntIntensityTotal,101) = zeros;
% 
        junk = textscan(fid, '%s', 110); %#ok<NASGU> %simulates the old for loop, getting rid of junk.

        while (feof(fid) ~= 1)
            input = textscan(fid, '%u',1); IntGun = input{1,1} + 1; clear input;
            input = textscan(fid, '%u',1); IntIntensity = input{1,1}+1; clear input;
            input = textscan(fid, '%u',1); IntReading = input{1,1}+1; clear input;

            for IntXYZ = 1:3 % Average XYZ across all intensities and readings (some will be zeroes but that won't hurt anything)
                input = textscan(fid, '%f',1); SngTemp = input{1,1};
                ColorInfo.XYZMatrix(IntGun, IntXYZ) = ColorInfo.XYZMatrix(IntGun, IntXYZ) + ...
                    SngTemp / double(IntIntensityTotal * IntReadingTotal); % must change to double to keep double type.
            end

            junk = textscan(fid, '%s', 2);%#ok<NASGU> %Want to get x and y.
            input = textscan(fid, '%f',1); SngTemp = input{1,1}; clear input;

            if IntIntensity == IntIntensityTotal
                ColorInfo.MaxLuminance(IntGun) = ColorInfo.MaxLuminance(IntGun) + SngTemp / double(IntReadingTotal);
            end

            for IntWavelength = 1:101
                ColorInfo.Wavelength(IntGun, IntIntensity, IntWavelength) = 380 + 4 * (IntWavelength - 1);
                input = textscan(fid, '%f',1); SngTemp = input{1,1}; clear input;
                ColorInfo.Intensity(IntGun,IntIntensity, IntWavelength) = ...
                    ColorInfo.Intensity(IntGun,IntIntensity, IntWavelength) + SngTemp / double(IntReadingTotal);
            end

            if IntGun == IntGunTotal && IntIntensity == IntIntensityTotal && IntReading == IntReadingTotal
                junk = textscan(fid, '%c', 1);%#ok<NASGU> %gets the last carriage return.
            end

        end

        fclose(fid);

        for IntGun = 1:3
            SngY = ColorInfo.XYZMatrix(IntGun,2);
            for IntXYZ = 1:3
                ColorInfo.XYZMatrix(IntGun, IntXYZ) = ColorInfo.XYZMatrix(IntGun, IntXYZ) * ...
                    ColorInfo.MaxLuminance(IntGun) / SngY;
            end
        end

        ColorInfo.RGBMatrix = Create_RGB_Matrix(ColorInfo.XYZMatrix);
        ColorInfo.CIEx(3) = zeros; ColorInfo.CIEy(3) = zeros; 
        ColorInfo.ReferenceWhite(3) = zeros;
        for IntGun=1:3
            ColorInfo.CIEx(IntGun) = ColorInfo.XYZMatrix(IntGun, 1) / (ColorInfo.XYZMatrix(IntGun, 1) + ...
                ColorInfo.XYZMatrix(IntGun, 2) + ColorInfo.XYZMatrix(IntGun, 3));
            ColorInfo.CIEy(IntGun) = ColorInfo.XYZMatrix(IntGun, 2) / (ColorInfo.XYZMatrix(IntGun, 1) + ...
                ColorInfo.XYZMatrix(IntGun, 2) + ColorInfo.XYZMatrix(IntGun, 3));
            ColorInfo.ReferenceWhite(IntGun) = ColorInfo.XYZMatrix(1,IntGun) + ColorInfo.XYZMatrix(2,IntGun) + ...
                ColorInfo.XYZMatrix(3,IntGun);
        end
        
        %Gets the color matching function info and puts it where needed
        ColorMatch = Load_Color_Matching_Functions();
        ColorInfo.ColorMatchingFunctions = ColorMatch;
        clear ColorMatch
        
    else
        fclose(fid);
        disp('File not found!');
        ColorInfo = 0;
    end
catch me
    disp('Error loading monitor calibration data!');
    clear ColorInfo; %just for error checking.
    rethrow(me);
end
clear junk input fid;
end