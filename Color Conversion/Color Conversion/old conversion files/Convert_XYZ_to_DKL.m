function XYZ_to_DKL = Convert_XYZ_to_DKL(XYZ_array)
    SngTemp=Convert_XYZ_to_xyL(XYZ_array);
    XYZ_to_DKL = Convert_xyL_to_DKL(SngTemp);
end
