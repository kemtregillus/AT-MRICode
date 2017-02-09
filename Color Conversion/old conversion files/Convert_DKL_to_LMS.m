%     Public Function Convert_DKL_to_LMS(ByVal DKL() As Single) As Single()
%         Dim SngLMSRatio(2) As Single
%         SngLMSRatio(0) = DKL(0) 'L / (L + M)
%         SngLMSRatio(1) = 1 - DKL(0) 'M / (L + M) = 1 - (L / (L + M))
%         SngLMSRatio(2) = DKL(1) 'S / (L + M)
%         Dim SngLMS(2) As Single
%         SngLMS(0) = SngLMSRatio(0) * DKL(2) 'L
%         SngLMS(1) = SngLMSRatio(1) * DKL(2) 'M
%         SngLMS(2) = SngLMSRatio(2) * DKL(2) 'S
%         Convert_DKL_to_LMS = SngLMS
%     End Function

function DKL_to_LMS = Convert_DKL_to_LMS(DKL)
SngLMSRatio(3) = zeros;
SngLMS(3) = zeros;
SngLMSRatio(1) = DKL(1); %L/(L+M)
SngLMSRatio(2) = 1 - DKL(1); %1 - DKL(0) 'M / (L + M) = 1 - (L / (L + M))
SngLMSRatio(3) = DKL(2);%S / (L + M)
SngLMS(1) = SngLMSRatio(1) * DKL(3); %L
SngLMS(2) = SngLMSRatio(2) * DKL(3); %M
SngLMS(3) = SngLMSRatio(3) * DKL(3); %S
DKL_to_LMS = SngLMS;
end