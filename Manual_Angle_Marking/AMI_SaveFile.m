function [] = AMI_SaveFile(btnSaveFile,Tracks,ImageParam,minTrackLength,TrackMateParam,File1,Path1)
    global Tracks
    NameLoc = find(File1 == '_');
    
    % Ask for user name
    prompt = {'Please enter your FULL name:'};
    dlgtitle = 'Input';
    dims = [1 35];
    definput = {'Omri Tal'};
    answer = inputdlg(prompt,dlgtitle,dims,definput)
    UserNameAngles = answer{1};

    
    uisave({'Tracks','ImageParam','minTrackLength','TrackMateParam','UserNameAngles'},[Path1 File1(1:NameLoc(end)) 'Angles.mat'])
end