function MWL_to_XYZ = Convert_MWL_to_XYZ(MWL_array)
    SngTemp = Convert_MWL_to_DKL(MWL_array);
    MWL_to_XYZ = Convert_DKL_to_XYZ(SngTemp);
end