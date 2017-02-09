function MWL_to_xyL = Convert_MWL_to_xyL(MWL_array)
    SngTemp = Convert_MWL_to_DKL(MWL_array);
    MWL_to_xyL = Convert_DKL_to_xyL(SngTemp);
end