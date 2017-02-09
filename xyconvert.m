function [dblNewx, dblNewy] = xyconvert(dblOldx,dblOldy,OldSpace,NewSpace)

cGUNS = 0;
cCIE31 = 1;
cCIE51 = 2;
cMB = 3;
cMyCartesian = 4;
cMyPolar = 5;
%cCIELab = 6;
XR = 0.619;
YR = 0.344;
XG = 0.281;
YG = 0.607;
XB = 0.15;
YB = 0.063;

if strcmp(OldSpace,'Guns')
    intOldSpace = 0;
elseif strcmp(OldSpace,'CIE31')
    intOldSpace = 1;
elseif strcmp(OldSpace,'CIE51') 
    intOldSpace = 2;
elseif strcmp(OldSpace,'MB')
    intOldSpace = 3;
elseif strcmp(OldSpace,'MWLCart')
    intOldSpace = 4;
elseif strcmp(OldSpace,'MWLPol')
    intOldSpace = 5;
else 
    disp('error using "intOldSpace"')
end

if strcmp(NewSpace,'Guns')
    intNewSpace = 0;
elseif strcmp(NewSpace,'CIE31')
    intNewSpace = 1;
elseif strcmp(NewSpace,'CIE51')
    intNewSpace = 2;
elseif strcmp(NewSpace,'MB')
    intNewSpace = 3;
elseif strcmp(NewSpace,'MWLCart')
    intNewSpace = 4;
elseif strcmp(NewSpace,'MWLPol')
    intNewSpace = 5;
else 
    disp('error using "intNewSpace"')
end

% convert gun %'s to '31 CIE
%0,>0
if intOldSpace == cGUNS && intNewSpace > cGUNS
    dblStep1 = (XG - XB) * (YR - YB) - (YG - YB) * (XR - XB);
    dblStep2 = (YR - YB) / dblStep1;
    dblStep3 = -(XR - XB) / dblStep1;
    dblStep4 = ((-XB * (YR - YB)) + (YB * (XR - XB))) / dblStep1;
    dblStep5 = (1 - ((XG - XB) * dblStep2)) / (XR - XB);
    dblStep6 = (-dblStep3 * (XG - XB)) / (XR - XB);
    dblStep7 = (-XB - (dblStep4 * (XG - XB))) / (XR - XB);
    dblStep8 = (-YG * dblStep2 * dblStep7 / dblStep5) + (YG * dblStep4);
    dblStep9 = dblOldy - (YG * dblStep2 / (YR * dblStep5)) * (dblOldx - (YR * dblStep6)) - (YG * dblStep3);
    
    dblNewy = dblStep8 / dblStep9;
    dblNewx = (dblOldx * dblNewy - YR * dblStep6 * dblNewy - YR * dblStep7) / (YR * dblStep5);
    dblNewz = abs(1 - (dblNewx + dblNewy));
    
    dblOldx = dblNewx;
    dblOldy = dblNewy;
end

%convert '31 CIE to '51 CIE
%<2,>=2
if intOldSpace < cCIE51 && intNewSpace >= cCIE51
    dblNewx = (1.0271 * dblOldx - 0.00008 * dblOldy - 0.00009) / (0.03845 * dblOldx + 0.01496 * dblOldy + 1);
    dblNewy = (0.00376 * dblOldx + 1.0072 * dblOldy + 0.00764) / (0.03845 * dblOldx + 0.01496 * dblOldy + 1);
    dblNewz = abs(1 - (dblNewx + dblNewy));
    
    dblOldx = dblNewx;
    dblOldy = dblNewy;
end

%convert '51 CIE to Macleod-Boynton
%<3,>=3
if intOldSpace < cMB && intNewSpace >= cMB
    dblStep1 = 0.15514 * dblOldx + 0.54312 * dblOldy - 0.03286 * (1 - dblOldx - dblOldy);
    dblStep2 = -0.15514 * dblOldx + 0.45684 * dblOldy + 0.03286 * (1 - dblOldx - dblOldy);
    dblStep3 = 0.01608 * (1 - dblOldx - dblOldy);
    dblNewx = dblStep1 / (dblStep1 + dblStep2);
    dblNewy = dblStep3 / (dblStep1 + dblStep2);
    dblNewz = 1 - (dblNewx + dblNewy);
    
    dblOldx = dblNewx;
    dblOldy = dblNewy;
end

