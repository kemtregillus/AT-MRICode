%Color Conversion Toolbox
%   
%Version 3.0        18 February 2013
%   
%   This toolbox is designed to convert between different color spaces,
%   particularly between RGB, XYZ, xyL, DKL, MWL, LMS, L*a*b* and Lu'v' 
%   color spaces. This code also contains other functions: Load_Monitor_Data 
%   and Load_Color_Matching_Functions for example, which can be loaded 
%   before running any other color conversions.
%
%   This code is primarily a translation from Visual Basic to MATLAB, and
%   therefore I take no authorship of this code, only the code 
%   translations. True credit belongs to Mike Webster and Kyle McDermott.
%
%   - Chris Jones
%
%Changelog:
%
%   3.0 -   Compiled all color conversions into one file, ConvertColors.
%           With this new ConvertColors, I've also added a second return
%           variable called saturation, which is a boolean to tell the
%           coder that the guns have saturated under those conditions,
%           meaning we can now use code only to move around any color
%           space, and we can know when we saturate.
%
%           A structural user update.  We don't need to run LoadMonitorData
%           every time, so let's use load('ColorInfo.mat') like we do for
%           gamma correction.  It's just simpler and will encourage us to
%           all use the same ColorInfo variable.
%           
%           I've re-added error on saturation for RGB conversions, but will
%           default to false if not supplied. It will always warn of a
%           saturation issue.  Also, ConvertColors will load the default
%           CAL file if no ColorInfo variable is supplied, so ConvertColors
%           only requires the initial color space and it's coordinates. The
%           same applies for using the gun spectrum info, we're now
%           defaulting to false just because the RGB/XYZ matricies are
%           plenty enough to get very close colors. I expect using the
%           spectrum will be depreciated soon unless I can vectorize the
%           math operations so it'll be faster.
%           
%           Also, I've removed all underscores from the filenames as well,
%           they're just too tedious to type all the time.
%
%           Every use of 'false'/'true' as a string has been replaced with
%           it's boolean equivalent.
%
%           LoadMonitorData and LoadColorMatchingFunctions will be
%           depreciated soon to simplify the toolbox, particularly the use
%           of gun spectrum information and compiling what's needed into a
%           single function that creates a gamma table and creates the
%           needed RGB/XYZ matricies for us.
%
%   2.6 -   Fixed some bugs with L*a*b* as it needs the ColorInfo struct
%           as well; now all functions that use it will require ColorInfo
%           as the second input variable.
%
%   2.5 -   Added more color spaces from a new version of Kyle's code,
%           particularly CIE Lu'v', L*a*b* and LMS cone activation.
%
%   2.0 -   Added a couple new functions such as GunLinearization and
%           Get_Monitor_Data, which are further described below.  Also, I
%           corrected a mistake on my part about color matching functions.
%           As of now, requested colors are within 1% of their actual
%           display on our gun independent, linearized CRT monitor. This
%           toolbox now requires the Psychtoolbox for full functionality.
%
%           Load_Monitor_Data now automatically loads the 2D color matching
%           function file, which may not be the best approach, but okay for
%           now.
%
%           Fixed my bug on not using all three elements of the color
%           matching functions.
%
%           Removed the "elements" component as it's easy enough to just
%           pass an array/matrix without breaking them apart.
%
%           Too many other things to list.
%
%   1.6 -   Removed ErrorOnSaturation, instead just displaying to the
%           console.  This also makes it more compatible with current
%           versions of Octave.
%
%   1.5 -   All known bugs fixed (thanks Kyle!)
%
%   1.0 -   The program now can generate mostly accurate RGB values, the
%           error in v0.5 has been fixed. 
%
%   0.5 -   The program runs completely without debugging errors, however
%           the conversions still aren't correct. The issues are most
%           likely in Load_Monitor_Data, but could also be in
%           Load_Color_Matching_Functions or Get_Spectrum_from_RGB. It is
%           unlikely that this is due to the "Convert___to____" functions.
%
%Current bugs:
%
%   None known at this time.
%
%How to use:
%
%   In order to use this toolbox, you need a PR 655/650 with a program to 
%   take in these readings and create a calibration file (two provided as  
%   an example, one for monitor data, one for color matching functions) and 
%   put them in the proper order for Load_Monitor_Data and
%   Load_Color_Matching_Functions.  You can of course make your own file by
%   hand, but this could be rather tedious.
%
%   The overarching goal of this toolbox is to facilitate a transition to
%   the Psychophysics toolbox (http://psytoolbox.org/), where generating a
%   display variable and then load it to the screen with the Psychtoolbox
%   built in gamma-correction.
%
%   Gun Linearization & color correction ('beta'):
%
%   GammaColorCorrection is the newest way to get info about your monitor
%   at each of several gun values, but does NOT have methods for getting
%   spectrum information as our PR655's usb port doesn't work anymore.
%   This is still being worked on, but should create a ColorInfo variable
%   as it goes, especially the XYZ/RGB Matrix.  This may also be good for
%   putting into GammaColorCorrection.  Requires Curve Fitting Toolbox from
%   MATHWORKS to get the gun gamma curves inverted.
%   
%   How to convert colors:
%
%   To convert colors from one space to another, one must first run the
%   Load_Monitor_Data function to read in the critical data, then pass what
%   was returned to the conversion desired, such as below:
%
%   ColorInfo = Load_Monitor_Data('Default.cal');
%
%   Next we can use the provided functions:
%
%   new_xyL_array = ...
%   Convert_RGB_to_xyL([.33,.33,20],ColorInfo,'False');
%
%   The [.33,.33,20] are the xyL coordinates matching with the letter, so x
%   is .33, y is .33 and L is 20 Cd/m^2.  ColorInfo is the structure you
%   already made from Load_Monitor_Data, and 'False' says to use the
%   RGB matrix, if 'True' or anything else, use the measured spectra. 
%   If gun values are above 1 or less than 0, you will be warned of it in 
%   the Command Window.
%   
%   If converting from one space to another, where neither space is RGB,
%   simply pass the values without anything afterwards since neither 
%   monitor data nor saturation are needed, with the exception of L*a*b* as
%   it needs the white reference.
%
%   New_MWL = Convert_xyL_to_MWL([.2015,.4016,15]);
%
%   New_Lab = Convert_xyL_to_Lab([.2015,.4016,15],ColorInfo);
%
%   New_MWL = Convert_Lab_to_MWL([[-1.3363,-13.04785,15], ColorInfo);
%
%Flowchart:
%  
% Units:
% 
% RGB   -   Percent from 0 to 1 for red, green and blue
% XYZ   -   CIE 1931: Value from 0 to +INF 
%           (nominally in Cd/m^2) for X, Y and Z
% xyL   -   CIE 1931: Normalized value from 0 to 1 for x and y.
%           L is Y (nominally in Cd/m^2)
% Lu'v' -   CIE 1976 Uniform Chromaticity Scale (UCS) (NOT L*u*v*): 
%           L is Y (nominally in Cd/m^2), Values from 0 to 1 for u' and v'
% L*a*b*-   CIE 1976 L*a*b* (CIELAB) uses monitor white as reference 
%           illuminant: L* is percent from 0 to 100, a* and b* are 
%           chromaticity ranging ~ -50 to +50
% LMS   -   Cone Activation: Value from 0 to +INF 
%           (nominally scaled to Cd/m^2: L + M = Y) for L, M and S
% DKL   -   Cone Contrast: Value from 0 to 1 for L / (L + M) and 
%           S / (L + M) and from 0 to +INF for Luminance  in Cd/m^2
% MWL   -   Scaled Cone Contrast: Value from -INF to +INF for L vs. M and 
%           S vs. LM and from 0 to +INF for Luminance in Cd/m^2
% 
%Conversion Chain:
%
%                   Lab
%                    ^
%                    |
%                    V
%           RGB <-> XYZ <-> LMS <-> DKL <-> MWL
%                   ^ \              ^
%                  /   \             |
%                 V     V            |
%               xyL <-- Luv         /
%                ^                 /
%                 \_______________/
%                 
%   (DKL to xyL or vice versa will move directly to one another.)
%
%Questions and comments:
%
%   As stated above, I am just the translator, but feel free to contact me
%   at jonesc52124@gmail.com and I'll try and help you out.
%
%   Enjoy!

