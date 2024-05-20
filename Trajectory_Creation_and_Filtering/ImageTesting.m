%% Initialization
% This script is an aid in the process of generating image sequences from
% the original video. It allows to test the image processing parameters on
% several evenly spreadout images from the videos in order to determine the
% required parameters.
clc
clear all
close all

% Load video file
[FileName FilePath] = uigetfile({'.MOV';'.MP4'},'Select Video To Process');
mvi = VideoReader([FilePath FileName]);

%%
close all
lowerContrast = 0.5; upperContrast = 1; % Contrast bounds for imadjust
medfiltNei = 5; % Median filter neighbourhood
FrameRate = 15; % Sampling rate of new video

% Choosing 5 images spreadout along the video
LoopArray = floor(linspace(1,mvi.NumberOfFrames,5));

for i=LoopArray
    im = read(mvi,i);
    imHSV = rgb2hsv(im);
    imHSV = imHSV(:,:,3);
    
    % Applying contrast
    imContrast = imadjust(imHSV,[lowerContrast upperContrast]); % Contrast
    % Applying median filter
    imSmooth = medfilt2(imContrast,[medfiltNei medfiltNei]); % Median filter
    
    figure
    imshow(imSmooth)
end

msgbox('Done!')