% Public Function Convert_RGB_to_LMS(ByVal RGB() As Single, ByVal UseMonitorData As Boolean, Optional ByVal ErroronSaturation As Boolean = False) As Single()
%         Convert_RGB_to_LMS = Convert_XYZ_to_LMS(Convert_RGB_to_XYZ(RGB, UseMonitorData, ErroronSaturation))
%     End Function

function RGB_to_LMS = Convert_RGB_to_LMS(RGB,ColorInfo,UseMonitorData,ErrorSaturation)
RGB_to_LMS = Convert_XYZ_to_LMS(Convert_RGB_to_XYZ(RGB, ColorInfo, UseMonitorData),ErrorSaturation);
end
