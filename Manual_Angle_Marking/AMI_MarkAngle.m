function AMI_MarkAngle(btnMarkAngles,ax);

    global AngleLine
    
    zoom(ax,'off');
    pan(ax,'off');
    AngleLine = drawline(ax,'LineWidth',1,'Color','y');
end