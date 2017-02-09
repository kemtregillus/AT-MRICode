%%% Convert Colors v1.81 (8 Nov 2013)
%
%[requestedCoor saturation] =
%ConvertColors(conversion,givenCoor[,colorInfo][,useSpectrum][,errorSaturation]);
%
% This program will replace all the individual files for color conversion.
%
% Acceptable spaces include XYZ, xyL, DKL, MWL, LMS, La*b*, Lu'v'
%
% Usage is as follows:
%
% All conversions start with the color space you're starting in, while they
% end with the space you want:
%
% Example: to go from xyL to XYZ, your first input argument will be
% 'xylxyz' or 'XYL-XYZ' (case not sensitive). Input should be a string.
%
% Next, supply the given coordinate, which should be a 3 value array:
% [15 15 25]
%
% Next, if you need or are using Lab or RGB, we need colorInfo, which you
% can get by loading your colorInfo.mat file.
% If you don't supply it, the default colorInfo.mat will be used 
% instead.
%
% The last two are optional, using the spectrum is nice if you want to
% avoid non-linearities in the guns, but it's dependent on color matching
% functions, so it may not be worth it and is much slower than using the
% RGB or XYZ matrix. Set to true to use the spectrum, defaults to false.
%
% errorSaturation will kill the program if set to true, otherwise it will
% only warn of gun saturation in the command window.
%
% This will always return the requested coordinate so long as it doesn't
% throw you an error due to saturation, but it will also provide you a
% boolean to inform you of saturation, which means you can now move freely
% through your space without saturating your monitor.
%
% Changelog:
%
%   1.81 -  Fixed a bug in DKL->xyL
%
%   1.8 -   Fixed a bug in XYL->LAB
%
%   1.7 -   Found a small bug in xyl to xyz, but it didn't break any old
%           experiments.
%   
%   1.6 -   Vectorized XYZ to RGB and vice versa operations, much more
%           appropriate math now for MATLAB. Also, depreciated
%           LoadMonitorData.
%
%   1.5 -   Added a prototype MCL (Mike Crognale Lab) which is currently
%           run off of the F7 standard illuminant (Wikipedia).
%
%   1.0 -   Wrote it.
%
% Chris Jones

function [requestedCoor, saturation] = ConvertColors(conversion,givenCoor,colorInfo,useSpectrum,errorSaturation)

conversion = lower(conversion);

saturation = false; %Initialized

%Error checking and defaults
if nargin < 2
    error('Not enough input arguments.');
end

if size(givenCoor,2) ~= 3
   error('Coordinate supplied not 3 columns wide'); 
end

if nargin < 3
    if strfind(conversion,'lab') > 0
        warning(['You need the colorInfo variable for Lab conversions.'...
            'Loading default CAL file. from LoadMonitorData.']);
        load('colorInfo.mat');
%         colorInfo = LoadMonitorData();
    elseif strfind(conversion,'rgb') > 0
        warning(['You need the colorInfo variable for RGB conversions.'...
            'Loading default CAL file. from LoadMonitorData.']);
        load('colorInfo.mat');
%         colorInfo = LoadMonitorData();
    end
end

if nargin < 4 %Default to not using spectrum information
   useSpectrum = false; 
end

if nargin < 5 %Let them run, but it'll still print out
   if useSpectrum ~= true && useSpectrum ~= false
      useSpectrum = false; %In case they skip this one 
      warning('Spectrum input invalid, will not use spectrum info.');
   end
   errorSaturation = false;
end

if nargin == 5
   if errorSaturation ~= true && errorSaturation ~= false
      errorSaturation = false; 
      warning('Error on saturation invalid input, will only warn or saturation issues.');
   end
end
%End of error checking

