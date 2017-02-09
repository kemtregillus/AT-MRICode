%     Public Function Convert_DKL_to_Luv(ByVal DKL() As Single) As Single()
%         Convert_DKL_to_Luv = Convert_LMS_to_Luv(Convert_DKL_to_LMS(DKL))
%     End Function

function DKL_to_Luv = Convert_DKL_to_Luv(DKL)
DKL_to_Luv = Convert_LMS_to_Luv(Convert_DKL_to_LMS(DKL));
end