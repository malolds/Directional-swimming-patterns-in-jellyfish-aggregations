function [] = AMI_UpdateImageTrack(sld,spcspn1,spcspn10,ax,mvi,Tracks,sldChng,cbx,CurrentTrack)
    
    global CurrentTrack Tracks
    
    if sldChng == 1 % Resets the spinner in the case the slider has changed and not the spinner
        spcspn1.Value = 0;
        spcspn10.Value = 0;
    end
    
    if isnan(CurrentTrack)
        errordlg('First choose a jellyfish track','Error');
        return
    end
    % Show chosen frame
    cla(ax)
    zoom(ax,'off')
    im = read(mvi,floor(sld.Value) + spcspn1.Value + spcspn10.Value);
    imshow(im,'Parent',ax);
	hold(ax,'on')
    
    % Change title of axes
    title(ax,['Frame: ' num2str(floor(sld.Value) + spcspn1.Value + spcspn10.Value) ' Track: ' num2str(CurrentTrack)])
    
    
    % Loading current track
    tempX = cell2mat(Tracks.x(CurrentTrack));
    tempY = cell2mat(Tracks.y(CurrentTrack));
    tempT = cell2mat(Tracks.t(CurrentTrack));
    tempMark = Tracks.Marking(CurrentTrack);
    tempXsmt = cell2mat(Tracks.xSmt(CurrentTrack));
    tempYsmt = cell2mat(Tracks.ySmt(CurrentTrack));
    tempTsmt = cell2mat(Tracks.tSmt(CurrentTrack));
    tempAngles = cell2mat(Tracks.Angles(CurrentTrack));
    drawLocScat = tempT <= floor(sld.Value + spcspn1.Value + spcspn10.Value);
    drawLocPlot = tempTsmt <= floor(sld.Value + spcspn1.Value + spcspn10.Value);
    drawLocLast = find(drawLocScat);
    % Scatter raw data
    if cbx.Raw.Value
        scatter(tempX(drawLocScat),tempY(drawLocScat),20,'.y','Parent',ax)
    end
    % Scatter current frame 
    scatter(tempX(drawLocLast(end)),tempY(drawLocLast(end)),50,'oy','Parent',ax);
    % Moving Average plot
    if cbx.Smt.Value
        plot(tempXsmt(drawLocPlot),tempYsmt(drawLocPlot),'Color','r','Parent',ax)
    end
    % Track number text
    text(tempX(drawLocLast(end)),tempY(drawLocLast(end))+10,num2str(CurrentTrack),'Parent',ax);
    % Drawing angles if possible
    if cbx.Ang.Value
        if sum(not(isnan(tempAngles))) ~= 0
            angLoc = find(not(isnan(tempAngles(drawLocPlot)))); % Location of angles
            for j = 1:length(angLoc)
                text(tempXsmt(angLoc(j)),tempYsmt(angLoc(j)),'\rightarrow','Parent',ax,'Rotation',tempAngles(angLoc(j)));
            end
        end
    end

end