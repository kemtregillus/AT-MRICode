%     Public Function Convert_LMS_to_xyL(ByVal LMS() As Single) As Single()
%         Convert_LMS_to_xyL = Convert_XYZ_to_xyL(Convert_LMS_to_XYZ(LMS))
%     End Function

function LMS_to_xyL = Convert_LMS_to_xyL(LMS)
LMS_to_xyL = Convert_XYZ_to_xyL(Convert_LMS_to_XYZ(LMS));
end