%convert from Macleod-Boynton to MWL
%get x,y coordinates in MWL
%<4,>=4
if intOldSpace < cMyCartesian && intNewSpace >= cMyCartesian
    dblNewx = 2754 * (dblOldx - 0.6568);
    dblNewy = 4033 * (dblOldy - 0.01825);
    
    dblOldx = dblNewx;
    dblOldy = dblNewy;
end

%if MWL is polar, convert x,y to angle and contrast
%<=4,5
if intOldSpace <= cMyCartesian && intNewSpace == cMyPolar
    if dblOldx == 0
        dblNewx = pi / 2;
    end
    if dblOldx == 0 && dblOldy < 0
        dblNewx = -pi / 2;
    end
    if dblOldx > 0 
        dblNewx = atan(dblOldy / dblOldx);
    end
    if dblOldx < 0 
        dblNewx = atan(dblOldy/dblOldx) + pi;
    end
    dblNewx = dblNewx * 180 / pi;
    dblNewy = sqrt(dblOldx * dblOldx + dblOldy * dblOldy);
end

%convert from MWL space (polar) to Macleod-Boyton
%5,<=4
if intOldSpace == cMyPolar && intNewSpace <= cMyCartesian
    dblNewx = dblOldy * cos(dblOldx * pi / 180);
    dblNewy = dblOldy * sin(dblOldx * pi / 180);
    
    dblOldx = dblNewx;
    dblOldy = dblNewy;
end

%convert from MWL (x,y) to Macleod-Boynton
%>=4,<=3
if intOldSpace >= cMyCartesian && intNewSpace <= cMB
    dblNewx = (dblOldx / 2754) + 0.6568;
    dblNewy = (dblOldy / 4033) + 0.01825;
    
    dblOldx = dblNewx;
    dblOldy = dblNewy;
end

%convert from Macleod-Boynton to '51 CIE
%>=3,<3
if intOldSpace >= cMB && intNewSpace < cMB
    dblStep1 = 2.94481 * dblOldx - 3.50097 * (1 - dblOldx) + 13.17218 * dblOldy;
    dblStep2 = 2.18895 * (1 - dblOldx) + 0.33959 * dblStep1 - 4.47319 * dblOldy;
    dblStep3 = dblOldy / 0.01608;
    dblNewx = dblStep1 / (dblStep1 + dblStep2 + dblStep3);
    dblNewy = dblStep2 / (dblStep1 + dblStep2 + dblStep3);
    dblNewz = abs(1 - (dblNewx + dblNewy));
    
    dblOldx = dblNewx;
    dblOldy = dblNewy;
end

%convert from '51 CIE to '31 CIE
%>=2,<2
if intOldSpace >= cCIE51 && intNewSpace < cCIE51
    dblStep1 = (0.00376 - 0.03845 * dblOldy) / (1.0271 - 0.03845 * dblOldx);
    dblStep2 = (0.00009 + dblOldx) * dblStep1 + 0.00764 - dblOldy;
    dblStep3 = (0.03845 * dblOldy - 0.00376) / (1.0271 - 0.03845 * dblOldx);
    dblStep4 = (0.00008 + 0.01496 * dblOldx) * dblStep3 + 0.01496 * dblOldy - 1.0072;
    dblNewy = dblStep2 / dblStep4;
    dblNewx = (0.00008 * dblOldy + 0.00009 + (0.01496 * dblOldx * dblNewy) + dblOldx) / (1.0271 - 0.03845 * dblOldx);
    dblNewz = abs(1 - (dblNewx + dblNewy));
    
    dblOldx = dblNewx;
    dblOldy = dblNewy;
end

%convert '31 CIE to gun %'s
%>0,0
if intOldSpace > cGUNS && intNewSpace == cGUNS
    dblStep1 = (dblOldx - XB) * (YR - YB) - (dblOldy - YB) * (XR - XB);
    dblStep2 = (XG - XB) * (YR - YB) - (YG - YB) * (XR - XB);
    dblStep3 = dblStep1 / dblStep2;
    dblStep4 = ((dblOldx - XB) - dblStep3 * (XG - XB)) / (XR - XB);
    dblStep5 = 1 - dblStep3 - dblStep4;
    dblStep6 = dblStep4 * YR + dblStep3 * YG + dblStep5 * YB;
    dblNewx = dblStep4 * YR / dblStep6;
    dblNewy = dblStep3 * YG / dblStep6;
    dblNewz = 1 - (dblNewx + dblNewy);
    
    dblOldx = dblNewx;
    dblOldy = dblNewy;
end


        


