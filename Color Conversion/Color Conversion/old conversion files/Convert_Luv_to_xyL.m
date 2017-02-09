%     Public Function Convert_Luv_to_xyL(ByVal Luv() As Single) As Single()
%         Dim SngxyL(2) As Single
%         SngxyL(0) = (9 * Luv(1)) / (6 * Luv(1) - 16 * Luv(2) + 12) 'x
%         SngxyL(1) = (4 * Luv(2)) / (6 * Luv(1) - 16 * Luv(2) + 12) 'y
%         SngxyL(2) = Luv(0) 'L
%         Convert_Luv_to_xyL = SngxyL
%     End Function

function Luv_to_xyL = Convert_Luv_to_xyL(Luv)
SngxyL(3) = zeros;
SngxyL(1) = (9 * Luv(2)) / (6 * Luv(2) - 16 * Luv(3) + 12); % x
SngxyL(2) = (4 * Luv(3)) / (6 * Luv(2) - 16 * Luv(3) + 12); % y
SngxyL(3) = Luv(1); % L
Luv_to_xyL = SngxyL;
end