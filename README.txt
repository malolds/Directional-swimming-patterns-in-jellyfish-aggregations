The list below describes the scripts used for data gathering from the orignal videos (trajectories and body orientation angles), and data analysis. The scripts are listed by their directories. Please contact Dr. Yoav Lehahn at ylehahn@univ.haifa.ac.il if you require examples of data to run on this code.

Trajectory_Creation_and_Filtering Direcctory
--------------------------------------------

These scripts are used to manipulate the original videos (conversion to HSV, manipulating contrast and brightness, downsampling from 60/30Hz to 2Hz) before the use of trackate, and filtration and quality control of the output from Trackmate. These scripts are used in order of the description below.

1. ImageTesting - Here some manipulation is done on the images to improve TrackMate performence (e.g. brightness, cotrast changes). This script is used to determine the parameters of image manipulation.
2. SaveVideoAsImages - After determining the parameters, the video is manipulated and downsampled. 
3. CreateMovie - creates an avi movie from a sequence of serially numbered images (i.e. file names image_001.jpg -> image_999.jpg). Images created in the previous script are converted into a video here.
4. importTrackMateTracks - taken from https://github.com/trackmate-sc/TrackMate/tree/master.
Used to import the TrackMate output into matlab format.
5. FilteringTracks - used after Trackmate to filter errornous tracks.
6. QualityCheckGUI_v7 - A simple gui to determine errornous tracks. Used after TrackMate. Steps 5 and 6 are repeated in an iterative manner until errornous tracks a completely eliminated.

Manual_Angle_Marking
--------------------

A simple GUI used to mark the angles of jellyfish manually. The GUI is run using AMI_v2.m, all the other scripts are functions used by the main script.

Data_Anlysis
------------

1. statisticsDirections - Script used to run statistical analysis of results, DataConcentrationTable_24-Feb-2023.mat
2. meancirc - script used to calculate mean and standard devation for circular data.
3. MagneticField - from https://www.mathworks.com/help/aerotbx/ug/wrldmagm.html#d124e113059. Used to calculate the magnetic field direction at a given date, time and location.
4. SunDirection - From https://www.mathworks.com/matlabcentral/fileexchange/83453-sun-position-algorithm. used to calculate the location of the sun at a given date, time and location. uses scripts in SunPosition folder.