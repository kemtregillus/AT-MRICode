%     Public Function Convert_LMS_to_MWL(ByVal LMS() As Single) As Single()
%         Convert_LMS_to_MWL = Convert_DKL_to_MWL(Convert_LMS_to_DKL(LMS))
%     End Function

function LMS_to_MWL = Convert_LMS_to_MWL(LMS)
LMS_to_MWL = Convert_DKL_to_MWL(Convert_LMS_to_DKL(LMS));
end