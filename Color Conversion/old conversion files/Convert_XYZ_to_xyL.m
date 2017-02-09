function XYZ_to_xyL = Convert_XYZ_to_xyL(XYZ_array)
    SngTemp(3)=zeros;
    SngTemp(1)=XYZ_array(1)/(XYZ_array(1) + XYZ_array(2) + XYZ_array(3));
    SngTemp(2) = XYZ_array(2) / (XYZ_array(1) + XYZ_array(2) + XYZ_array(3));
    SngTemp(3) = XYZ_array(2);
    XYZ_to_xyL = SngTemp;
end