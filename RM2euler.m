function euler_angles = RM2euler(rmat)
% Calculates the euler angles from rotation matrix
% The rotation sequence is Z(azimuth)-Y(elevation)-X(roll)
% Thus, these angles are needed to rotate the stationary system into
% rmat.
% The function does not check whether rmat is a rotation matrix.
% INPUT:
% rmat  = Rotation matrix e SO(3)
% Output:
% euler_angles   = [azimuth,elevation,roll]
%#######################################################

el = -asin(rmat(1,3));
ro = atan2(rmat(2,3),rmat(3,3));
az = atan2(rmat(1,2),rmat(1,1));

euler_angles = [az,el,ro];
