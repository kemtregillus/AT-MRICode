%     Public Function Convert_LMS_to_DKL(ByVal LMS() As Single) As Single()
%         Dim SngDKL(2) As Single
%         SngDKL(0) = LMS(0) / (LMS(0) + LMS(1)) 'L / (L + M)
%         SngDKL(1) = LMS(2) / (LMS(0) + LMS(1)) 'S / (L + M)
%         SngDKL(2) = LMS(0) + LMS(1) 'L + M = Y
%         Convert_LMS_to_DKL = SngDKL
%     End Function

function LMS_to_DKL = Convert_LMS_to_DKL(LMS)
SngDKL(3) = zeros;
SngDKL(1) = LMS(1) / (LMS(1) + LMS(2)); %L/(L+M)
SngDKL(2) = LMS(3) / (LMS(1) + LMS(2)); %S/(L+M)
SngDKL(3) = LMS(1) + LMS(2);%L+M = Y
LMS_to_DKL = SngDKL;
end