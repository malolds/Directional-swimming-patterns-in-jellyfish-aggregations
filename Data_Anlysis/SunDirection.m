function [SP] = SunDirection(TS,Lat,Long)
    
    % Add the path of the sub position algorihm
    addpath('D:\Jellyfish swarm\00_Manuscript\01_Figures\01_Database_creation\02_Functions\SunPosition')
%     TS = [2020 6 24 7 50 0]; Lat = 32.848686; Long = 34.9461;
    SP = sunpos(TS,Lat,Long);

end
% Aristides Bonanos (2023). Sun Position Algorithm (https://www.mathworks.com/matlabcentral/fileexchange/83453-sun-position-algorithm), MATLAB Central File Exchange. Retrieved January 31, 2023.