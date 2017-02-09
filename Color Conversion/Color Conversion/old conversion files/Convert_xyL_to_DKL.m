function xyL_to_DKL = Convert_xyL_to_DKL(xyL_array) %Coefficients taken from Human Color Vision Appendix Equation A.3.14
    SngLMS(3)= zeros; SngTemp(3)=zeros;
    SngLMS(1) = 0.15516 * xyL_array(1) + 0.54308 * xyL_array(2) - 0.03287 * (1 - xyL_array(1) - xyL_array(2));
    SngLMS(2) = -0.15516 * xyL_array(1) + 0.45692 * xyL_array(2) + 0.03287 * (1 - xyL_array(1) - xyL_array(2));
    SngLMS(3) = 0 * xyL_array(1) + 0 * xyL_array(2) + 0.01608 * (1 - xyL_array(1) - xyL_array(2));
    SngTemp(1) = SngLMS(1) / (SngLMS(1) + SngLMS(2));
    SngTemp(2) = SngLMS(3) / (SngLMS(1) + SngLMS(2));
    SngTemp(3) = xyL_array(3);
    xyL_to_DKL = SngTemp;
end