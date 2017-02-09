function DKL_to_xyL = Convert_DKL_to_xyL(DKL_array) %Coefficients taken from Human Color Vision Appendix Equation A.4.3
    SngXYZ(3) = zeros; SngTemp(3)=zeros;
    SngXYZ(1) = 2.9448 * DKL_array(1) - 3.5001 * (1 - DKL_array(1)) + 13.1745 * DKL_array(2);
    SngXYZ(2) = 1 * DKL_array(1) + 1 * (1 - DKL_array(1)) + 0 * DKL_array(2);
    SngXYZ(3) = 0 * DKL_array(1) + 0 * (1 - DKL_array(1)) + 62.1891 * DKL_array(2);
    SngTemp(1) = SngXYZ(1) / (SngXYZ(1) + SngXYZ(2) + SngXYZ(3));
    SngTemp(2) = SngXYZ(2) / (SngXYZ(1) + SngXYZ(2) + SngXYZ(3));
    SngTemp(3) = DKL_array(3);
    DKL_to_xyL = SngTemp;
end