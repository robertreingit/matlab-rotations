function R = rotY(omega)
% rotY rotation Y-Axis
% Gives the coordinates of the fixed vector v1 when 
% the coordinates systems CS is rotated around Y by angle omega.
% v2 = R * v1;
% global to local, Point fixed - frame rotates
% Kuiper, JB (1999), p.50, eq. 3.3
%
% INPUT:
% omega = rotation angle in radiants
% OUTPUT:
% R = rotation matrix e SO(3)
% SIDEEFFECTS:
% None.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R = zeros(3);
R(1,1) = cos(omega);
R(3,1) = sin(omega);
R(2,2) = 1;
R(1,3) = -sin(omega);
R(3,3) = cos(omega);
