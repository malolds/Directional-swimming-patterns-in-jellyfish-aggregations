%% Load-up

% -- Initialization --

clc
if exist('fig')
    try
    close(fig)
    catch
    end
end
close all
clear all
warning('off','all')

% -- Loading --

% Load package functions
PackagePath = matlab.desktop.editor.getActiveFilename;
PathCrop = find(PackagePath==92);
addpath(PackagePath(1:PathCrop(end)));
exImage = [PackagePath(1:PathCrop(end)) 'ExampleImage.png'];
keyImage = [PackagePath(1:PathCrop(end)) 'Keyboard.png'];

% Tracking File
[File1,Path1] = uigetfile('*.mat','Select Jellyfish Tracking File');
load([Path1 File1]);
% A check if the loaded file already has angles in it
try % case where the smoothened location exists, i.e. there is angles already in the file
    size(Tracks.xSmt(1));
    disp('-- Loaded data is already formatted with angles --');
    % if there is loaded angle data we don't need to re-format the
    % table
catch % case where the there is no angle data, we need to re-formulate the table
    % Create inerpolation matrices
    disp('-- Loaded data is re-formatted to include angles and interpolation --');
    Tracks = AMI_TableReformatting(Tracks);
end

% Video
[File2,Path2] = uigetfile('*.avi','Select AVI Video File');
mvi = VideoReader([Path2 File2]);

% -- Definition of global variables --

global mvi Tracks CurrentTrack AngleLine cbx
global zoomIndicator ax btnCurateAngle AngleLine spcsld spcspn1 spcspn10 CurrentTrack mvi Tracks

CurrentTrack = NaN;
AngleLine = 0;
zoomIndicator = false;

%% GUI definition

% -------------------------
% -- Graphical interface --
% -------------------------

% -- Interface --

% Figure
fig = uifigure; 
fig.Position = [10 50 1050 500];
PathCrop = find(File1==95);
fig.Name = ['AMI ' File1(1:PathCrop(end)-1) ' - Dror Malul'] ;
fig.Resize = 'off';


% Axes
ax = uiaxes(fig);
ax.Position = [0 0 800 500];
im = read(mvi,1);
imshow(im,'Parent',ax)
title('Frame 1','Parent',ax)

% Example image axes
imfig = uiimage(fig);
imfig.ImageSource = exImage;
imfig.Position = [825 180 100 100];
imfiglbl = uilabel(fig);
imfiglbl.Position = [800 240 200 100];
imfiglbl.Text = 'Jellyfish Marking Direction';

% Keyboard image axes
imKey = uiimage(fig);
imKey.ImageSource = keyImage;
imKey.Position = [825 -10 100 100];
imkeylbl = uilabel(fig);
imkeylbl.Position = [822 35 120 100];
imkeylbl.Text = 'Keyboard shortcuts';

% -- Buttons --
    
% Global frame slider
glblsldlbl = uilabel(fig); % Label
glblsldlbl.Position = [830 375+75 100 22];
glblsldlbl.Text = 'Show trajectories:';
glblsld = uislider(fig); % Slider
glblsld.Position = [800 370+75 150 20];
glblsld.Limits = [1 mvi.NumberOfFrames];
glblsld.MajorTicks = floor(linspace(1,mvi.NumberOfFrames,6));

% Specific track frame slider
specsldlbl = uilabel(fig); % Label
specsldlbl.Position = [810 280+75 150 22];
specsldlbl.Text = 'Show specific trajectory:';
spcsld = uislider(fig); % Slider
spcsld.Position = [800 275+75 150 20];

% Specific track frame spinner
spcspn1 = uispinner(fig);
spcspn1.Position = [960 267+75 24 20]; % Change 3rd number to 50 to see the numbers on the spinner
spcspn1lbl = uilabel(fig); % Label
spcspn1lbl.Position = [965 285+75 25 20];
spcspn1lbl.Text = '+1';


