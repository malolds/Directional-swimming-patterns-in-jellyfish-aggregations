function [mu sd] = meancirc(alpha)
% MEANCIRC Average and standard deviation of circular data (angles)
% [MU SD] = MEANCIRC(ALPHA)
% ALPHA - array of angles in degrees
% Mu - mean of angles
% SD - Standard deviation of angles
z = cosd(alpha) + sind(alpha)*1i;
meanz = mean(z);
R = abs(meanz);
sd = rad2deg(sqrt(-2*log(R)));
mu = rad2deg(angle(meanz));

end