function [] = AMI_CurateAngle(btnCurateAngle,AngleLine,spcsld,spcspn1,spcspn10,CurrentTrack,mvi,Tracks)
    
	
    
    global AngleLine % In order to reset the AngleLine
    global Tracks CurrentTrack % In order to modify the tracks table
    if AngleLine == 0
        errordlg('Please first mark an angle','Error')
        return
    end
    
    % Error for the case no track was chosen
    if isnan(CurrentTrack)
        errordlg('Please first choose a track to mark','Error')
        return
    end
    % Converting the AngleLine position to angles
    pos = AngleLine.Position;
    pos(:,2) = mvi.Height - pos(:,2); % Correction for invert image coordinates
    angRad = atan2((pos(2,2)-pos(1,2)),(pos(2,1)-pos(1,1)));    
    angDeg = rad2deg(atan2((pos(2,2)-pos(1,2)),(pos(2,1)-pos(1,1))));
    % Coverting angles to 0 to 360 format
    if angDeg < 0
        angDeg = angDeg + 360;
        angRad = angRad + 2*pi;
    end        
    
    % Saving the angle to the table

    tempAngles = cell2mat(Tracks.Angles(CurrentTrack));
    tempT = cell2mat(Tracks.tSmt(CurrentTrack));
    AngLoc = find(tempT + 1 == floor(spcsld.Value) + spcspn1.Value + spcspn10.Value);
    tempAngles(AngLoc) = angDeg;
    Tracks.Angles(CurrentTrack) = {tempAngles};
    AngleLine.Visible = 'off';
    AngleLine = 0; % resetting the Angle Line
    disp('-- Angle successfully curated! --');
    
    beep;
    pause(0.2);
    beep;
end