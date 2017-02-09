function Spectrum_from_RGB = Get_Spectrum_from_RGB(RGB_array, ColorInfo)

    SngTemp(101) = zeros;
    if exist('ColorInfo','var') && isfield(ColorInfo,'Intensity') && isfield(ColorInfo,'ColorMatchingFunctions')
        for IntWavelength=1:101
            for IntRGB = 1:3
                switch RGB_array(IntRGB)
                    case 1 %use first reading
                        SngTemp(IntWavelength) =  SngTemp(IntWavelength) + ColorInfo.Intensity(IntRGB, 1, IntWavelength);
                    case 2  %use last reading
                        SngTemp(IntWavelength) = SngTemp(IntWavelength)+ ...
                            ColorInfo.Intensity(IntRGB, size(ColorInfo.Intensity(),2),IntWavelength);
                    otherwise %interpolate
                        SngIntensity = RGB_array(IntRGB) * (size(ColorInfo.Intensity,2)-1);%RGB(IntRGB) * ColorInfo.Spectrum.GetUpperBound(1);
                        IntLowerIntensity = floor(SngIntensity)+ 1; %same as Int in VB. Plus 1 for array indexing.
                        IntHigherIntensity = IntLowerIntensity + 1;
                        SngIntensity = SngIntensity - IntLowerIntensity;
                        SngTemp(IntWavelength) = SngTemp(IntWavelength) + (1 - SngIntensity) * ...
                            ColorInfo.Intensity(IntRGB, IntLowerIntensity, IntWavelength) + SngIntensity * ...
                            ColorInfo.Intensity(IntRGB, IntHigherIntensity, IntWavelength);
                end                            
            end
        end
    end
    Spectrum_from_RGB = SngTemp;
end