%% Initialzation
% GUI with anglefinding, and angleshowing where possible
% Init.
clc
close all
clear all

% Loading

% Tracking File
[File1,Path1] = uigetfile('*.mat','Select Jellyfish Tracking File');
load([Path1 File1]);
% Video
[File2,Path2] = uigetfile({'*.avi';'*.mp4'},'Select AVI Video File');
global mvi
mvi = VideoReader([Path2 File2]);
lTracks = size(Tracks,1);
warning('off','all')

%%

% First track as default track
global tempT tempX tempY comments CurrentTrack comInd tempMarking Tracks vidHD AngleLine CurrentAngle angles anglesLoaded
CurrentAngle = 1; 
anglesLoaded = exist('Angles');
comTrack = {}; comFrame = {}; comComment = {};

tempT = cell2mat(Tracks.t(1));
tempX = cell2mat(Tracks.x(1));
tempY = cell2mat(Tracks.y(1));
tempMarking = Tracks.Marking(1);
comments = table(comTrack,comFrame,comComment);
angDate = {}; angFlight = {}; angMovie = {}; angTrack = {}; angFrame = {}; angX = {}; angY = {}; angRad = {}; angDeg = {};
angles = table(angDate,angFlight,angMovie, angTrack, angFrame, angX, angY, angRad, angDeg);
global angles

comInd = 1;
CurrentTrack = 1;

% Figure
fig = uifigure; 
fig.Position = [10 50 1000 500];

% Axes
ax = uiaxes(fig);
ax.Position = [0 0 800 500];

% Slider
sld = uislider(fig);
sld.Position = [800 50 150 3];
sld.Limits = [min(tempT)+1 max(tempT)+1];

% Spinner
spn = uispinner(fig);
spn.Position = [830 60 100 22];
% Label
spnlab = uilabel(fig);
spnlab.Position = [840 80 100 22];
spnlab.Text = 'Video frame:';

% Dropdown track
indTracks = find(Tracks.Marking);
for i=1:length(indTracks)
    itemsdd(i) = cellstr(num2str(indTracks(i)));
end
ddown = uidropdown(fig,'items',['Choose track..' itemsdd]);
ddown.Position = [820 110 50 22];

% Choose track number button
btnChooseTrack = uibutton(fig,'push');
btnChooseTrack.Position = [870 110 50 22];
btnChooseTrack.Text = 'Choose Track';

% Add comment button
btnAddComment = uibutton(fig,'push');
btnAddComment.Position = [820 160 100 22];
btnAddComment.Text = 'Add Comment';

% Save comments button
btnSaveComments = uibutton(fig,'push');
btnSaveComments.Position = [820 135 100 22];
btnSaveComments.Text = 'Save Comments';

% Show scatter of all points at a specific frame
btnShowScatter = uibutton(fig,'push');
btnShowScatter.Position = [820 185 100 22];
btnShowScatter.Text = 'Show Scatter';

% Text area
textShowScatter = uitextarea(fig,'Position',[925 185 50 22],'Value','1');

% Change Marking button
btnChangeMarking = uibutton(fig,'push');
btnChangeMarking.Position = [820 210 100 22];
btnChangeMarking.Text = 'Change Marking';

% Split track
% When you split track the 1st part keeps the track number and the new
% track gets a new number - the last
btnSplitTrack = uibutton(fig,'push');
btnSplitTrack.Position = [820 260 100 22];
btnSplitTrack.Text = 'Split Track';

% Merge Button
btnMergeTrack = uibutton(fig,'push');
btnMergeTrack.Position = [820 235 100 22];
btnMergeTrack.Text = 'Merge Tracks';

% Save button

btnSaveFile = uibutton(fig,'push');
btnSaveFile.Position = [820 285 100 22];
btnSaveFile.Text = 'Save File';

% Load HD Movie button

btnLoadHD = uibutton(fig,'push');
btnLoadHD.Position = [820 450 100 22];
btnLoadHD.Text = 'Load HD Movie';

