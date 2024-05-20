%% Table Re-formatting
function RFTracks = AMI_TableReformatting(Tracks)

% This function re-formats the Jellyfish Tracking file to allow for angle
% data to be incorporated.
% 
        lTracks = size(Tracks,1);
        SmtSpan = 100; % Default span for interpolation
        for i=1:lTracks
            tempX = cell2mat(Tracks.x(i));
            tempY = cell2mat(Tracks.y(i));
            tempT = cell2mat(Tracks.t(i));
            % Interpolation
            intT = tempT(1):tempT(end);
            intX = interp1(tempT,tempX,intT);
            intY = interp1(tempT,tempY,intT);
            Tracks.xInt(i) = {intX'};
            Tracks.yInt(i) = {intY'};
            Tracks.tInt(i) = {intT'};
            % Smoothening
            smtT = intT;
            smtX = smooth(intX,SmtSpan);
            smtY = smooth(intY,SmtSpan);
            Tracks.xSmt(i) = {smtX};
            Tracks.ySmt(i) = {smtY};
            Tracks.tSmt(i) = {smtT'};
            % Create angles place holders
            Tracks.Angles(i) = {NaN(length(smtT),1)};
        end
        RFTracks = Tracks;
end