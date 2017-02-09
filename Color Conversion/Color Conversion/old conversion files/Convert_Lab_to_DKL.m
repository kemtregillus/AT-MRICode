%     Public Function Convert_Lab_to_DKL(ByVal Lab() As Single) As Single()
%         Convert_Lab_to_DKL = Convert_XYZ_to_DKL(Convert_Lab_to_XYZ(Lab))
%     End Function

function Lab_to_DKL = Convert_Lab_to_DKL(Lab,ColorInfo)
Lab_to_DKL = Convert_XYZ_to_DKL(Convert_Lab_to_XYZ(Lab,ColorInfo));
end