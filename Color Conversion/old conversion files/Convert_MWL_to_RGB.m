function MWL_to_RGB = Convert_MWL_to_RGB(MWL_array, ColorInfo, UseMonitorData,ErrorSaturation)
    SngTemp = Convert_MWL_to_DKL(MWL_array);
    MWL_to_RGB = Convert_DKL_to_RGB(SngTemp, ColorInfo, UseMonitorData,ErrorSaturation);
end
