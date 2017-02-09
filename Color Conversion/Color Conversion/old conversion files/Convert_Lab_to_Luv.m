%     Public Function Convert_Lab_to_Luv(ByVal Lab() As Single) As Single()
%         Convert_Lab_to_Luv = Convert_XYZ_to_Luv(Convert_Lab_to_XYZ(Lab))
%     End Function

function Lab_to_Luv = Convert_Lab_to_Luv(Lab,ColorInfo)
Lab_to_Luv = Convert_XYZ_to_Luv(Convert_Lab_to_XYZ(Lab,ColorInfo));
end