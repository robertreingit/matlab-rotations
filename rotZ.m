function R = rotZ(psi)
% rotZ rotation around Z-Axis
% Gives the coordinates of the fixed vector v1 when 
% the coordinates systems CS is rotated around Z by angle psi.
% v2 = R * v1;
% global to local, Point fixed - frame rotates
% Kuiper, JB (1999), p.49, eq. 3.1
%
% INPUT:
% psi = rotation angle in radiants
% OUTPUT:
% R = rotation matrix e SO(3)
% SIDEEFFECTS:
% None.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R = zeros(3);
R(1,1) = cos(psi);
R(1,2) = sin(psi);
R(2,1) = -sin(psi);
R(2,2) = cos(psi);
R(3,3) = 1;
