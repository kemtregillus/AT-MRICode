%     Public Function Convert_Lab_to_XYZ(ByVal Lab() As Single) As Single()
%         Dim SngXYZ(2) As Single
%         SngXYZ(0) = ColorInfo.ReferenceWhite(0) * Lab_Function_Inverse((1 / 116) * (Lab(0) + 16) + (1 / 500) * Lab(1)) 'X
%         SngXYZ(1) = ColorInfo.ReferenceWhite(1) * Lab_Function_Inverse((1 / 116) * (Lab(0) + 16)) 'Y
%         SngXYZ(2) = ColorInfo.ReferenceWhite(2) * Lab_Function_Inverse((1 / 116) * (Lab(0) + 16) - (1 / 200) * Lab(2)) 'Z
%         Convert_Lab_to_XYZ = SngXYZ
%     End Function

function Lab_to_XYZ = Convert_Lab_to_XYZ(Lab,ColorInfo)
if exist('ColorInfo','var') == 1
    SngXYZ(3) = zeros;
    SngXYZ(1) = ColorInfo.ReferenceWhite(1) * Lab_Function_Inverse((1 / 116) * (Lab(1) + 16) + (1 / 500) * Lab(2)); % X
    SngXYZ(2) = ColorInfo.ReferenceWhite(2) * Lab_Function_Inverse((1 / 116) * (Lab(1) + 16)); % Y
    SngXYZ(3) = ColorInfo.ReferenceWhite(3) * Lab_Function_Inverse((1 / 116) * (Lab(1) + 16) - (1 / 200) * Lab(3)); % Z
    Lab_to_XYZ = SngXYZ;
else
    error('ColorInfo variable not found! Run Load_Monitor_Data to get it!')
end
end