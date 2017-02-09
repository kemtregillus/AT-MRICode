%     Public Function Convert_MWL_to_LMS(ByVal MWL() As Single) As Single()
%         Convert_MWL_to_LMS = Convert_DKL_to_LMS(Convert_MWL_to_DKL(MWL))
%     End Function

function MWL_to_LMS = Convert_MWL_to_LMS(MWL)
MWL_to_LMS = Convert_DKL_to_LMS(Convert_MWL_to_DKL(MWL));
end