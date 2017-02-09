function RGB_to_XYZ = Convert_RGB_to_XYZ(RGB_array,ColorInfo,UseMonitorData,ErrorSaturation)
% This function will need to know the ColorInfo struct, but should NOT need
% to change it.
%

%%% Error Checking
if RGB_array(1) < 0
    RGB_array(1) = 0;
    disp('Warning: Red value cannot be less than zero.');
end
if RGB_array(1) > 1
    RGB_array(1) = 1;
    disp('Warning: Red value cannot be greater than one.');
end
if RGB_array(2) < 0
    RGB_array(2) = 0;
    disp('Warning: Green value cannot be less than zero.');
end
if RGB_array(2) > 1
    RGB_array(2) = 1;
    disp('Warning: Green value cannot be greater than one.');
end
if RGB_array(3) < 0
    RGB_array(3) = 0;
    disp('Warning: Blue value cannot be less than zero.');
end
if RGB_array(3) > 1
    RGB_array(3) = 1;
    disp('Warning: Blue value cannot be greater than one.');
end

if ErrorSaturation == true
    error('RGB value either below 0 or above 1, see warning above')
end

SngTemp(3) = zeros;

if UseMonitorData == false %Use XYZ Matrix calculation
    
    if ColorInfo.XYZMatrix ~= zeros
        for IntRGB=1:3
            for IntXYZ = 1:3
                SngTemp(IntXYZ) = SngTemp(IntXYZ) + ColorInfo.XYZMatrix(IntRGB, IntXYZ) * RGB_array(IntRGB);
            end
        end
    end
    
else % Use measured spectra
    
    if isfield(ColorInfo,'Intensity') && isfield(ColorInfo,'ColorMatchingFunctions')
        SngTempSpectrum= Get_Spectrum_from_RGB(RGB_array,ColorInfo);
        for IntXYZ = 1:3
            for IntWavelength = 1:numel(SngTempSpectrum)
                SngTemp(IntXYZ) = SngTemp(IntXYZ) + ColorInfo.ColorMatchingFunctions(IntWavelength, IntXYZ) * ...
                    SngTempSpectrum(IntWavelength) * 2732;
            end
        end
    end
end

RGB_to_XYZ = SngTemp;

end
