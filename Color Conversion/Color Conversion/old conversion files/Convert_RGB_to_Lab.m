% Public Function Convert_RGB_to_Lab(ByVal RGB() As Single, ByVal UseMonitorData As Boolean, Optional ByVal ErroronSaturation As Boolean = False) As Single()
%         Convert_RGB_to_Lab = Convert_XYZ_to_Lab(Convert_RGB_to_XYZ(RGB, UseMonitorData, ErroronSaturation))
%     End Function

function RGB_to_Lab = Convert_RGB_to_Lab(RGB,ColorInfo,UseMonitorData,ErrorSaturation)
RGB_to_Lab = Convert_XYZ_to_Lab(Convert_RGB_to_XYZ(RGB, ColorInfo, UseMonitorData),ColorInfo,ErrorSaturation);
end
