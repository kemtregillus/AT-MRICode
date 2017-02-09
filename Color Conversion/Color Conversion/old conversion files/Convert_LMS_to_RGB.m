%     Public Function Convert_LMS_to_RGB(ByVal LMS() As Single, ByVal UseMonitorData As Boolean, Optional ByVal ErroronSaturation As Boolean = False) As Single()
%         Convert_LMS_to_RGB = Convert_XYZ_to_RGB(Convert_LMS_to_XYZ(LMS), UseMonitorData, ErroronSaturation)
%     End Function

function LMS_to_RGB = Convert_LMS_to_RGB(LMS,ColorInfo,UseMonitorData,ErrorSaturation)
LMS_to_RGB = Convert_XYZ_to_RGB(Convert_LMS_to_XYZ(LMS), ColorInfo, UseMonitorData,ErrorSaturation);
end
