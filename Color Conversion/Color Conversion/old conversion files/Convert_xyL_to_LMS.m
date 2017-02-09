%     Public Function Convert_xyL_to_LMS(ByVal xyL() As Single) As Single()
%         Convert_xyL_to_LMS = Convert_XYZ_to_LMS(Convert_xyL_to_XYZ(xyL))
%     End Function

function xyL_to_LMS = Convert_xyL_to_LMS(xyL)
xyL_to_LMS = Convert_XYZ_to_LMS(Convert_xyL_to_XYZ(xyL));
end