% Show HD Movie button

btnShowHD = uibutton(fig,'push');
btnShowHD.Position = [820 425 100 22];
btnShowHD.Text = 'Show HD Image';

% Load Mark Angle button

btnMarkAngle = uibutton(fig,'push');
btnMarkAngle.Position = [820 400 100 22];
btnMarkAngle.Text = 'Mark Angle';

% Load Curate Angle button

btnCurateAngle = uibutton(fig,'push');
btnCurateAngle.Position = [820 375 100 22];
btnCurateAngle.Text = 'Curate Angle';

% Load Save Angles button

btnSaveAngles = uibutton(fig,'push');
btnSaveAngles.Position = [820 350 100 22];
btnSaveAngles.Text = 'Save Angles';

% Load Angles Button
btnLoadAngles = uibutton(fig,'push');
btnLoadAngles.Position = [820 325 100 22];
btnLoadAngles.Text = 'Load Angles';

% Figure legend labels
leglab1 = uilabel(fig);
leglab1.Position = [925 400 100 22];
leglab1.Text = '<b style="color:black;"><u>J</u>ellyfish</b>';
leglab1.Interpreter = 'html';
leglab2 = uilabel(fig);
leglab2.Position = [925 385 100 22];
leglab2.Text = '<b style="color:red;"><u>P</u>late</b>';
leglab2.Interpreter = 'html';
leglab3 = uilabel(fig);
leglab3.Position = [925 370 100 22];
leglab3.Text = '<b style="color:gray;"><u>B</u>ag (surf.)</b>';
leglab3.Interpreter = 'html';
leglab4 = uilabel(fig);
leglab4.Position = [925 355 100 22];
leglab4.Text = '<b style="color:green;">Bag (<u>D</u>eep)</b>';
leglab4.Interpreter = 'html';
leglab5 = uilabel(fig);
leglab5.Position = [925 340 100 22];
leglab5.Text = '<b style="color:orange;"><u>I</u>nvalid</b>';
leglab5.Interpreter = 'html';

leglab6 = uilabel(fig);
leglab6.Position = [925 325 100 22];
leglab6.Text = '<b style="color:blue;">D<u>r</u>ifter</b>';
leglab6.Interpreter = 'html';
leglab7 = uilabel(fig);
leglab7.Position = [925 310 100 22];
leglab7.Text = '<b style="color:magenta;"><u>G</u>PS bag</b>';
leglab7.Interpreter = 'html';


% Interaction
sld.ValueChangedFcn = @(sld,event) updateImage(sld,ax,mvi,tempX,tempY,spn,CurrentTrack,tempMarking);
spn.ValueChangedFcn = @(spn,event) updateSlider(sld,ax,mvi,tempX,tempY,spn,CurrentTrack,tempMarking);
btnChooseTrack.ButtonPushedFcn = @(btnChooseTrack,event) chooseTrack(btnChooseTrack,lTracks,sld,Tracks);
btnAddComment.ButtonPushedFcn = @(btnAddComment,event) AddComment(btnAddComment,sld,Tracks,CurrentTrack,comInd,comments);
btnSaveComments.ButtonPushedFcn = @(btnSaveComments,event) SaveComments(btnSaveComments,comments);
btnShowScatter.ButtonPushedFcn = @(btnShowScatter,event) ShowScatter(btnShowScatter,Tracks,textShowScatter,mvi,ax,anglesLoaded);
ddown.ValueChangedFcn = @(ddown,event) chooseTrackddown(ddown,lTracks,sld,Tracks);

btnChangeMarking.ButtonPushedFcn = @(btnChangeMarking,event) ChangeMarking(btnChangeMarking,Tracks,CurrentTrack);
btnMergeTrack.ButtonPushedFcn = @(btnMergeTrack,event) MergeTrack(btnMergeTrack,Tracks);

