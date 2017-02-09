function XYZ_to_RGB = Convert_XYZ_to_RGB(XYZ_array, ColorInfo, UseMonitorData,ErrorSaturation)

SngTemp(3)=zeros;
SngEstimate(3)=zeros;
SngError(3)=zeros;

if ColorInfo.RGBMatrix ~= zeros
    if UseMonitorData == false  %Use RGB Matrix Calculation
        for IntXYZ = 1:3
            for IntRGB = 1:3
                SngTemp(IntRGB) = SngTemp(IntRGB) + ColorInfo.RGBMatrix(IntXYZ, IntRGB)* XYZ_array(IntXYZ);
            end
        end
    else %Use Measured Spectra
        for IntXYZ = 1:3
            for IntRGB = 1:3
                
                SngEstimate(IntRGB) = SngEstimate(IntRGB)+ ColorInfo.RGBMatrix(IntXYZ, IntRGB) * XYZ_array(IntXYZ);
            end
        end
        
        SngMeasure = Convert_RGB_to_XYZ(SngEstimate, ColorInfo, UseMonitorData);
        
        for IntXYZ = 1:3
            SngError(IntXYZ) = XYZ_array(IntXYZ) - SngMeasure(IntXYZ);
            for IntRGB=1:3
                SngTemp(IntRGB) = SngTemp(IntRGB) + ColorInfo.RGBMatrix(IntXYZ, IntRGB) * (XYZ_array(IntXYZ) + SngError(IntXYZ));
            end
        end
    end
end

%%% Error Checking
if SngTemp(1) < 0
    SngTemp(1) = 0;
    disp('Warning: Red value cannot be less than zero.');
end
if SngTemp(1) > 1
    SngTemp(1) = 1;
    disp('Warning: Red value cannot be greater than one.');
end
if SngTemp(2) < 0
    SngTemp(2) = 0;
    disp('Warning: Green value cannot be less than zero.');
end
if SngTemp(2) > 1
    SngTemp(2) = 1;
    disp('Warning: Green value cannot be greater than one.');
end
if SngTemp(3) < 0
    SngTemp(3) = 0;
    disp('Warning: Blue value cannot be less than zero.')
end
if SngTemp(3) > 1
    SngTemp(3) = 1;
    disp('Warning: Blue value cannot be greater than one.');
end

if ErrorSaturation == true
   error('Color requested give an RGB value either below zero or above one, see above')
end

XYZ_to_RGB = SngTemp;
end
