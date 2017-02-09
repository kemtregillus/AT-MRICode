% Temp generation based on MWL space

pixels = 70;
width = 800; height=600; rgb=3;
BaseColorContrast = 60; % sort of a percentage

% colorInfo = Load_Monitor_Data();
load('BenQMonitor2.mat');

%Initialize
LvsM_bitmap=zeros(height,width,rgb);
SvsLM_bitmap = LvsM_bitmap;
Lum_bitmap = LvsM_bitmap;

SvsLM = 0;
Lum = 50;

for i=1:height
    LvsM = BaseColorContrast*sin(2*pi*(1/pixels)*i);
    RGB_array = ConvertColors('MWLRGB',[LvsM,SvsLM,Lum],colorInfo);
%     RGB_array = Convert_MWL_to_RGB([LvsM,SvsLM,Lum],colorInfo,'True');
    LvsM_bitmap(i,:,1)=RGB_array(1);
    LvsM_bitmap(i,:,2)=RGB_array(2);
    LvsM_bitmap(i,:,3)=RGB_array(3);
end

imwrite(LvsM_bitmap,'LvsM colors.jpg','jpeg');
disp('LvsM printed')

LvsM = 0;
Lum = 50;

for i=1:height
    SvsLM = BaseColorContrast*sin(2*pi*(1/pixels)*i);
%     RGB_array = Convert_MWL_to_RGB([LvsM,SvsLM,Lum],colorInfo,'True');
    RGB_array = ConvertColors('MWLRGB',[LvsM,SvsLM,Lum],colorInfo);
    SvsLM_bitmap(i,:,1)=RGB_array(1);
    SvsLM_bitmap(i,:,2)=RGB_array(2);
    SvsLM_bitmap(i,:,3)=RGB_array(3);
end

imwrite(SvsLM_bitmap,'SvsLM colors.jpg','jpeg');

disp('SvsLM printed')

%pixels = floor(pixels/4); %Makes smaller cycles/degree

for i=1:height
    LvsM = 0;
    SvsLM = 0;
    Lum = 25*sin(2*pi*(1/pixels)*i)+25;
%     RGB_array = Convert_MWL_to_RGB([LvsM,SvsLM,Lum],colorInfo,'True');
    RGB_array = ConvertColors('MWLRGB',[LvsM,SvsLM,Lum],colorInfo);
    Lum_bitmap(i,:,1)=RGB_array(1);
    Lum_bitmap(i,:,2)=RGB_array(2);
    Lum_bitmap(i,:,3)=RGB_array(3);
end

imwrite(Lum_bitmap, 'Lum colors.jpg','jpeg');
disp('Lum printed')