btnSplitTrack.ButtonPushedFcn = @(btnSplitTrack,event) SplitTrack(btnSplitTrack,Tracks,CurrentTrack);
btnSaveFile.ButtonPushedFcn = @(btnSaveFile,event) SaveFile(btnSaveFile,Tracks,ImageParam,minTrackLength,TrackMateParam,File1,Path1);
% Angle specific buttons
btnShowHD.ButtonPushedFcn = @(btnShowHD,event) ShowHD(btnShowHD,ax,sld);
btnLoadHD.ButtonPushedFcn = @(btnLoadHD,event) LoadHD(btnLoadHD,ax,sld);
btnMarkAngle.ButtonPushedFcn = @(btnMarkAngle,event) MarkAngle(btnMarkAngle,ax);
btnSaveAngles.ButtonPushedFcn = @(btnSaveAngles,event) SaveAngles(btnSaveFile,File1,angles);
btnLoadAngles.ButtonPushedFcn = @(btnLoadAngles,event) LoadAngles(btnLoadAngles);
btnCurateAngle.ButtonPushedFcn = @(btnCurateAngle,event) CurateAngle(btnCurateAngle,AngleLine,angles,File1,CurrentAngle,CurrentTrack,sld,mvi);



% Tracks, ImageParam minTrackLength, TrackMateParam, unfilteredTracks
% Show first image
im = read(mvi,sld.Limits(1));
imshow(im,'Parent',ax)


% Interactivity functions
function ShowHD(btnShowHD,ax,sld)
    global vidHD
    imHD = read(vidHD,(floor(sld.Value)-1)*15+1);
    imshow(imHD,'Parent',ax)
end

function MarkAngle(btnMarkAngles,ax);
    global AngleLine
    AngleLine = drawline(ax,'LineWidth',1,'Color','y');
end

function CurateAngle(btnCurateAngle,AngleLine,angles,File1,CurrentAngle,CurrentTrack,sld,mvi)
    global angles AngleLine CurrentAngle CurrentTrack mvi
    angles.angDate(CurrentAngle) = {str2num(File1(1:8))};
    angles.angFlight(CurrentAngle) = {str2num(File1(findstr(File1,'F')+1))};
    angles.angMovie(CurrentAngle) = {File1(findstr(File1,'DJI'):findstr(File1,'DJI')+7)};
    angles.angTrack(CurrentAngle) = {CurrentTrack};
    angles.angFrame(CurrentAngle) = {floor(sld.Value)};
    pos = AngleLine.Position;
    pos(:,2) = mvi.Height - pos(:,2); % Correction for angle calculation
    angles.angX(CurrentAngle) = {pos(:,1)};
    angles.angY(CurrentAngle) = {pos(:,2)};
    angles.angRad(CurrentAngle) = {atan2((pos(2,2)-pos(1,2)),(pos(2,1)-pos(1,1)))};    
    angles.angDeg(CurrentAngle) = {rad2deg(atan2((pos(2,2)-pos(1,2)),(pos(2,1)-pos(1,1))))};
    if cell2mat(angles.angDeg(CurrentAngle)) < 0
        angles.angDeg(CurrentAngle) = {cell2mat(angles.angDeg(CurrentAngle)) + 360};
        angles.angRad(CurrentAngle) = {cell2mat(angles.angRad(CurrentAngle)) + 2*pi};
    end        
    CurrentAngle = CurrentAngle + 1;
    AngleLine = [];
    msgbox('Angle data saved to database!');
end

function SaveAngles(btnSaveAngles,File1,angles)
    global angles
    saveName = File1(1:findstr(File1,'filt')-1);
    uisave({'angles'},[saveName 'Angle.mat']);
    
end

function LoadAngles(btnLoadAngles,CurrentAngle)
    global angles CurrentAngle
    [FileName PathName] = uigetfile('*.mat');
    load([PathName FileName])
    open angles
    CurrentAngle = size(angles,1)+1;
end

function LoadHD(btnLoadHD,ax,sld)
    global vidHD
    [File Path] = uigetfile('.MOV');
    vidHD = VideoReader([Path File]);
    imHD = read(vidHD,floor(sld.Value*15));
    imshow(imHD,'Parent',ax)
