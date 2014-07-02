function R = rotX(phi)
% rotX rotation around X-axis
% Gives the coordinates of the fixed vector v1 when 
% the coordinates systems CS is rotated around X by angle phi.
% v2 = R * v1;
% global to local, Point fixed - frame rotates
% Kuiper, JB (1999), p.51, eq. 3.3
%
% INPUT:
% phi = rotation angle in radiants
% OUTPUT:
% R = rotation matrix e SO(3)
% SIDEEFFECTS:
% None.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R = zeros(3);
R(1,1) = 1;
R(2,2) = cos(phi);
R(3,2) = -sin(phi);
R(2,3) = sin(phi);
R(3,3) = cos(phi);
