%%
% Create movie sequence
% To change the video format adress line 8
% To change the input images format adress lines 17 and 36
% To change the output FrameRate adress line 10
%%
%Movie file name (created file)
[MovieFileName MoviePathName]=uiputfile('*.avi','Save Video As');
writerObj = VideoWriter([MoviePathName MovieFileName]);
writerObj.FrameRate = 2;
% writerObj.Quality = 100;

% writerObj.CompressionRatio= 1;
% writerObj.ColorChannels = 1;

open(writerObj);
[ImageFileName ImagePathName]=uigetfile('*.jpg','Choose First Image');
Frame_Count=cell2mat(inputdlg('Enter end Frame:','Input',1,cellstr('50')));
Wait_Bar = waitbar(0,'Creating Video File...');

for UnderLoc=length(ImageFileName):-1:1
    if ImageFileName(UnderLoc)=='.'
        DotLoc=UnderLoc;
    end
    if ImageFileName(UnderLoc)=='_'
        break
    end
end
NumofDigits=DotLoc-UnderLoc-1;
Start=ImageFileName(UnderLoc+1:DotLoc-1);
for i=str2num(Start):1:str2num(Frame_Count)
    ind=num2str(i);
    for m=numel(num2str(ind)):NumofDigits-1
            ind=['0' ind];
    end
    frame_name=[ImagePathName ImageFileName(1:UnderLoc) ind '.jpg'];
    im=imread(frame_name);
    im = im(:,:,:);
    %im=im2uint8(im);
    writeVideo(writerObj,im(:,:,:));
    waitbar((i-str2num(Start))/(str2num(Frame_Count)-str2num(Start)));
end
close(Wait_Bar);
close(writerObj);
msgbox('Video Ready!')
close all;