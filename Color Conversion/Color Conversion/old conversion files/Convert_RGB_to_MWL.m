function RGB_to_MWL = Convert_RGB_to_MWL(RGB_array, ColorInfo, UseMonitorData,ErrorSaturation)
    SngTemp = Convert_RGB_to_XYZ(RGB_array, ColorInfo, UseMonitorData,ErrorSaturation);
    RGB_to_MWL = Convert_XYZ_to_MWL(SngTemp);    
end
