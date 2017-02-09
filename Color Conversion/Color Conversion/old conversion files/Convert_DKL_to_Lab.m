%     Public Function Convert_DKL_to_Lab(ByVal DKL() As Single) As Single()
%         Convert_DKL_to_Lab = Convert_LMS_to_Lab(Convert_DKL_to_LMS(DKL))
%     End Function

function DKL_to_Lab = Convert_DKL_to_Lab(DKL,ColorInfo)
DKL_to_Lab = Convert_LMS_to_Lab(Convert_DKL_to_LMS(DKL),ColorInfo);
end