%     Public Function Convert_Luv_to_XYZ(ByVal Luv() As Single) As Single()
%         Convert_Luv_to_XYZ = Convert_xyL_to_XYZ(Convert_Luv_to_xyL(Luv))
%     End Function

function Luv_to_XYZ = Convert_Luv_to_XYZ(Luv)
    Luv_to_XYZ = Convert_xyL_to_XYZ(Convert_Luv_to_xyL(Luv));
end