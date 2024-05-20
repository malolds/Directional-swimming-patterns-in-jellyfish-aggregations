
 function AMI_keyPressCallback(source,eventdata)

    
    % determine the key that was pressed
    global ax btnMarkAngles zoomIndicator cbx
    global btnCurateAngle AngleLine spcsld spcspn1 spcspn10 CurrentTrack mvi Tracks
    keyPressed = eventdata.Key;

    % Curate Angle
    if length(keyPressed) == 1 && keyPressed == 'w'
        AMI_CurateAngle(btnCurateAngle,AngleLine,spcsld,spcspn1,spcspn10,CurrentTrack,mvi,Tracks)
    end
    
    % Mark Angle
    if length(keyPressed) == 1 && keyPressed == 's'
        AMI_MarkAngle(btnMarkAngles,ax);
    end
    
    % Move one frame
    if length(keyPressed) == 1 && keyPressed == 'd'
        spcspn1.Value = spcspn1.Value + 1;
        AMI_UpdateImageTrack(spcsld,spcspn1,spcspn10,ax,mvi,Tracks,0,cbx,CurrentTrack)
    end
    if length(keyPressed) == 1 && keyPressed == 'a'
        spcspn1.Value = spcspn1.Value - 1;
        AMI_UpdateImageTrack(spcsld,spcspn1,spcspn10,ax,mvi,Tracks,0,cbx,CurrentTrack)
    end
    
    % Move 10 frames
    if length(keyPressed) == 1 && keyPressed == 'q'
        spcspn10.Value = spcspn10.Value - 10;
        AMI_UpdateImageTrack(spcsld,spcspn1,spcspn10,ax,mvi,Tracks,0,cbx,CurrentTrack) 
    end
    if length(keyPressed) == 1 && keyPressed == 'e'
        spcspn10.Value = spcspn10.Value + 10;
        AMI_UpdateImageTrack(spcsld,spcspn1,spcspn10,ax,mvi,Tracks,0,cbx,CurrentTrack) 
    end
    if length(keyPressed) == 1 && keyPressed == 'x'
        try
        AngleLine.Visible = 'off';
        AngleLine = 0;
        catch
        end
    end



end