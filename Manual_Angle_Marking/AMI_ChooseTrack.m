function [] = AMI_ChooseTrack(btnChooseTrack,spcsld,spcspn1,spcspn10,Tracks)
    
    global CurrentTrack
    spcspn1.Value = 0;
    spcspn10.Value = 0;
    
    lTracks = size(Tracks,1);
    answer = inputdlg(['Enter Track number (1-' num2str(lTracks) '):'],'Track Number',[1 35],{'1'});
    n = str2num(char(answer));
    tempT = cell2mat(Tracks.t(n));
    tempX = cell2mat(Tracks.x(n));
    tempY = cell2mat(Tracks.y(n));
    Mark = Tracks.Marking(n);
    if Mark ~= 106
        errordlg('Chosen track is not a jellyfish track','Error');
        return
    end
    spcsld.Limits = [tempT(1)+1 tempT(end)+1];
    CurrentTrack = n;
end