function RGB_Matrix = Create_RGB_Matrix(XYZMatrix)
    SngTemp(3,3) = zeros;
    XR = XYZMatrix(1,1); XG = XYZMatrix(2,1); XB = XYZMatrix(3,1);
    YR = XYZMatrix(1,2); YG = XYZMatrix(2,2); YB = XYZMatrix(3,2);
    ZR = XYZMatrix(1,3); ZG = XYZMatrix(2,3); ZB = XYZMatrix(3,3);
    Denominator = XR * YG * ZB + XG * YB * ZR + XB * YR * ZG - XR * YB * ZG - XG * YR * ZB - XB * YG * ZR;
    SngTemp(1, 1) = (YG * ZB - ZG * YB) / Denominator; %RX
    SngTemp(2, 1) = (ZG * XB - XG * ZB) / Denominator; %RY
    SngTemp(3, 1) = (XG * YB - YG * XB) / Denominator; %RZ
    SngTemp(1, 2) = (YB * ZR - ZB * YR) / Denominator; %GX
    SngTemp(2, 2) = (ZB * XR - XB * ZR) / Denominator; %GY
    SngTemp(3, 2) = (XB * YR - YB * XR) / Denominator; %GZ
    SngTemp(1, 3) = (YR * ZG - ZR * YG) / Denominator; %BX
    SngTemp(2, 3) = (ZR * XG - XR * ZG) / Denominator; %BY
    SngTemp(3, 3) = (XR * YG - YR * XG) / Denominator; %BZ
    RGB_Matrix = SngTemp;
end