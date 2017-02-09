%     Public Function Convert_Luv_to_LMS(ByVal Luv() As Single) As Single()
%         Convert_Luv_to_LMS = Convert_xyL_to_LMS(Convert_Luv_to_xyL(Luv))
%     End Function

function Luv_to_LMS = Convert_Luv_to_LMS(Luv)
Luv_to_LMS = Convert_xyL_to_LMS(Convert_Luv_to_xyL(Luv));
end