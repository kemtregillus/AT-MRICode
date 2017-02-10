function defaultCluts
%Restore default gamma table for up to three monitors.

Screen('LoadNormalizedGammaTable',0,[0:1/255:1;0:1/255:1;0:1/255:1]');
Screen('LoadNormalizedGammaTable',1,[0:1/255:1;0:1/255:1;0:1/255:1]');
Screen('LoadNormalizedGammaTable',2,[0:1/255:1;0:1/255:1;0:1/255:1]');
end

