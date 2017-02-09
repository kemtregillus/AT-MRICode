function xyL_to_XYZ = Convert_xyL_to_XYZ(xyL_array)
    SngTemp(3)=zeros;
    if xyL_array(3) > 0
        SngTemp(1) = xyL_array(1) * (xyL_array(3) / xyL_array(2));
        SngTemp(2) = xyL_array(2) * (xyL_array(3) / xyL_array(2)); %'= xyL(2)
        SngTemp(3) = (1 - xyL_array(1) - xyL_array(2)) * (xyL_array(3) / xyL_array(2));
    end
    xyL_to_XYZ = SngTemp;
end