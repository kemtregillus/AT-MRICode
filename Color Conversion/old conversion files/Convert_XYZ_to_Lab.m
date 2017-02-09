%     Public Function Convert_XYZ_to_Lab(ByVal XYZ() As Single) As Single()
%         Dim SngLab(2) As Single
%         SngLab(0) = 116 * Lab_Function(XYZ(1) / ColorInfo.ReferenceWhite(1)) - 16 'L*
%         SngLab(1) = 500 * (Lab_Function(XYZ(0) / ColorInfo.ReferenceWhite(0)) - Lab_Function(XYZ(1) / ColorInfo.ReferenceWhite(1))) 'a*
%         SngLab(2) = 200 * (Lab_Function(XYZ(1) / ColorInfo.ReferenceWhite(1)) - Lab_Function(XYZ(2) / ColorInfo.ReferenceWhite(2))) 'b*
%         Convert_XYZ_to_Lab = SngLab
%     End Function

function XYZ_to_Lab = Convert_XYZ_to_Lab(XYZ,ColorInfo)
if exist('ColorInfo','var') == 1
    SngLab(3) = zeros;
    SngLab(1) = 116 * Lab_Function(XYZ(2) / ColorInfo.ReferenceWhite(2)) - 16; % L*
    SngLab(2) = 500 * (Lab_Function(XYZ(1) / ColorInfo.ReferenceWhite(1)) - Lab_Function(XYZ(2) / ColorInfo.ReferenceWhite(2))); % a*
    SngLab(3) = 200 * (Lab_Function(XYZ(2) / ColorInfo.ReferenceWhite(2)) - Lab_Function(XYZ(3) / ColorInfo.ReferenceWhite(3))); % b*
    XYZ_to_Lab = SngLab;
else
    error('ColorInfo variable not found! Run Load_Monitor_Data to get it!')
end
end