end

function SplitTrack(btnSplitTrack,Tracks,CurrentTrack,ddown);
    
    global Tracks CurrentTrack
    prompt = {'Split point:','Marking 1:','Marking 2:'};
    dlgtitle = 'Input';
    dims = [1 35];
    definput = {'1','j','j'};
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    SplitPoint = str2num(answer{1});
    NewLoc = length(Tracks.Marking)+1;
    tempX = cell2mat(Tracks.x(CurrentTrack));
    tempY = cell2mat(Tracks.y(CurrentTrack));
    tempT = cell2mat(Tracks.t(CurrentTrack));
    ind = find(tempT>=SplitPoint);
    Tracks.x(NewLoc) = {tempX(ind)};
    Tracks.y(NewLoc) = {tempY(ind)};
    Tracks.t(NewLoc) = {tempT(ind)};
    Tracks.L(NewLoc) = length(ind);
    if answer{3} == 'i'
        Tracks.Marking(NewLoc) = 0;
    else
        Tracks.Marking(NewLoc) = answer{3};
    end
    
    ind = find(tempT<SplitPoint);
    Tracks.x(CurrentTrack) = {tempX(ind)};
    Tracks.y(CurrentTrack) = {tempY(ind)};
    Tracks.t(CurrentTrack) = {tempT(ind)};
    Tracks.L(CurrentTrack) = length(ind);
    if answer{2} == 'i'
        Tracks.Marking(CurrentTrack) = 0;
    else
        Tracks.Marking(CurrentTrack) = answer{2};
    end
end

function SaveFile(btnSaveFile,Tracks,ImageParam,minTrackLength,TrackMateParam,File1,Path1);
    global Tracks
    uisave({'Tracks','ImageParam','minTrackLength','TrackMateParam'},File1)
    msgbox('Saved')
end

function ChangeMarking(btnChangeMarking,Tracks,CurrentTrack);
    global Tracks CurrentTrack
    answer = inputdlg('Change marking to (Jellyfish, Plate, surface Bag, Deep bag, dRifter, Gps bag i):','Change marking',[1 35],{'j'});
    if answer{1} == 'i'
        Tracks.Marking(CurrentTrack) = 0;
    else
        Tracks.Marking(CurrentTrack) = cell2mat(answer);
    end
end

