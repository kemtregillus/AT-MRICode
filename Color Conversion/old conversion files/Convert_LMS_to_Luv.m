%     Public Function Convert_LMS_to_Luv(ByVal LMS() As Single) As Single()
%         Convert_LMS_to_Luv = Convert_XYZ_to_Luv(Convert_LMS_to_XYZ(LMS))
%     End Function

function LMS_to_Luv = Convert_LMS_to_Luv(LMS)
LMS_to_Luv = Convert_XYZ_to_Luv(Convert_LMS_to_XYZ(LMS));
end