% Specific track frame spinner
spcspn10 = uispinner(fig);
spcspn10.Position = [985 267+75 24 20]; % Change 3rd number to 50 to see the numbers on the spinner
spcspn10.Step = 10;
spcspn10lbl = uilabel(fig); % Label
spcspn10lbl.Position = [985 285+75 25 20];
spcspn10lbl.Text = '+10';


% Mark Angle button
btnMarkAngle = uibutton(fig,'push');
btnMarkAngle.Position = [820 185-30 35 22];
btnMarkAngle.Text = 'Mark';
btnMarkAngle.BackgroundColor = 'g';

% Curate Angle button
btnCurateAngle = uibutton(fig,'push');
btnCurateAngle.Position = [875+15 185-30 35 22];
btnCurateAngle.Text = 'Curate';
btnCurateAngle.BackgroundColor = 'r';

% Reset angle button
btnResetAngle = uibutton(fig,'push');
btnResetAngle.Position = [855 185-30 35 22];
btnResetAngle.Text = 'Reset';
btnResetAngle.BackgroundColor = 'y';



% Save File
btnSaveFile = uibutton(fig,'push');
btnSaveFile.Position = [820 160-30 105 22];
btnSaveFile.Text = 'Save File';

% Track choosing Button
btnChooseTrack = uibutton(fig,'push');
btnChooseTrack.Position = [830 310+75 100 22];
btnChooseTrack.Text = 'Choose Track';

% -- Check Boxes --

% Raw data
cbx.Raw = uicheckbox(fig); 
cbx.Raw.Position = [800 100 84 22];
cbx.Raw.Text = 'Raw';
cbx.Raw.Value  = 1;
% Smooth data
cbx.Smt = uicheckbox(fig);
cbx.Smt.Position = [850 100 84 22];
cbx.Smt.Text = 'Smt';
cbx.Smt.Value  = 0;
% Angles
cbx.Ang = uicheckbox(fig);
cbx.Ang.Position = [900 100 84 22];
cbx.Ang.Text = 'Ang';
cbx.Ang.Value  = 1;

% -------------------
% -- Interactivity --
% -------------------

% Global slider
glblsld.ValueChangedFcn = @(glblsld,event) AMI_UpdateImage(glblsld,ax,mvi,Tracks,cbx);
% Track-specific slider and spinner
spcsld.ValueChangedFcn = @(spclsld,event) AMI_UpdateImageTrack(spclsld,spcspn1,spcspn10,ax,mvi,Tracks,1,cbx,CurrentTrack);
spcspn1.ValueChangedFcn = @(spn,event) AMI_UpdateImageTrack(spcsld,spcspn1,spcspn10,ax,mvi,Tracks,0,cbx,CurrentTrack);
spcspn10.ValueChangedFcn = @(spn,event) AMI_UpdateImageTrack(spcsld,spcspn1,spcspn10,ax,mvi,Tracks,0,cbx,CurrentTrack);
% Buttons
btnChooseTrack.ButtonPushedFcn = @(btnChooseTrack,event) AMI_ChooseTrack(btnChooseTrack,spcsld,spcspn1,spcspn10,Tracks);
btnMarkAngle.ButtonPushedFcn = @(btnMarkAngle,event) AMI_MarkAngle(btnMarkAngle,ax);
btnResetAngle.ButtonPushedFcn = @(btnMarkAngle,event) AMI_ResetAngle(btnMarkAngle,ax);

btnCurateAngle.ButtonPushedFcn = @(btnCurateAngle,event) AMI_CurateAngle(btnCurateAngle,AngleLine,spcsld,spcspn1,spcspn10,CurrentTrack,mvi,Tracks);
btnSaveFile.ButtonPushedFcn = @(btnSaveFile,event) AMI_SaveFile(btnSaveFile,Tracks,ImageParam,minTrackLength,TrackMateParam,File1,Path1);
set(fig,'WindowKeyPressFcn',@AMI_keyPressCallback);