%The BIG switch statement.
switch conversion
    case {'dkllab', 'dkl-lab'}
        requestedCoor = Convert_DKL_to_Lab(givenCoor,colorInfo);
    case {'dkllms', 'dkl-lms'}
        requestedCoor = Convert_DKL_to_LMS(givenCoor);
    case {'dklluv', 'dkl-luv'}
        requestedCoor = Convert_DKL_to_Luv(givenCoor);
    case {'dklmcl', 'dkl-mcl'}
        requestedCoor = Convert_DKL_to_MCL(givenCoor);
    case {'dklmwl', 'dkl-mwl'}
        requestedCoor = Convert_DKL_to_MWL(givenCoor);
    case {'dklrgb', 'dkl-rgb'}
        [requestedCoor, saturation] = Convert_DKL_to_RGB(givenCoor,colorInfo,useSpectrum,errorSaturation);
    case {'dklxyl', 'dkl-xyl'}
        requestedCoor = Convert_DKL_to_xyL(givenCoor);
    case {'dklxyz', 'dkl-xyz'}
        requestedCoor = Convert_DKL_to_XYZ(givenCoor);
    case {'labdkl', 'lab-dkl'}
        requestedCoor = Convert_Lab_to_DKL(givenCoor,colorInfo);
    case {'lablms', 'lab-lms'}
        requestedCoor = Convert_Lab_to_LMS(givenCoor,colorInfo);
    case {'labluv', 'lab-luv'}
        requestedCoor = Convert_Lab_to_Luv(givenCoor,colorInfo);
    case {'labmcl', 'lab-mcl'}
        requestedCoor = Convert_Lab_to_MCL(givenCoor,colorInfo);
    case {'labmwl', 'lab-mwl'}
        requestedCoor = Convert_Lab_to_MWL(givenCoor,colorInfo);
    case {'labrgb','lab-rgb'}
        [requestedCoor, saturation] = Convert_Lab_to_RGB(givenCoor,colorInfo,useSpectrum,errorSaturation);
    case {'labxyl','lab-xyl'}
        requestedCoor = Convert_Lab_to_xyL(givenCoor,colorInfo);
    case {'labxyz','lab-xyz'}
        requestedCoor = Convert_Lab_to_XYZ(givenCoor,colorInfo);
    case {'lmsdkl','lms-dkl'}
        requestedCoor = Convert_LMS_to_DKL(givenCoor);
    case {'lmslab','lms-lab'}
        requestedCoor = Convert_LMS_to_Lab(givenCoor,colorInfo);
    case {'lmsluv','lms-luv'}
        requestedCoor = Convert_LMS_to_Luv(givenCoor);
    case {'lmsmcl','lms-mcl'}
        requestedCoor = Convert_LMS_to_MCL(givenCoor);
    case {'lmsmwl','lms-mwl'}
        requestedCoor = Convert_LMS_to_MWL(givenCoor);
    case {'lmsrgb','lms-rgb'}
        [requestedCoor, saturation] = Convert_LMS_to_RGB(givenCoor,colorInfo,useSpectrum,errorSaturation);
    case {'lmsxyl','lms-xyl'}
        requestedCoor = Convert_LMS_to_xyL(givenCoor);
    case {'lmsxyz','lms-xyz'}
        requestedCoor = Convert_LMS_to_XYZ(givenCoor);
    case {'luvdkl','luv-dkl'}
        requestedCoor = Convert_Luv_to_DKL(givenCoor);
    case {'luvlab','luv-lab'}
        requestedCoor = Convert_Luv_to_Lab(givenCoor,colorInfo);
    case {'luvlms','luv-lms'}
        requestedCoor = Convert_Luv_to_LMS(givenCoor);
    case {'luvmcl','luv-mcl'}
        requestedCoor = Convert_Luv_to_MCL(givenCoor);
    case {'luvmwl','luv-mwl'}
        requestedCoor = Convert_Luv_to_MWL(givenCoor);
    case {'luvrgb','luv-rgb'}
        [requestedCoor, saturation] = Convert_Luv_to_RGB(givenCoor,colorInfo,useSpectrum,errorSaturation);
    case {'luvxyl','luv-xyl'}
        requestedCoor = Convert_Luv_to_xyL(givenCoor);
    case {'luvxyz','luv-xyz'}
        requestedCoor = Convert_Luv_to_XYZ(givenCoor);
    
    case {'mcldkl','mcl-dkl'}
        requestedCoor = Convert_MCL_to_DKL(givenCoor);
    case {'mcllab','mcl-lab'}
        requestedCoor = Convert_MCL_to_Lab(givenCoor,colorInfo);
    case {'mcllms','mcl-lms'}
        requestedCoor = Convert_MCL_to_LMS(givenCoor);
    case {'mclluv','mcl-luv'}
        requestedCoor = Convert_MCL_to_Luv(givenCoor);
    case {'mclrgb','mcl-rgb'}
        [requestedCoor, saturation] = Convert_MCL_to_RGB(givenCoor,colorInfo,useSpectrum,errorSaturation);
    case {'mclxyl','mcl-xyl'}
        requestedCoor = Convert_MCL_to_xyL(givenCoor);
    case {'mclxyz','mcl-xyz'}
        requestedCoor = Convert_MCL_to_XYZ(givenCoor);
        
    case {'mwldkl','mwl-dkl'}
        requestedCoor = Convert_MWL_to_DKL(givenCoor);
    case {'mwllab','mwl-lab'}
        requestedCoor = Convert_MWL_to_Lab(givenCoor,colorInfo);
    case {'mwllms','mwl-lms'}
        requestedCoor = Convert_MWL_to_LMS(givenCoor);
    case {'mwlluv','mwl-luv'}
        requestedCoor = Convert_MWL_to_Luv(givenCoor);
    case {'mwlrgb','mwl-rgb'}
        [requestedCoor, saturation] = Convert_MWL_to_RGB(givenCoor,colorInfo,useSpectrum,errorSaturation);
    case {'mwlxyl','mwl-xyl'}
        requestedCoor = Convert_MWL_to_xyL(givenCoor);
    case {'mwlxyz','mwl-xyz'}
        requestedCoor = Convert_MWL_to_XYZ(givenCoor);
   
    case {'rgbdkl','rgb-dkl'}
        [requestedCoor, saturation] = Convert_RGB_to_DKL(givenCoor,colorInfo,useSpectrum,errorSaturation);
    case {'rgblab','rgb-lab'}
        [requestedCoor, saturation] = Convert_RGB_to_Lab(givenCoor,colorInfo,useSpectrum,errorSaturation);
    case {'rgblms','rgb-lms'}
        [requestedCoor, saturation] = Convert_RGB_to_LMS(givenCoor,colorInfo,useSpectrum,errorSaturation);
    case {'rgbluv','rgb-luv'}
        [requestedCoor, saturation] = Convert_RGB_to_Luv(givenCoor,colorInfo,useSpectrum,errorSaturation);
    case {'rgbmcl','rgb-mcl'}
        [requestedCoor, saturation] = Convert_RGB_to_MCL(givenCoor,colorInfo,useSpectrum,errorSaturation);
    case {'rgbmwl','rgb-mwl'}
        [requestedCoor, saturation] = Convert_RGB_to_MWL(givenCoor,colorInfo,useSpectrum,errorSaturation);
    case {'rgbxyl','rgb-xyl'}
        [requestedCoor, saturation] = Convert_RGB_to_xyL(givenCoor,colorInfo,useSpectrum,errorSaturation);
    case {'rgbxyz','rgb-xyz'}
        [requestedCoor, saturation] = Convert_RGB_to_XYZ(givenCoor,colorInfo,useSpectrum,errorSaturation);
    case {'xyldkl','xyl-dkl'}
        requestedCoor = Convert_xyL_to_DKL(givenCoor);
    case {'xyllab','xyl-lab'}
        requestedCoor = Convert_xyL_to_Lab(givenCoor,colorInfo);
    case {'xyllms','xyl-lms'}
        requestedCoor = Convert_xyL_to_LMS(givenCoor);
    case {'xylluv','xyl-luv'}
        requestedCoor = Convert_xyL_to_Luv(givenCoor);
    case {'xylmcl','xyl-mcl'}
        requestedCoor = Convert_xyL_to_MCL(givenCoor);
    case {'xylmwl','xyl-mwl'}
        requestedCoor = Convert_xyL_to_MWL(givenCoor);
    case {'xylrgb','xyl-rgb'}
        [requestedCoor, saturation] = Convert_xyL_to_RGB(givenCoor,colorInfo,useSpectrum,errorSaturation);
    case {'xylxyz','xyl-xyz'}
        requestedCoor = Convert_xyL_to_XYZ(givenCoor);
    case {'xyzdkl','xyz-dkl'}
        requestedCoor = Convert_XYZ_to_DKL(givenCoor);
    case {'xyzlab','xyz-lab'}
        requestedCoor = Convert_XYZ_to_Lab(givenCoor,colorInfo);
    case {'xyzlms','xyz-lms'}
        requestedCoor = Convert_XYZ_to_LMS(givenCoor);
    case {'xyzluv','xyz-luv'}
        requestedCoor = Convert_XYZ_to_Luv(givenCoor);
    case {'xyzmcl','xyz-mcl'}
        requestedCoor = Convert_XYZ_to_MCL(givenCoor);
    case {'xyzmwl','xyz-mwl'}
        requestedCoor = Convert_XYZ_to_MWL(givenCoor);
    case {'xyzrgb','xyz-rgb'}
        [requestedCoor, saturation] = Convert_XYZ_to_RGB(givenCoor,colorInfo,useSpectrum,errorSaturation);
    case {'xyzxyl','xyz-xyl'}
        requestedCoor = Convert_XYZ_to_xyL(givenCoor);
    
    %To go from one lab space to another
    case {'mwlmcl','mwl-mcl'}
        requestedCoor = Convert_MWL_to_MCL(givenCoor);
    case {'mclmwl','mcl-mwl'}
        requestedCoor = Convert_MCL_to_MWL(givenCoor);
    otherwise
        error('No correct conversion chosen!')
