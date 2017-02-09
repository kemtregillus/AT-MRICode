%     Public Function Convert_Lab_to_MWL(ByVal Lab() As Single) As Single()
%         Convert_Lab_to_MWL = Convert_XYZ_to_MWL(Convert_Lab_to_XYZ(Lab))
%     End Function

function Lab_to_MWL = Convert_Lab_to_MWL(Lab,ColorInfo)
Lab_to_MWL = Convert_XYZ_to_MWL(Convert_Lab_to_XYZ(Lab,ColorInfo));
end