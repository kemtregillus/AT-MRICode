function xyL_to_MWL = Convert_xyL_to_MWL(xyL_array)
    SngTemp = Convert_xyL_to_DKL(xyL_array);
    xyL_to_MWL = Convert_DKL_to_MWL(SngTemp);
end