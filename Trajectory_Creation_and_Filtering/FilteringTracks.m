%% Initialization
% This code filters and saves the tracks from TrackMate
% Filtering first by length of track
% And then filtering manually
% Lastly, the procedure converts the data into a table and saves
% along with the parameters used for image processing and tracking
clc
clear all
close all

% Load *.xml file
% Add path where importTrackMateTracks.m is found
path = matlab.desktop.editor.getActiveFilename;
slshloc = strfind(path,'\');
addpath(path(1:slshloc(end)));
% Load *.xml as cell array
[File1 Path1] = uigetfile('*.xml','Load track matrix');
unfilteredTracks = importTrackMateTracks([Path1 File1]);

% Load bag tracks and combine them with the unfiltered tracks
answer = questdlg('Add bags?', ...
	'Bags', ...
	'Yes','No','No');
% Handle response
switch answer
    case 'Yes'
        [File3 Path3] = uigetfile('*.xml','Load track matrix');
        bagTracks = importTrackMateTracks([Path3 File3]);
        unfilteredTracks = [unfilteredTracks ; bagTracks];
end

% Load processed movie file (2 Hz RGB)
[File2 Path2] = uigetfile({'*.avi';'*.MP4'},'Load 2 Hz RGB video file');
mvi = VideoReader([Path2 File2]);

%%
for i=1:length(unfilteredTracks)
    L(i) = length(unfilteredTracks{i});
end
min(L)
%% Filtering by length of track
% answer = inputdlg('Min. Track Length','Min. Track Length',[1 20]);
% minTrackLength = str2num(cell2mat(answer)); % Min. track size
minTrackLength = min(L);
c = 1; % Counter for tracks after filtering short ones
filtTracks = {}; % matrix of filtered tracks
for i=1:size(unfilteredTracks,1)
    tempTrack = cell2mat(unfilteredTracks(i));
    if size(tempTrack,1)>=minTrackLength
        filtTracks(c) = {tempTrack};
        c = c + 1;
    end  
end

%% Manual filtering of tracks

numTracks = size(filtTracks,2); % Number of tracks
Markings = []; % Memory alloc. for marking vector
imageFrames = 1:mvi.NumberOfFrames; 
for i=1:numTracks
    tempTrack = cell2mat(filtTracks(i));
    im = read(mvi,imageFrames(tempTrack(1,1)+1));
    close all
    figure('color','w','position',[0 0 1 1])
    imshow(im)
    hold on
    title(['Track ' num2str(i) '/' num2str(numTracks) ' StartFrame ' num2str(tempTrack(1,1)+1)])
    plot(tempTrack(:,2),tempTrack(:,3),'color','y')
    scatter(tempTrack(1,2),tempTrack(1,3),'r')
    pause
    list = {'Jellyfish','Plate','Surface Bag',...                   
    'Deep bag','Drifter','Invalid','GPS bag'};
    indx = [];
    [indx,tf] = listdlg('ListString',list,'SelectionMode','single');
    % Handle response
    if not(isempty(indx))
        switch indx
            case 1
                Markings(i) = 'j';
            case 2
                Markings(i) = 'p';
            case 3
                Markings(i) = 'b';
            case 4
                Markings(i) = 'd';
            case 5
                Markings(i) = 'r';
            case 6
                Markings(i) = 'i';
            case 7
                Markings(i) = 'g';
            otherwise
                Markings(i) = char(0);
        end
    else
        Markings(i) = 'i';
    end
    Markings;
end
pause
close all
%% Converting into table
x = {}; y = {}; t = {}; L = []; Marking = [];
Tracks = table(x,y,t,L,Marking);
clear x y t L Marking
lenTracks = length(filtTracks);
warning('off')
for i = 1:lenTracks
    tempTrack = cell2mat(filtTracks(i));
%     Tracks.Serial(i) = i;
    Tracks.x(i) = {(tempTrack(:,2))};
    Tracks.y(i) = {tempTrack(:,3)};
    Tracks.t(i) = {tempTrack(:,1)};
    Tracks.L(i) = size(tempTrack,1);
    Tracks.Marking(i) = char(Markings(i));
    i;
end

%% Save

% Save Tracking parameters
TrackMateParam = struct();
prompt = {'Blob diameter:','Threshold:','Linking:','Gap-closing:','Frame gap:'};
dlgtitle = 'Enter TrackMate parameters';
dims = [1 35];
definput = {'18','2','40','40','2'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
TrackMateParam.BlobD = str2num(answer{1});
TrackMateParam.Threshold = str2num(answer{2});
TrackMateParam.Linking = str2num(answer{1});
TrackMateParam.GapClosing = str2num(answer{2});
TrackMateParam.FrameGap = str2num(answer{3});

% Load image parameters File and convert to structure
[File3 Path3] = uigetfile('*.mat','Load image parameters file');
load([Path3 File3]);
ImageParam = struct();
ImageParam.FrameRate = FrameRate;
ImageParam.lowerContrast = lowerContrast;
ImageParam.upperContrast = upperContrast;
ImageParam.medfiltNei = medfiltNei;

% Saving 
uisave({'Tracks','minTrackLength','TrackMateParam','unfilteredTracks','ImageParam'})
msgbox('Saved!')




