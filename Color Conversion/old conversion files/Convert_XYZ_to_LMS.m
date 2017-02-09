%     Public Function Convert_XYZ_to_LMS(ByVal XYZ() As Single) As Single()
%         Dim SngLMS(2) As Single
%         SngLMS(0) = 0.15516 * XYZ(0) + 0.54308 * XYZ(1) - 0.03287 * XYZ(2) 'L
%         SngLMS(1) = -0.15516 * XYZ(0) + 0.45692 * XYZ(1) + 0.03287 * XYZ(2) 'M
%         SngLMS(2) = 0 * XYZ(0) + 0 * XYZ(1) + 0.01608 * XYZ(2) 'S
%         Convert_XYZ_to_LMS = SngLMS 'Luminance information infused into LMS
%     End Function

function XYZ_to_LMS = Convert_XYZ_to_LMS(XYZ)
    SngLMS(3) = zeros;
    SngLMS(1) = 0.15516 * XYZ(1) + 0.54308 * XYZ(2) - 0.03287 * XYZ(3); % L
    SngLMS(2) = -0.15516 * XYZ(1) + 0.45692 * XYZ(2) + 0.03287 * XYZ(3); % M
    SngLMS(3) = 0 * XYZ(1) + 0 * XYZ(2) + 0.01608 * XYZ(3); % S
    
    XYZ_to_LMS = SngLMS; %Luminance information infused into LMS
end