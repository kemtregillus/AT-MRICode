function RGB_to_xyL = Convert_RGB_to_xyL(RGB_array,ColorInfo,UseMonitorData,ErrorSaturation)

SngTemp = Convert_RGB_to_XYZ(RGB_array,ColorInfo,UseMonitorData,ErrorSaturation);
RGB_to_xyL = Convert_XYZ_to_xyL(SngTemp);

end
