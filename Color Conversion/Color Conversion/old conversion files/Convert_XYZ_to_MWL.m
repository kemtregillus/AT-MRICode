function XYZ_to_MWL = Convert_XYZ_to_MWL(XYZ_array)
    SngTemp=Convert_XYZ_to_xyL(XYZ_array);
    XYZ_to_MWL = Convert_xyL_to_MWL(SngTemp);
end