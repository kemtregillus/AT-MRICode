%     Public Function Convert_xyL_to_Luv(ByVal xyL() As Single) As Single()
%         Convert_xyL_to_Luv = Convert_XYZ_to_Luv(Convert_xyL_to_XYZ(xyL))
%     End Function

function xyL_to_Luv =  Convert_xyL_to_Luv(xyL)
    xyL_to_Luv = Convert_XYZ_to_Luv(Convert_xyL_to_XYZ(xyL));
end