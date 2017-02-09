%     Public Function Convert_Lab_to_RGB(ByVal Lab() As Single, ByVal UseMonitorData As Boolean, Optional ByVal ErroronSaturation As Boolean = False) As Single()
%         Convert_Lab_to_RGB = Convert_XYZ_to_RGB(Convert_Lab_to_XYZ(Lab), UseMonitorData, ErroronSaturation)
%     End Function

function Lab_to_RGB = Convert_Lab_to_RGB(Lab,ColorInfo,UseMonitorData,ErrorSaturation)
Lab_to_RGB = Convert_XYZ_to_RGB(Convert_Lab_to_XYZ(Lab,ColorInfo), ColorInfo, UseMonitorData,ErrorSaturation);
end
