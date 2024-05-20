function [] = AMI_UpdateImage(sld,ax,mvi,Tracks,cbx)
    global Tracks

    % Show chosen frame
    cla(ax);
    im = read(mvi,floor(sld.Value));
    imshow(im,'Parent',ax);
	hold(ax,'on')
    resetplotview(ax);
    
    % Change title of axes
    title(ax,['Frame: ' num2str(floor(sld.Value))])
    lTracks = size(Tracks,1); %Number of lines in the table
    for i=1:lTracks
        % Loading i-th track
        tempX = cell2mat(Tracks.x(i));
        tempY = cell2mat(Tracks.y(i));
        tempT = cell2mat(Tracks.t(i));
        tempMark = Tracks.Marking(i);
        tempXsmt = cell2mat(Tracks.xSmt(i));
        tempYsmt = cell2mat(Tracks.ySmt(i));
        tempTsmt = cell2mat(Tracks.tSmt(i));
        tempAngles = cell2mat(Tracks.Angles(i));
        relTrack = (tempMark == 106) && (floor(sld.Value) >= tempTsmt(1) && floor(sld.Value) <= tempTsmt(end));
        % Drawing Jellyfish Tracks
        if relTrack % If the track is a jellyfish track that is visible in the current frame
            drawLocScat = tempT <= floor(sld.Value);
            drawLocPlot = tempTsmt <= floor(sld.Value);
            drawLocLast = find(drawLocScat);
            % Scatter raw data
            if cbx.Raw.Value
                scatter(tempX(drawLocScat),tempY(drawLocScat),20,'.y','Parent',ax)
            end
            % Scatter current frame 
            scatter(tempX(drawLocLast(end)),tempY(drawLocLast(end)),50,'ok','Parent',ax);
            % Moving Average plot
            if cbx.Smt.Value
                plot(tempXsmt(drawLocPlot),tempYsmt(drawLocPlot),'Color','r','Parent',ax)
            end
            % Track number text
            text(tempX(drawLocLast(end)),tempY(drawLocLast(end))+10,num2str(i),'Parent',ax);
            % Draw angles if they exist
            if cbx.Ang.Value
                if sum(not(isnan(tempAngles(drawLocPlot)))) ~= 0
                    angLoc = find(not(isnan(tempAngles(drawLocPlot)))); % Location of angles
                    for j = 1:length(angLoc)
                        text(tempXsmt(angLoc(j)),tempYsmt(angLoc(j)),'\rightarrow','Parent',ax,'Rotation',tempAngles(angLoc(j)));
                    end
                end
            end
        end
    end
end