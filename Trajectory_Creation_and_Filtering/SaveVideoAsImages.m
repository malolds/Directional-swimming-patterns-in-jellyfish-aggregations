%% SaveVideoAsImages
% A code to process videos into 2 Hz image sequences:
% The code loads a video and saves in another folder 
% RGB and HSV sequences of images.
% To convert the image sequences into videos 
% use CreateMovie.m 

% Initialization
clc
clear all
close all

% Load video file
[FileName FilePath] = uigetfile({'*.MOV'; '*.MP4'},'Select Video To Process');
cd(FilePath)
mvi = VideoReader(FileName);

%%
% Make new directory for images
mkdir('Processed')
cd([FilePath 'Processed\'])

% Def of processing parameters
lowerContrast = 0.5; upperContrast = 1; % Contrast bounds
medfiltNei = 5; % Median filter neighbourhood
FrameRate = 15; % Framerate of new video (15 fps for 2 Hz Video)

c = 1; % Counter for image number
LoopArray = 1:FrameRate:mvi.NumberOfFrames;
wb = waitbar(0,'Saving images');
tic
for i=LoopArray(1:end)
    im = read(mvi,i);
    % Saving RGB image
	imwrite(im,['RGBImage_' num2str(c) '.jpg'])
    % HSV image processing
    imHSV = rgb2hsv(im);
    imHSV = imHSV(:,:,3); % Value layer
    imContrast = imadjust(imHSV,[lowerContrast upperContrast]); % Contrast
    imSmooth = medfilt2(imContrast,[medfiltNei medfiltNei]); % Median filter
    imwrite(imSmooth,['HSVImage_' num2str(c) '.jpg'])
    waitbar(c/length(LoopArray),wb,'Saving images');

    c = c + 1
end
toc

close(wb)

% Save filtering parameters log file in the same folder
save('ImagePrcoParam.mat','FrameRate','lowerContrast','upperContrast','medfiltNei')
msgbox('Images Ready!')