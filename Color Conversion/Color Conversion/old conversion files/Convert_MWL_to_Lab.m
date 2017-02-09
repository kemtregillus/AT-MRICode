%     Public Function Convert_MWL_to_Lab(ByVal MWL() As Single) As Single()
%         Convert_MWL_to_Lab = Convert_DKL_to_Lab(Convert_MWL_to_DKL(MWL))
%     End Function

function MWL_to_Lab = Convert_MWL_to_Lab(MWL,ColorInfo)
MWL_to_Lab = Convert_DKL_to_Lab(Convert_MWL_to_DKL(MWL),ColorInfo);
end