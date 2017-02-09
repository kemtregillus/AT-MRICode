%     Public Function Convert_MWL_to_Luv(ByVal MWL() As Single) As Single()
%         Convert_MWL_to_Luv = Convert_DKL_to_Luv(Convert_MWL_to_DKL(MWL))
%     End Function

function MWL_to_Luv = Convert_MWL_to_Luv(MWL)
MWL_to_Luv = Convert_DKL_to_Luv(Convert_MWL_to_DKL(MWL));
end