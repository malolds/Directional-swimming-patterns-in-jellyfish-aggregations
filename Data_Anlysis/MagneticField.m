function [magVec,magHorInt,magDec,magInc,magTotInt] = MagneticField(height,latitude,longitude,decimalYear)
% MATLAB function - https://www.mathworks.com/help/aerotbx/ug/wrldmagm.html#d124e113059
    [magVec,magHorInt,magDec,magInc,magTotInt] = wrldmagm(height,latitude,longitude,decimalYear);

end