function DKL_to_XYZ = Convert_DKL_to_XYZ(DKL_array)
    SngTemp = Convert_DKL_to_xyL(DKL_array);
    DKL_to_XYZ = Convert_xyL_to_XYZ(SngTemp);
end