function [texture] = stimGen(angle,phase,achrom,stepSize,lumCon,w,screenRect,xCenter,yCenter,fixation,MWLcenter,screenNumber,lumAmp)

load colorInfo_renown2;
%determine the highest screen number



%open a window on the designated monitor


%create a backup of the default color lookup tables (CLUTs)
BackupCluts(screenNumber);

%load the customized gamma table
Screen('LoadNormalizedGammaTable', w, gammaTable);
RestoreCluts;

% screenNumber = max(Screen('Screens'));
% [MWLcenter] = ConvertColors('mwlrgb',[0 0 18])%,colorInfo);
% [w, screenRect]= Screen('OpenWindow',screenNumber, MWLcenter.*255);
% [screenXpixels, screenYpixels] = Screen('WindowSize', w);
% [xCenter, yCenter] = RectCenter(screenRect);%%center points
% 
% fixation = [0 0 20 20];
% achrom = 0;
% phase = 1;
% angle = 90;
% stepSize = .01;
% lumCon = .2;



maxContrast = 80;
imSize = 200;
freq = 1;
maxLum = 18;
contrastX = 1:imSize;
conResp = (contrastX / imSize) - .5;
conA = sin(conResp*2*pi*freq+(phase*2*pi));
contrast = conA * maxContrast;
texture = NaN(((lumCon*2)/stepSize),1);
textPoint = 1;
vals = zeros(imSize,3);
% figure(1)
% hold on;


if achrom == 0
    for j = -lumCon:stepSize:lumCon
        lum = ((j*conA+1) * maxLum);
        lum2 = ((j*conA) * maxLum);
        for i = 1:imSize
            x = contrast(i) .* cosd(lum2(i)).* cosd(angle);
            y = contrast(i) .* cosd(lum2(i)).* sind(angle);
%             z = contrast(i) .* sind(lum(i));
%                         [x,y] = xyconvert(angle,contrast(i),'MWLPol','MWLCart');
            %             [x,y,z] = sph2cart(x,y,lum(i));
%                         xyVals(i,1) = x;
%                         xyVals(i,2) = y;
%                         xyVals(i,3) = z;
%             [val] = ConvertColors('mwlrgb',[x y lum(i)]);%,colorInfo)
            [val] = ConvertColors('mwlrgb',[x y lum(i)],colorInfo);
            vals(i,:) = val;
        end
        
        %         scatter(xyVals(:,2),lum')
        
        
        ringSize = 50;
        for i = 1:5
            for k = 1:imSize
                ringSize = ringSize + 1;
                ringRect = CenterRectOnPointd([0 0 ringSize ringSize],xCenter,yCenter);
                Screen('FrameOval',w,vals(k,:).*255,ringRect,1);
                
            end
            
            fixRect = CenterRectOnPointd(fixation,xCenter,yCenter);
            Screen('FillOval',w, MWLcenter,fixRect);
            
        end
        Screen('Flip', w);
        bitmap = Screen('GetImage', w);
        texture(textPoint) = Screen('MakeTexture',w,bitmap);
        filename = strcat('text',num2str(phase),num2str(angle),num2str(textPoint),'.jpg');
        %         imwrite(bitmap,filename,'jpeg');
        textPoint = textPoint+1;
    end
    
elseif achrom == 1
    texture = NaN(1,1);
    conA = sin(conResp*2*pi*freq+((.25+phase)*2*pi));
    lum = ((.25*conA+1) * maxLum);
    for i = 1:imSize
        [x,y] = xyconvert(angle,0,'MWLPol','MWLCart');
        [val] = ConvertColors('mwlrgb',[x y lum(i)],colorInfo);
        vals(i,:) = val;
    end
    ringSize = 50;
    for i = 1:5
        for k = 1:imSize
            ringSize = ringSize + 1;
            ringRect = CenterRectOnPointd([0 0 ringSize ringSize],xCenter,yCenter);
            Screen('FrameOval',w,vals(k,:).*255,ringRect,1);
            
        end
        
        fixRect = CenterRectOnPointd(fixation,xCenter,yCenter);
        Screen('FillOval',w, MWLcenter,fixRect);
        
    end
    Screen('Flip', w);
    bitmap = Screen('GetImage', w);
    texture(1) = Screen('MakeTexture',w,bitmap);
    filename = strcat('text',num2str(phase),'achrom','.jpg');
    %     imwrite(bitmap,filename,'jpeg');
elseif achrom == 2
    texture = NaN(1,1);
    for j = 1:4
        lum = ((lumAmp*conA+1) * maxLum);
        lum2 = ((lumAmp*conA) * maxLum);
        for i = 1:imSize
            x = contrast(i) .* cosd(lum2(i)).* cosd(angle);
            y = contrast(i) .* cosd(lum2(i)).* sind(angle);
            [val] = ConvertColors('mwlrgb',[x y lum(i)],colorInfo);
            vals(i,:) = val;
        end
        ringSize = 50;
        for i = 1:5
            for k = 1:imSize
                ringSize = ringSize + 1;
                ringRect = CenterRectOnPointd([0 0 ringSize ringSize],xCenter,yCenter);
                Screen('FrameOval',w,vals(k,:).*255,ringRect,1);
                
            end
            
            fixRect = CenterRectOnPointd(fixation,xCenter,yCenter);
            Screen('FillOval',w, MWLcenter,fixRect);
            
        end
        Screen('Flip', w);
        bitmap = Screen('GetImage', w);
        texture(j) = Screen('MakeTexture',w,bitmap);
        filename = strcat('text',num2str(maxContrast),num2str(phase),num2str(angle),'.jpg');
        imwrite(bitmap,filename,'jpeg');
        maxContrast = maxContrast / 2;
        contrast = maxContrast * conA;
    end
end

