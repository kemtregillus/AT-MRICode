% Public Function Convert_RGB_to_Luv(ByVal RGB() As Single, ByVal UseMonitorData As Boolean, Optional ByVal ErroronSaturation As Boolean = False) As Single()
%         Convert_RGB_to_Luv = Convert_XYZ_to_Luv(Convert_RGB_to_XYZ(RGB, UseMonitorData, ErroronSaturation))
%     End Function

function RGB_to_Luv = Convert_RGB_to_Luv(RGB, ColorInfo, UseMonitorData,ErrorSaturation)
RGB_to_Luv = Convert_XYZ_to_Luv(Convert_RGB_to_XYZ(RGB, ColorInfo, UseMonitorData,ErrorSaturation));
end
