%     Public Function Convert_Lab_to_xyL(ByVal Lab() As Single) As Single()
%         Convert_Lab_to_xyL = Convert_XYZ_to_xyL(Convert_Lab_to_XYZ(Lab))
%     End Function

function Lab_to_xyL = Convert_Lab_to_xyL(Lab,ColorInfo)
Lab_to_xyL = Convert_XYZ_to_xyL(Convert_Lab_to_XYZ(Lab,ColorInfo));
end