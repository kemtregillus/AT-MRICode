%     Public Function Convert_Luv_to_MWL(ByVal Luv() As Single) As Single()
%         Convert_Luv_to_MWL = Convert_xyL_to_MWL(Convert_Luv_to_xyL(Luv))
%     End Function

function Luv_to_MWL = Convert_Luv_to_MWL(Luv)
Luv_to_MWL = Convert_xyL_to_MWL(Convert_Luv_to_xyL(Luv));
end