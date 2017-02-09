%     Public Function Convert_LMS_to_XYZ(ByVal LMS() As Single) As Single() 'Coefficients taken from Human Color Vision Appendix Equation A.4.3
%         Dim SngXYZ(2) As Single
%         SngXYZ(0) = 2.9448 * LMS(0) - 3.5001 * LMS(1) + 13.1745 * LMS(2) 'X - Refernece incorrectly uses 35001 instead of 3.5001
%         SngXYZ(1) = 1 * LMS(0) + 1 * LMS(1) + 0 * LMS(2) 'Y = L + M
%         SngXYZ(2) = 0 * LMS(0) + 0 * LMS(1) + 62.1891 * LMS(2) 'Z
%         Convert_LMS_to_XYZ = SngXYZ
%     End Function

function LMS_to_XYZ = Convert_LMS_to_XYZ(LMS)
SngXYZ(3) = zeros;
SngXYZ(1) = 2.9448 * LMS(1) - 3.5001 * LMS(2) + 13.1745 * LMS(3); %X - Reference incorrectly uses 35001 instead of 3.5001
SngXYZ(2) = 1 * LMS(1) + 1 * LMS(2) + 0 * LMS(3); % Y = L + M
SngXYZ(3) = 0 * LMS(1) + 0 * LMS(2) + 62.1891 * LMS(3); %Z
LMS_to_XYZ = SngXYZ;
end