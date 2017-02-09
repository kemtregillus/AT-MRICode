%     Public Function Convert_xyL_to_Lab(ByVal xyL() As Single) As Single()
%         Convert_xyL_to_Lab = Convert_XYZ_to_Lab(Convert_xyL_to_XYZ(xyL))
%     End Function

function xyL_to_Lab = Convert_xyL_to_Lab(xyL,ColorInfo)

xyL_to_Lab = Convert_XYZ_to_Lab(Convert_xyL_to_XYZ(xyL),ColorInfo);

end