end

end

function DKL_to_Lab = Convert_DKL_to_Lab(DKL,colorInfo)
DKL_to_Lab = Convert_LMS_to_Lab(Convert_DKL_to_LMS(DKL),colorInfo);
end

function [DKL_to_RGB, saturation] = Convert_DKL_to_RGB(DKL, colorInfo, useSpectrum, errorSaturation)
SngTemp = Convert_DKL_to_xyL(DKL);
[DKL_to_RGB, saturation] = Convert_xyL_to_RGB(SngTemp, colorInfo, useSpectrum,errorSaturation);
end

function DKL_to_LMS = Convert_DKL_to_LMS(DKL)
SngLMSRatio(3) = zeros;
SngLMS(3) = zeros;
SngLMSRatio(1) = DKL(1); %L/(L+M)
SngLMSRatio(2) = 1 - DKL(1); %1 - DKL(0) 'M / (L + M) = 1 - (L / (L + M))
SngLMSRatio(3) = DKL(2);%S / (L + M)
SngLMS(1) = SngLMSRatio(1) * DKL(3); %L
SngLMS(2) = SngLMSRatio(2) * DKL(3); %M
SngLMS(3) = SngLMSRatio(3) * DKL(3); %S
DKL_to_LMS = SngLMS;
end

function DKL_to_Luv = Convert_DKL_to_Luv(DKL)
DKL_to_Luv = Convert_LMS_to_Luv(Convert_DKL_to_LMS(DKL));
end