function MergeTrack(btnMergeTrack,Tracks)
    global Tracks
    
    % Ask the user which tracks to merge
    prompt = {'1st track:','2nd Track:'};
    dlgtitle = 'Merge Tracks';
    dims = [1 25];
    definput = {'',''};
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    
    % Merging
    track1 = str2num(cell2mat(answer(1)));
    track2 = str2num(cell2mat(answer(2)));
    tempX1 = cell2mat(Tracks.x(track1));
    tempY1 = cell2mat(Tracks.y(track1));
    tempT1 = cell2mat(Tracks.t(track1));
    tempX2 = cell2mat(Tracks.x(track2));
    tempY2 = cell2mat(Tracks.y(track2));
    tempT2 = cell2mat(Tracks.t(track2));
    tempNaN = tempT1(end)+1:tempT2(1)-1;
    tempX3 = [tempX1 ; nan(length(tempNaN),1) ; tempX2];
    tempY3 = [tempY1 ; nan(length(tempNaN),1) ; tempY2];
    tempT3 = [tempT1 ; tempNaN' ; tempT2];
    Tracks.x(track1) = {tempX3};
    Tracks.y(track1) = {tempY3};
    Tracks.t(track1) = {tempT3};
    Tracks.L(track1) = length(tempT3);
    Tracks.Marking(track2) = 106;
    msgbox('Tracks merged, remember to save the file.')


end

function updateImage(sld,ax,mvi,tempX,tempY,spn,CurrentTrack,tempMarking)
    global tempT tempX tempY CurrentTrack
    cla(ax);
    title(ax,['Track: ' num2str(CurrentTrack) ' Frame: ' num2str(floor(sld.Value)) '/' num2str(mvi.NumberOfFrames) ' Marking: ' char(tempMarking)])
    sld.Value
    im = read(mvi,floor(sld.Value));
    imshow(im,'Parent',ax)
    hold(ax,'on')
    plotLoc = find(min(abs(sld.Value - tempT)) == abs((sld.Value - tempT)));
    plot(tempX(1:plotLoc),tempY(1:plotLoc),'y','Parent',ax)
    plot(tempX(plotLoc),tempY(plotLoc),'oy','Parent',ax)
    hold(ax,'off')
    spn.Value = floor(sld.Value);
end

% update the plotting if it works on the previous function
function updateSlider(sld,ax,mvi,tempX,tempY,spn,CurrentTrack,tempMarking)
    global tempT tempX tempY CurrentTrack
    cla(ax);
    title(ax,['Track: ' num2str(CurrentTrack) ' Frame: ' num2str(floor(sld.Value)) ' Marking: ' char(tempMarking)])
    im = read(mvi,floor(spn.Value));
    imshow(im,'Parent',ax)
    hold(ax,'on')
    plotLoc = find(min(abs(sld.Value - tempT)) == abs((sld.Value - tempT)));
    plot(tempX(1:plotLoc),tempY(1:plotLoc),'y','Parent',ax)
    plot(tempX(plotLoc),tempY(plotLoc),'oy','Parent',ax)
    hold(ax,'off')
    sld.Value = spn.Value;
end

function chooseTrack(btnChooseTrack,lTracks,sld,Tracks)
    global Tracks
    answer = inputdlg(['Enter Track number (1-' num2str(lTracks) '):'],'Track Number',[1 35],{'1'});
    n = str2num(char(answer));
    global tempT tempX tempY CurrentTrack
    tempT = cell2mat(Tracks.t(n));
    tempX = cell2mat(Tracks.x(n));
    tempY = cell2mat(Tracks.y(n));
    sld.Limits = [tempT(1)+1 tempT(end)+1];
    CurrentTrack = n;
end

function chooseTrackddown(ddown,lTracks,sld,Tracks)
    global Tracks
%     answer = inputdlg(['Enter Track number (1-' num2str(lTracks) '):'],'Track Number',[1 35],{'1'});
%     n = str2num(char(answer));
    n = str2num(ddown.Value);
    global tempT tempX tempY CurrentTrack
    tempT = cell2mat(Tracks.t(n));
    tempX = cell2mat(Tracks.x(n));
    tempY = cell2mat(Tracks.y(n));
    sld.Limits = [tempT(1)+1 tempT(end)+1];
    CurrentTrack = str2num(ddown.Value);
end

function AddComment(btnChooseTrack,sld,Tracks,CurrentTrack,comInd,comments)
    global CurrentTrack comInd comments
    prompt = {'Enter Track:','Enter Frame:','Enter Comment:'};
    dlgtitle = 'Enter comment for a track';
    dims = [1 35];
    definput = {num2str(CurrentTrack), num2str(floor(sld.Value)),''};
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    comments.comTrack(comInd) = answer(1);
    comments.comFrame(comInd) = answer(2);
    comments.comComment(comInd) = answer(3);
    comInd = comInd + 1
end

function SaveComments(btnChooseTrack,comments)
    global comments
    uisave('comments')
end

function ShowScatter(btnShowScatter,Tracks,textShowScatter,mvi,ax,anglesLoaded)
    global Tracks anglesLoaded
    Frame = str2num(cell2mat(textShowScatter.Value));
    im = read(mvi,Frame);
    imshow(im,'Parent',ax)
    hold(ax,'on')
    title(ax,['Frame: ' num2str(Frame)])
    for i=1:size(Tracks,1)
        tt = cell2mat(Tracks.t(i));
        if Frame <= tt(end) & Frame >= tt(1) %sum(tt + ones(length(tt),1) == repmat(Frame,length(tt),1)) == 1
            ind = find(tt + ones(length(tt),1) == repmat(Frame,length(tt),1));
            if sum(ind) == 0
                ind1 = 1:length(tt);
                locmin = abs(tt - repmat(Frame,length(tt),1)) == min(abs(tt - repmat(Frame,length(tt),1)));
                ind2 = tt - repmat(Frame,length(tt),1);
                locmin = (min(ind2(1:end-1).*(ind2(2:end))) == ind2(1:end-1).*(ind2(2:end)));
                ind2 = ind1(locmin);
                ind = ind2(1);
            end
            tx = cell2mat(Tracks.x(i));
            ty = cell2mat(Tracks.y(i));
            if anglesLoaded
                txSmt = cell2mat(Tracks.xSmt(i));
                tySmt = cell2mat(Tracks.ySmt(i));
                ttSmt = cell2mat(Tracks.tSmt(i));
                tAngles = cell2mat(Tracks.Angle(i));
            end
            Mark = Tracks.Marking(i);
%             indiff = 1:length(tt)-1;
%             difft = diff(tt) > 10; % location of gaps > 10
            if Mark == 0
                plot(tx(ind),ty(ind),'oy','Parent',ax);
                text(tx(ind),ty(ind)+8,num2str(i),'Parent',ax)
                
            elseif Mark == 112 % plate
                plot(tx(ind),ty(ind),'or','Parent',ax);
                plot(tx(1:ind),ty(1:ind),'r','Parent',ax);
                text(tx(ind),ty(ind)+8,num2str(i),'Parent',ax)

            elseif Mark == 106 % Jellyfish
                plot(tx(ind),ty(ind),'ok','Parent',ax);
                plot(tx(1:ind),ty(1:ind),'k','Parent',ax);
                text(tx(ind),ty(ind)+8,num2str(i),'Parent',ax)
                % Show moving average and angles
                if anglesLoaded
                    % Plotting moving average
                    smtind = find(ttSmt==tt(ind));
                    plot(txSmt(smtind),tySmt(smtind),'ow','Parent',ax);
                    plot(txSmt(1:smtind),tySmt(1:smtind),'--w','Parent',ax);
                    % Plotting angles
                    if sum(not(isnan(cell2mat(Tracks.Angle(i))))) ~= 0 
                        tAng = cell2mat(Tracks.Angle(i));
                        whereAng = find(not(isnan(tAng)));
                        for k = 1:length(whereAng)
                            text(txSmt(whereAng(k)),tySmt(whereAng(k)),'\bf\rightarrow','color','y','FontSize',12,'Rotation',floor(tAng(whereAng(k))),'Parent',ax);
                        end
                    end
                end
                
            elseif Mark == 98 % Surface Bag
                plot(tx(ind),ty(ind),'ow','Parent',ax);
                plot(tx(1:ind),ty(1:ind),'w','Parent',ax);
                text(tx(ind),ty(ind)+8,num2str(i),'Parent',ax)

            elseif Mark == 100 % Deep bag
                plot(tx(ind),ty(ind),'og','Parent',ax);
                plot(tx(1:ind),ty(1:ind),'g','Parent',ax);
                text(tx(ind),ty(ind)+8,num2str(i),'Parent',ax)
            
            elseif Mark == 114 % Drifter
                plot(tx(ind),ty(ind),'ob','Parent',ax);
                plot(tx(1:ind),ty(1:ind),'b','Parent',ax);
                text(tx(ind),ty(ind)+8,num2str(i),'Parent',ax)
                
            elseif Mark == 103 % GPS bag - magenta
                plot(tx(ind),ty(ind),'om','Parent',ax);
                plot(tx(1:ind),ty(1:ind),'m','Parent',ax);
                text(tx(ind),ty(ind)+8,num2str(i),'Parent',ax)

            end
        end
            % In case there are marked angles in the file
%             if anglesLoaded
        end
    end


