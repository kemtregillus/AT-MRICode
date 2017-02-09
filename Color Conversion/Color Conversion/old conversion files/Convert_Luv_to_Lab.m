%     Public Function Convert_Luv_to_Lab(ByVal Luv() As Single) As Single()
%         Convert_Luv_to_Lab = Convert_xyL_to_Lab(Convert_Luv_to_xyL(Luv))
%     End Function

function Luv_to_Lab = Convert_Luv_to_Lab(Luv,ColorInfo)
Luv_to_Lab = Convert_xyL_to_Lab(Convert_Luv_to_xyL(Luv),ColorInfo);
end