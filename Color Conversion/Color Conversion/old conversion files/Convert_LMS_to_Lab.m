%     Public Function Convert_LMS_to_Lab(ByVal LMS() As Single) As Single()
%         Convert_LMS_to_Lab = Convert_XYZ_to_Lab(Convert_LMS_to_XYZ(LMS))
%     End Function

function LMS_to_Lab = Convert_LMS_to_Lab(LMS,ColorInfo)
LMS_to_Lab = Convert_XYZ_to_Lab(Convert_LMS_to_XYZ(LMS),ColorInfo);
end