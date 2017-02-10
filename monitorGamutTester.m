%%%%% Monitor Gamut Tester %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script tests the maximum saturation (unipolar) and contrast
% (bipolar) at each specified angle in DKL space.
%  11/23/16 JEV - Wrote it.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

load colorInfo_renown2;

%% Set parameters
phi = 45; %for testing color + luminance
luminance = 18;

rhoStart = 60; %starting saturation
rhoStep = 5;
rhoEnd = 500;

% rhoStart = 0.001;
% rhoStep = 0.001;
% rhoEnd = 10;

lumStart = 0;
lumStep = 1;
lumEnd = 60;
nLum = length(lumStart:lumStep:lumEnd);

colorAngles = 1:360;
nAngles = length(colorAngles);

%% Declare storage variables
maxRho = NaN(nAngles,1);
maxCoords = NaN(nAngles,2);
maxRhoWithLum = NaN(nAngles,1,nLum);
maxCoordsWithLum = NaN(nAngles,2,nLum);
minAngleWithLum = NaN(nLum,1);
minCircle = NaN(nAngles,2);
minSphere = NaN(nAngles,2,nLum);
axisVar = NaN(nAngles,nLum);

%% Test single-luminance saturations
disp('Testing monitor gamut...');

startTime = GetSecs;
for a = 1:nAngles
    angle = colorAngles(a);
    
    for rho = rhoStart:rhoStep:rhoEnd
        [LM,S] = sph2cart(angle*(pi/180),0,rho);
        [coord,sat] = ConvertColors_noWarning('mwlrgb',[LM,S,luminance],colorInfo);
        
        if sat == 0
            prevCoords = [LM S];
        elseif sat == 1
            if rho == rhoStart %if the first value saturates
                maxRho(a) = rho;
                maxCoords(a,:) = [LM S];
            else
                maxRho(a) = rho - rhoStep;
                maxCoords(a,:) = prevCoords;
                sat = 0;
                break;
            end
        end
    end
end

%% Test multiple-luminance saturations
for Lum = lumStart:lumStep:lumEnd
    for a = 1:nAngles
        angle = colorAngles(a);
        
        for rho = rhoStart:rhoStep:rhoEnd
            [LM,S] = sph2cart(angle*(pi/180),0,rho);
            [coord,sat] = ConvertColors_noWarning('mwlrgb',[LM,S,Lum],colorInfo);
            
            if sat == 0
                prevCoords = [LM S];
            elseif sat == 1
                if rho == rhoStart %if the first value saturates
                    maxRhoWithLum(a,1,Lum) = rho;
                    maxCoordsWithLum(a,:,Lum) = [LM S];
                else
                    maxRhoWithLum(a,1,Lum) = rho - rhoStep;
                    maxCoordsWithLum(a,:,Lum) = prevCoords;
                    sat = 0;
                    break;
                end
            end
        end
    end
end

endTime = GetSecs;
totalTime = (endTime-startTime)/60;

%determine rho-limiting angle
minRho = min(maxRho); %what's the lowest rho that doesn't saturate?
for a = 1:nAngles
    if maxRho(a) == minRho
        minAngle = a;
        break;
    end
end

disp(['Limiting angle: ' num2str(minAngle)]);
disp(['Limiting rho: ' num2str(minRho)]);

%create circular non-saturating space
for a = 1:nAngles
    [LM,S] = sph2cart(a*(pi/180),0,minRho);
    minCircle(a,:) = [LM S];
end

%create spherical non-saturating space
i = 1;
for l = lumStart:lumStep:lumEnd %for each luminance
    minRhoWithLum = min(maxRhoWithLum); %what's the lowest rho that doesn't saturate?
    for a = 1:nAngles
        if maxRhoWithLum(a,1,i) == minRhoWithLum(1,1,i)
            minAngleWithLum(i) = a; %what's the min angle 
            break;
        end
    end
    
    for a = 1:nAngles
        [LM,S] = sph2cart(a*(pi/180),0,minRhoWithLum(1,1,i));
        minSphere(a,1:2,i) = [LM S];
        minSphere(:,3,i) = l;
    end
    i = i + 1;
end

testDate = date;
save('monitorGamut','maxRho','maxCoords','maxRhoWithLum',...
    'maxCoordsWithLum','testDate');

%% Graph results
figure; hold on;
plot(maxCoords(:,1),maxCoords(:,2),'b-');
plot(0,0,'kx');
xlabel('LM Contrast');
ylabel('S Contrast');
plot(minCircle(:,1),minCircle(:,2),'r-');
saveas(1,'monitorGamut2D.png');
close(1);

%create luminance axis for 3D plot
for a = 1:nAngles
    i = 1;
    for l = lumStart:lumStep:lumEnd
        axisVar(1:nAngles,i) = l;
        i = i + 1;
    end
end

plot3(0,0,18,'kx'); hold on;
for l = 1:nLum
    plot3(maxCoordsWithLum(:,1,l),maxCoordsWithLum(:,2,l),...
        axisVar(:,l));
    plot3(minSphere(:,1,l),minSphere(:,2,l),axisVar(:,l),'r-');
end
xlabel('LM Contrast');
ylabel('S Contrast');
zlabel('Luminance');
saveas(1,'monitorGamut3D.png');

disp(['All done! Time elapsed: ' num2str(totalTime) ' min']);
disp('Graphs saved as ''monitorGamut2D.png'' and ''monitorGamut3D.png''.');
disp('Data file saved as ''monitorGamut.mat''.');