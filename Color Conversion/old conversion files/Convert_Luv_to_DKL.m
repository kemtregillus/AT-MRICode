%     Public Function Convert_Luv_to_DKL(ByVal Luv() As Single) As Single()
%         Convert_Luv_to_DKL = Convert_xyL_to_DKL(Convert_Luv_to_xyL(Luv))
%     End Function

function Luv_to_DKL = Convert_Luv_to_DKL(Luv)
Luv_to_DKL = Convert_xyL_to_DKL(Convert_Luv_to_xyL(Luv));
end