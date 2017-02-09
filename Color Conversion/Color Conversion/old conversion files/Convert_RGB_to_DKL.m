function RGB_to_DKL = Convert_RGB_to_DKL(RGB_array,ColorInfo,UseMonitorData,ErrorSaturation)
    SngTemp = Convert_RGB_to_XYZ(RGB_array, ColorInfo, UseMonitorData,ErrorSaturation);
    RGB_to_DKL = Convert_XYZ_to_DKL(SngTemp);
end
