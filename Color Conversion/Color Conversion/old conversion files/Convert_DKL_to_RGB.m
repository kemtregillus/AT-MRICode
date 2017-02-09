function DKL_to_RGB = Convert_DKL_to_RGB(DKL_array, ColorInfo, UseMonitorData, ErrorSaturation)
    SngTemp = Convert_DKL_to_xyL(DKL_array);
    DKL_to_RGB = Convert_xyL_to_RGB(SngTemp, ColorInfo, UseMonitorData,ErrorSaturation);
end
