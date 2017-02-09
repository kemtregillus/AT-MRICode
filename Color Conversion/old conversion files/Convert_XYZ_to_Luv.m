% Public Function Convert_XYZ_to_Luv(ByVal XYZ() As Single) As Single()
%         Dim SngLuv(2) As Single
%         SngLuv(0) = XYZ(1) 'L = Y
%         SngLuv(1) = (4 * XYZ(0)) / (XYZ(0) + 15 * XYZ(1) + 3 * XYZ(2)) 'u'
%         SngLuv(2) = (9 * XYZ(1)) / (XYZ(0) + 15 * XYZ(1) + 3 * XYZ(2)) 'v'
%         Convert_XYZ_to_Luv = SngLuv
%     End Function

function XYZ_to_Luv = Convert_XYZ_to_Luv(XYZ)
    SngLuv(3) = zeros;
    SngLuv(1) = XYZ(2); %L = Y
    SngLuv(2) = (4 * XYZ(1))/(XYZ(1) + 15 * XYZ(2) + 3 * XYZ(3)); %u'
    SngLuv(3) = (9 * XYZ(2))/(XYZ(1) + 15 * XYZ(2) + 3 * XYZ(3)); %v'
    XYZ_to_Luv = SngLuv;
end