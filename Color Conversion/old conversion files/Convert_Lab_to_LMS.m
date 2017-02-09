%     Public Function Convert_Lab_to_LMS(ByVal Lab() As Single) As Single()
%         Convert_Lab_to_LMS = Convert_XYZ_to_LMS(Convert_Lab_to_XYZ(Lab))
%     End Function

function Lab_to_LMS = Convert_Lab_to_LMS(Lab,ColorInfo)
Lab_to_LMS = Convert_XYZ_to_LMS(Convert_Lab_to_XYZ(Lab,ColorInfo));
end