%load the calibration file
load colorInfo_Renown;

%determine the highest screen number
screenNumber = max(Screen('Screens'));

[MWLcenter] = ConvertColors('mwlrgb',[0 0 18]);
%open a window on the designated monitor
[w, screenRect]= Screen('OpenWindow',screenNumber, MWLcenter.*255);

%create a backup of the default color lookup tables (CLUTs)
BackupCluts(screenNumber);

%load the customized gamma table
Screen('LoadNormalizedGammaTable', w, gammaTable);

%At this point, you are taking advantage of the monitor calibration;
%now you would show your stimuli, collect data, etc. At the end of your
%program (and/or in a catch statement, if you use those), you would
%have this next line:

%Restore the default lookup tables
RestoreCluts;

%And that's it! Note that if you're using the Matlab ConvertColors
%functions then things become a bit more complicated, but I don't know if
%anybody outside of the Croglab uses those, so I tried to keep it simple.