function DKL_to_MCL = Convert_DKL_to_MCL(DKL)%Custom to our lab (CRJ 4 April 2013)
%Some options include illuminant F7 (D65 simulator, K=6500) x=0.31292, y=0.32933
% or C (says it's obsolete in Wikipedia though, K=6774, x=0.31006, y=0.31616
SngTemp(3) = zeros;
SngTemp(1) = 1955 * (DKL(1) - 0.6548); %F7 
SngTemp(2) = 5533 * (DKL(2) - 0.0175); %F7
SngTemp(3) = DKL(3);
DKL_to_MCL = SngTemp;
end

function DKL_to_MWL = Convert_DKL_to_MWL(DKL)%Taken from Webster (contained in multiple pubs)
SngTemp(3) = zeros;
SngTemp(1) = 1955 * (DKL(1) - 0.6568);
SngTemp(2) = 5533 * (DKL(2) - 0.01825);
SngTemp(3) = DKL(3);
DKL_to_MWL = SngTemp;
end

function DKL_to_xyL = Convert_DKL_to_xyL(DKL) %Coefficients taken from Human Color Vision Appendix Equation A.4.3
SngXYZ(3) = zeros; SngTemp(3)=zeros;
SngXYZ(1) = 2.9448 * DKL(1) - 3.5001 * (1 - DKL(1)) + 13.1745 * DKL(2);
SngXYZ(2) = 1 * DKL(1) + 1 * (1 - DKL(1)) + 0 * DKL(2);
SngXYZ(3) = 0 * DKL(1) + 0 * (1 - DKL(1)) + 62.1891 * DKL(2);
SngTemp(1) = SngXYZ(1) / (SngXYZ(1) + SngXYZ(2) + SngXYZ(3));
SngTemp(2) = SngXYZ(2) / (SngXYZ(1) + SngXYZ(2) + SngXYZ(3));
SngTemp(3) = DKL(3);
DKL_to_xyL = SngTemp;
end

function DKL_to_XYZ = Convert_DKL_to_XYZ(DKL)
SngTemp = Convert_DKL_to_xyL(DKL);
DKL_to_XYZ = Convert_xyL_to_XYZ(SngTemp);
end

function Lab_to_DKL = Convert_Lab_to_DKL(Lab,colorInfo)
Lab_to_DKL = Convert_XYZ_to_DKL(Convert_Lab_to_XYZ(Lab,colorInfo));
end

function Lab_to_LMS = Convert_Lab_to_LMS(Lab,colorInfo)
Lab_to_LMS = Convert_XYZ_to_LMS(Convert_Lab_to_XYZ(Lab,colorInfo));
end

function Lab_to_Luv = Convert_Lab_to_Luv(Lab,colorInfo)
Lab_to_Luv = Convert_XYZ_to_Luv(Convert_Lab_to_XYZ(Lab,colorInfo));
end

function Lab_to_MCL = Convert_Lab_to_MCL(Lab,colorInfo)
Lab_to_MCL = Convert_XYZ_to_MCL(Convert_Lab_to_XYZ(Lab,colorInfo));
end

function Lab_to_MWL = Convert_Lab_to_MWL(Lab,colorInfo)
Lab_to_MWL = Convert_XYZ_to_MWL(Convert_Lab_to_XYZ(Lab,colorInfo));
end

function [Lab_to_RGB, saturation] = Convert_Lab_to_RGB(Lab,colorInfo,useSpectrum,errorSaturation)
[Lab_to_RGB, saturation] = Convert_XYZ_to_RGB(Convert_Lab_to_XYZ(Lab,colorInfo), colorInfo, useSpectrum,errorSaturation);
end

function Lab_to_xyL = Convert_Lab_to_xyL(Lab,colorInfo)
Lab_to_xyL = Convert_XYZ_to_xyL(Convert_Lab_to_XYZ(Lab,colorInfo));
end

function Lab_to_XYZ = Convert_Lab_to_XYZ(Lab,colorInfo)
SngXYZ(3) = zeros;
SngXYZ(1) = colorInfo.ReferenceWhite(1) * Lab_Function_Inverse((1 / 116) * (Lab(1) + 16) + (1 / 500) * Lab(2)); % X
SngXYZ(2) = colorInfo.ReferenceWhite(2) * Lab_Function_Inverse((1 / 116) * (Lab(1) + 16)); % Y
SngXYZ(3) = colorInfo.ReferenceWhite(3) * Lab_Function_Inverse((1 / 116) * (Lab(1) + 16) - (1 / 200) * Lab(3)); % Z
Lab_to_XYZ = SngXYZ;
end

function LMS_to_DKL = Convert_LMS_to_DKL(LMS)
SngDKL(3) = zeros;
SngDKL(1) = LMS(1) / (LMS(1) + LMS(2)); %L/(L+M)
SngDKL(2) = LMS(3) / (LMS(1) + LMS(2)); %S/(L+M)
SngDKL(3) = LMS(1) + LMS(2);%L+M = Y
LMS_to_DKL = SngDKL;
end

function LMS_to_Lab = Convert_LMS_to_Lab(LMS,colorInfo)
LMS_to_Lab = Convert_XYZ_to_Lab(Convert_LMS_to_XYZ(LMS),colorInfo);
end

function LMS_to_Luv = Convert_LMS_to_Luv(LMS)
LMS_to_Luv = Convert_XYZ_to_Luv(Convert_LMS_to_XYZ(LMS));
end

function LMS_to_MCL = Convert_LMS_to_MCL(LMS)
LMS_to_MCL = Convert_DKL_to_MCL(Convert_LMS_to_DKL(LMS));
end

function LMS_to_MWL = Convert_LMS_to_MWL(LMS)
LMS_to_MWL = Convert_DKL_to_MWL(Convert_LMS_to_DKL(LMS));
end

function [LMS_to_RGB, saturation] = Convert_LMS_to_RGB(LMS,colorInfo,useSpectrum,errorSaturation)
[LMS_to_RGB, saturation] = Convert_XYZ_to_RGB(Convert_LMS_to_XYZ(LMS), colorInfo, useSpectrum,errorSaturation);
end

function LMS_to_xyL = Convert_LMS_to_xyL(LMS)
LMS_to_xyL = Convert_XYZ_to_xyL(Convert_LMS_to_XYZ(LMS));
end

function LMS_to_XYZ = Convert_LMS_to_XYZ(LMS)
SngXYZ(3) = zeros;
SngXYZ(1) = 2.9448 * LMS(1) - 3.5001 * LMS(2) + 13.1745 * LMS(3); %X - Reference incorrectly uses 35001 instead of 3.5001
SngXYZ(2) = 1 * LMS(1) + 1 * LMS(2) + 0 * LMS(3); % Y = L + M
SngXYZ(3) = 0 * LMS(1) + 0 * LMS(2) + 62.1891 * LMS(3); %Z
LMS_to_XYZ = SngXYZ;
end

function Luv_to_DKL = Convert_Luv_to_DKL(Luv)
Luv_to_DKL = Convert_xyL_to_DKL(Convert_Luv_to_xyL(Luv));
end

function Luv_to_Lab = Convert_Luv_to_Lab(Luv,colorInfo)
Luv_to_Lab = Convert_xyL_to_Lab(Convert_Luv_to_xyL(Luv),colorInfo);
end

function Luv_to_LMS = Convert_Luv_to_LMS(Luv)
Luv_to_LMS = Convert_xyL_to_LMS(Convert_Luv_to_xyL(Luv));
end

function Luv_to_MCL = Convert_Luv_to_MCL(Luv)
Luv_to_MCL = Convert_xyL_to_MCL(Convert_Luv_to_xyL(Luv));
end

function Luv_to_MWL = Convert_Luv_to_MWL(Luv)
Luv_to_MWL = Convert_xyL_to_MWL(Convert_Luv_to_xyL(Luv));
end

function [Luv_to_RGB, saturation] = Convert_Luv_to_RGB(Luv,colorInfo,useSpectrum,errorSaturation)
[Luv_to_RGB, saturation] = Convert_xyL_to_RGB(Convert_Luv_to_xyL(Luv), colorInfo, useSpectrum,errorSaturation);
end

function Luv_to_xyL = Convert_Luv_to_xyL(Luv)
SngxyL(3) = zeros;
SngxyL(1) = (9 * Luv(2)) / (6 * Luv(2) - 16 * Luv(3) + 12); % x
SngxyL(2) = (4 * Luv(3)) / (6 * Luv(2) - 16 * Luv(3) + 12); % y
SngxyL(3) = Luv(1); % L
Luv_to_xyL = SngxyL;
end

function Luv_to_XYZ = Convert_Luv_to_XYZ(Luv)
Luv_to_XYZ = Convert_xyL_to_XYZ(Convert_Luv_to_xyL(Luv));
end

function MCL_to_DKL = Convert_MCL_to_DKL(MCL)%Custom to our lab (CRJ 4 April 2013)
%Some options include illuminant F7 (D65 simulator, K=6500) x=0.31292, y=0.32933
% or C (says it's obsolete in Wikipedia though, K=6774, x=0.31006, y=0.31616
SngTemp(3) = zeros;
SngTemp(1) = (MCL(1) / 1955) + 0.6548;
SngTemp(2) = (MCL(2) / 5533) + 0.0175;
SngTemp(3) = MCL(3);
MCL_to_DKL = SngTemp;
end

function MWL_to_DKL = Convert_MWL_to_DKL(MWL)
SngTemp(3) = zeros;
SngTemp(1) = (MWL(1) / 1955) + 0.6568;
SngTemp(2) = (MWL(2) / 5533) + 0.01825;
SngTemp(3) = MWL(3);
MWL_to_DKL = SngTemp;
end

function MCL_to_Lab = Convert_MCL_to_Lab(MCL,colorInfo)
MCL_to_Lab = Convert_DKL_to_Lab(Convert_MCL_to_DKL(MCL),colorInfo);
end

function MWL_to_Lab = Convert_MWL_to_Lab(MWL,colorInfo)
MWL_to_Lab = Convert_DKL_to_Lab(Convert_MWL_to_DKL(MWL),colorInfo);
end

function MCL_to_LMS = Convert_MCL_to_LMS(MCL)
MCL_to_LMS = Convert_DKL_to_LMS(Convert_MCL_to_DKL(MCL));
end

function MWL_to_LMS = Convert_MWL_to_LMS(MWL)
MWL_to_LMS = Convert_DKL_to_LMS(Convert_MWL_to_DKL(MWL));
end

function MCL_to_Luv = Convert_MCL_to_Luv(MCL)
MCL_to_Luv = Convert_DKL_to_Luv(Convert_MCL_to_DKL(MCL));
end

function MWL_to_Luv = Convert_MWL_to_Luv(MWL)
MWL_to_Luv = Convert_DKL_to_Luv(Convert_MWL_to_DKL(MWL));
end

function [MCL_to_RGB, saturation] = Convert_MCL_to_RGB(MCL, colorInfo, useSpectrum,errorSaturation)
SngTemp = Convert_MCL_to_DKL(MCL);
[MCL_to_RGB, saturation] = Convert_DKL_to_RGB(SngTemp, colorInfo, useSpectrum,errorSaturation);
end

function [MWL_to_RGB, saturation] = Convert_MWL_to_RGB(MWL, colorInfo, useSpectrum,errorSaturation)
SngTemp = Convert_MWL_to_DKL(MWL);
[MWL_to_RGB, saturation] = Convert_DKL_to_RGB(SngTemp, colorInfo, useSpectrum,errorSaturation);
end

function MCL_to_xyL = Convert_MCL_to_xyL(MCL)
SngTemp = Convert_MCL_to_DKL(MCL);
MCL_to_xyL = Convert_DKL_to_xyL(SngTemp);
end

function MWL_to_xyL = Convert_MWL_to_xyL(MWL)
SngTemp = Convert_MWL_to_DKL(MWL);
MWL_to_xyL = Convert_DKL_to_xyL(SngTemp);
end

function MCL_to_XYZ = Convert_MCL_to_XYZ(MCL)
SngTemp = Convert_MCL_to_DKL(MCL);
MCL_to_XYZ = Convert_DKL_to_XYZ(SngTemp);
end

function MWL_to_XYZ = Convert_MWL_to_XYZ(MWL)
SngTemp = Convert_MWL_to_DKL(MWL);
MWL_to_XYZ = Convert_DKL_to_XYZ(SngTemp);
end

function [RGB_to_DKL, saturation] = Convert_RGB_to_DKL(RGB,colorInfo,useSpectrum,errorSaturation)
[SngTemp, saturation] = Convert_RGB_to_XYZ(RGB, colorInfo, useSpectrum,errorSaturation);
RGB_to_DKL = Convert_XYZ_to_DKL(SngTemp);
end

function [RGB_to_Lab, saturation] = Convert_RGB_to_Lab(RGB,colorInfo,useSpectrum,errorSaturation)
[SngTemp, saturation] = Convert_RGB_to_XYZ(RGB, colorInfo, useSpectrum,errorSaturation);
RGB_to_Lab = Convert_XYZ_to_Lab(SngTemp);
end

function [RGB_to_LMS, saturation] = Convert_RGB_to_LMS(RGB,colorInfo,useSpectrum,errorSaturation)
[SngTemp, saturation] = Convert_RGB_to_XYZ(RGB, colorInfo, useSpectrum,errorSaturation);
RGB_to_LMS = Convert_XYZ_to_LMS(SngTemp);
end

function [RGB_to_Luv, saturation] = Convert_RGB_to_Luv(RGB, colorInfo, useSpectrum,errorSaturation)
[SngTemp, saturation] = Convert_RGB_to_XYZ(RGB, colorInfo, useSpectrum,errorSaturation);
RGB_to_Luv = Convert_XYZ_to_Luv(SngTemp);
end

function [RGB_to_MCL, saturation] = Convert_RGB_to_MCL(RGB, colorInfo, useSpectrum,errorSaturation)
[SngTemp, saturation] = Convert_RGB_to_XYZ(RGB, colorInfo, useSpectrum,errorSaturation);
RGB_to_MCL = Convert_XYZ_to_MCL(SngTemp);
end

function [RGB_to_MWL, saturation] = Convert_RGB_to_MWL(RGB, colorInfo, useSpectrum,errorSaturation)
[SngTemp, saturation] = Convert_RGB_to_XYZ(RGB, colorInfo, useSpectrum,errorSaturation);
RGB_to_MWL = Convert_XYZ_to_MWL(SngTemp);
end

function [RGB_to_xyL, saturation] = Convert_RGB_to_xyL(RGB,colorInfo,useSpectrum,errorSaturation)
[SngTemp, saturation] = Convert_RGB_to_XYZ(RGB,colorInfo,useSpectrum,errorSaturation);
RGB_to_xyL = Convert_XYZ_to_xyL(SngTemp);
end

function [RGB_to_XYZ, saturation] = Convert_RGB_to_XYZ(RGB,colorInfo,useSpectrum,errorSaturation)
% This function will need to know the colorInfo struct, but should NOT need
% to change it.
%

saturation = false;

%%% Error Checking
if RGB(1) < 0
    RGB(1) = 0;
    disp('Warning: Red value cannot be less than zero.');
    saturation = true;
end
if RGB(1) > 1
    RGB(1) = 1;
    disp('Warning: Red value cannot be greater than one.');
    saturation = true;
end
if RGB(2) < 0
    RGB(2) = 0;
    disp('Warning: Green value cannot be less than zero.');
    saturation = true;
end
if RGB(2) > 1
    RGB(2) = 1;
    disp('Warning: Green value cannot be greater than one.');
    saturation = true;
end
if RGB(3) < 0
    RGB(3) = 0;
    disp('Warning: Blue value cannot be less than zero.');
    saturation = true;
end
if RGB(3) > 1
    RGB(3) = 1;
    disp('Warning: Blue value cannot be greater than one.');
    saturation = true;
end

if errorSaturation == true
    error('RGB value either below 0 or above 1, see warning above')
end

SngTemp(3) = zeros;

if useSpectrum == false %Use XYZ Matrix calculation
    %Matrix multiplication, multiply RGB coordinates to XYZMatrix
    %RGB_to_XYZ = RGB * colorInfo.XYZMatrix;
    
    SngTemp = RGB * colorInfo.XYZMatrix;
    %The below code is the non-vectorized version, useful when you're not
    %working in MATLAB.
    
%     if colorInfo.XYZMatrix ~= zeros
%         for IntRGB=1:3
%             for IntXYZ = 1:3
%                 SngTemp(IntXYZ) = SngTemp(IntXYZ) + colorInfo.XYZMatrix(IntRGB, IntXYZ) * RGB(IntRGB);
%             end
%         end
%     end
    
else
    % Use measured spectra, depreciated and too much trouble for the little
    % gains made.
    
    if isfield(colorInfo,'Intensity') && isfield(colorInfo,'ColorMatchingFunctions')
        SngTempSpectrum= Get_Spectrum_from_RGB(RGB,colorInfo);
        for IntXYZ = 1:3
            for IntWavelength = 1:numel(SngTempSpectrum)
                SngTemp(IntXYZ) = SngTemp(IntXYZ) + colorInfo.ColorMatchingFunctions(IntWavelength, IntXYZ) * ...
                    SngTempSpectrum(IntWavelength) * 2732;
            end
        end
    end
end

RGB_to_XYZ = SngTemp;

end

function xyL_to_DKL = Convert_xyL_to_DKL(xyL) %Coefficients taken from Human Color Vision Appendix Equation A.3.14
SngLMS(3)= zeros; SngTemp(3)=zeros;
SngLMS(1) = 0.15516 * xyL(1) + 0.54308 * xyL(2) - 0.03287 * (1 - xyL(1) - xyL(2));
SngLMS(2) = -0.15516 * xyL(1) + 0.45692 * xyL(2) + 0.03287 * (1 - xyL(1) - xyL(2));
SngLMS(3) = 0 * xyL(1) + 0 * xyL(2) + 0.01608 * (1 - xyL(1) - xyL(2));
SngTemp(1) = SngLMS(1) / (SngLMS(1) + SngLMS(2));
SngTemp(2) = SngLMS(3) / (SngLMS(1) + SngLMS(2));
SngTemp(3) = xyL(3);
xyL_to_DKL = SngTemp;
end

function xyL_to_Lab = Convert_xyL_to_Lab(xyL,colorInfo)
xyL_to_Lab = Convert_XYZ_to_Lab(Convert_xyL_to_XYZ(xyL),colorInfo);
end

function xyL_to_LMS = Convert_xyL_to_LMS(xyL)
xyL_to_LMS = Convert_XYZ_to_LMS(Convert_xyL_to_XYZ(xyL));
end

function xyL_to_Luv = Convert_xyL_to_Luv(xyL)
xyL_to_Luv = Convert_XYZ_to_Luv(Convert_xyL_to_XYZ(xyL));
end

function xyL_to_MCL = Convert_xyL_to_MCL(xyL)
SngTemp = Convert_xyL_to_DKL(xyL);
xyL_to_MCL = Convert_DKL_to_MCL(SngTemp);
end

function xyL_to_MWL = Convert_xyL_to_MWL(xyL)
SngTemp = Convert_xyL_to_DKL(xyL);
xyL_to_MWL = Convert_DKL_to_MWL(SngTemp);
end

function [xyL_to_RGB, saturation] = Convert_xyL_to_RGB(xyL, colorInfo, useSpectrum,errorSaturation)
SngTemp = Convert_xyL_to_XYZ(xyL);
[xyL_to_RGB, saturation] = Convert_XYZ_to_RGB(SngTemp, colorInfo, useSpectrum,errorSaturation);
end

function xyL_to_XYZ = Convert_xyL_to_XYZ(xyL)
SngTemp(3)=zeros;
SngTemp(1) = xyL(1) * (xyL(3) / xyL(2));
SngTemp(2) = xyL(2) * (xyL(3) / xyL(2)); %'= xyL(2)
SngTemp(3) = (1 - xyL(1) - xyL(2)) * (xyL(3) / xyL(2));
xyL_to_XYZ = SngTemp;
end

function XYZ_to_DKL = Convert_XYZ_to_DKL(XYZ)
SngTemp=Convert_XYZ_to_xyL(XYZ);
XYZ_to_DKL = Convert_xyL_to_DKL(SngTemp);
end

function XYZ_to_Lab = Convert_XYZ_to_Lab(XYZ,colorInfo)
SngLab(3) = zeros;
SngLab(1) = 116 * Lab_Function(XYZ(2) / colorInfo.ReferenceWhite(2)) - 16; % L*
SngLab(2) = 500 * (Lab_Function(XYZ(1) / colorInfo.ReferenceWhite(1)) - Lab_Function(XYZ(2) / colorInfo.ReferenceWhite(2))); % a*
SngLab(3) = 200 * (Lab_Function(XYZ(2) / colorInfo.ReferenceWhite(2)) - Lab_Function(XYZ(3) / colorInfo.ReferenceWhite(3))); % b*
XYZ_to_Lab = SngLab;
end

function XYZ_to_LMS = Convert_XYZ_to_LMS(XYZ)
SngLMS(3) = zeros;
SngLMS(1) = 0.15516 * XYZ(1) + 0.54308 * XYZ(2) - 0.03287 * XYZ(3); % L
SngLMS(2) = -0.15516 * XYZ(1) + 0.45692 * XYZ(2) + 0.03287 * XYZ(3); % M
SngLMS(3) = 0 * XYZ(1) + 0 * XYZ(2) + 0.01608 * XYZ(3); % S
XYZ_to_LMS = SngLMS; %Luminance information infused into LMS
end

function XYZ_to_Luv = Convert_XYZ_to_Luv(XYZ)
    SngLuv(3) = zeros;
    SngLuv(1) = XYZ(2); %L = Y
    SngLuv(2) = (4 * XYZ(1))/(XYZ(1) + 15 * XYZ(2) + 3 * XYZ(3)); %u'
    SngLuv(3) = (9 * XYZ(2))/(XYZ(1) + 15 * XYZ(2) + 3 * XYZ(3)); %v'
    XYZ_to_Luv = SngLuv;
end

function XYZ_to_MWL = Convert_XYZ_to_MWL(XYZ)
    SngTemp=Convert_XYZ_to_xyL(XYZ);
    XYZ_to_MWL = Convert_xyL_to_MWL(SngTemp);
end

function XYZ_to_MCL = Convert_XYZ_to_MCL(XYZ)
    SngTemp=Convert_XYZ_to_xyL(XYZ);
    XYZ_to_MCL = Convert_xyL_to_MCL(SngTemp);
end

function MWL_to_MCL = Convert_MWL_to_MCL(MWL)
    %first, convert MWL to DKL, then DKL to MCL
    MWL_to_MCL = Convert_DKL_to_MCL(Convert_MWL_to_DKL(MWL));
end

function MCL_to_MWL = Convert_MCL_to_MWL(MCL)
    MCL_to_MWL = Convert_DKL_to_MWL(Convert_MCL_to_DKL(MCL));
end

function [XYZ_to_RGB, saturation] = Convert_XYZ_to_RGB(XYZ, colorInfo, useSpectrum,errorSaturation)

SngTemp(3)=zeros;
SngEstimate(3)=zeros;
SngError(3)=zeros;
saturation = false;

if colorInfo.RGBMatrix ~= zeros
    if useSpectrum == false  %Use RGB Matrix Calculation
        %Matrix multiplication, multiply XYZ by the RGB Matrix
        % XYZ_to_RGB = XYZ * colorInfo.RGBMatrix; %Must be in this order.
        
        SngTemp = XYZ * colorInfo.RGBMatrix;
%         for IntXYZ = 1:3
%             for IntRGB = 1:3
%                 SngTemp(IntRGB) = SngTemp(IntRGB) + colorInfo.RGBMatrix(IntXYZ, IntRGB)* XYZ(IntXYZ);
%             end
%         end
    else
        %Use Measured Spectra, not using spectrum much anymore, it's too
        %much work with not a big improvement. It also requires color
        %matching functions and at this stage, it's estimating.
        for IntXYZ = 1:3
            for IntRGB = 1:3
                
                SngEstimate(IntRGB) = SngEstimate(IntRGB)+ colorInfo.RGBMatrix(IntXYZ, IntRGB) * XYZ(IntXYZ);
            end
        end
        
        SngMeasure = Convert_RGB_to_XYZ(SngEstimate, colorInfo, useSpectrum);
        
        for IntXYZ = 1:3
            SngError(IntXYZ) = XYZ(IntXYZ) - SngMeasure(IntXYZ);
            for IntRGB=1:3
                SngTemp(IntRGB) = SngTemp(IntRGB) + colorInfo.RGBMatrix(IntXYZ, IntRGB) * (XYZ(IntXYZ) + SngError(IntXYZ));
            end
        end
    end
end

%%% Error Checking
if SngTemp(1) < 0
    SngTemp(1) = 0;
    disp('Warning: Red value cannot be less than zero.');
    saturation = true;
end
if SngTemp(1) > 1
    SngTemp(1) = 1;
    disp('Warning: Red value cannot be greater than one.');
    saturation = true;
end
if SngTemp(2) < 0
    SngTemp(2) = 0;
    disp('Warning: Green value cannot be less than zero.');
    saturation = true;
end
if SngTemp(2) > 1
    SngTemp(2) = 1;
    disp('Warning: Green value cannot be greater than one.');
    saturation = true;
end
if SngTemp(3) < 0
    SngTemp(3) = 0;
    disp('Warning: Blue value cannot be less than zero.');
    saturation = true;
end
if SngTemp(3) > 1
    SngTemp(3) = 1;
    disp('Warning: Blue value cannot be greater than one.');
    saturation = true;
end

if errorSaturation == true
   error('Color requested give an RGB value either below zero or above one, see above')
end

XYZ_to_RGB = SngTemp;
end

function XYZ_to_xyL = Convert_XYZ_to_xyL(XYZ)
SngTemp(3)=zeros;
SngTemp(1)=XYZ(1)/sum(XYZ);
SngTemp(2) = XYZ(2) / sum(XYZ);
SngTemp(3) = XYZ(2);
XYZ_to_xyL = SngTemp;
end

function LabFunction = Lab_Function(SngDatum) %For Conversion to Lab
if SngDatum > (6 / 29) ^ 3
    LabFunction = SngDatum ^ (1 / 3);
else
    LabFunction = (1 / 3) * ((29 / 6) ^ 2) * SngDatum + (4 / 29);
end
end

function LabFunctionInverse = Lab_Function_Inverse(SngDatum)
if SngDatum > 6 / 29
    LabFunctionInverse = SngDatum ^ 3;
else
    LabFunctionInverse = 3 * ((6 / 29) ^ 2) * (SngDatum - 4 / 29);
end
end