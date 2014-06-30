function matr = euler2RM(az, el, ro)
% Calculates the Rotation matrix based on the euler angles
% The sequence is: Z-Y-X which is also the sequence
% of the input variables. Thus the matrix rotates the original
% coordinate system into matr by following the sequence.
% 
% INPUT:
% az is the angle of azimut (Z)
% el is the angles of elevation (Y)
% ro is the angle of rotation (X)
% az, el and ro are the Euler rotations in Z,Y,X order
%
% OUTPUT:
% Rotation matrix:
%
% SIDEEFFECTS
% None.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( 1 == nargin )
    ro = az(3);
    el = az(2);
    az = az(1);
end

cosaz = cos(az);
sinaz = sin(az);
sinel = sin(el);
cosel = cos(el);
cosro = cos(ro);
sinro = sin(ro);
matr = zeros(3,3);

matr(1,1) = cosaz*cosel;
matr(2,1) = cosaz*sinel*sinro-sinaz*cosro;
matr(3,1) = cosaz*sinel*cosro+sinaz*sinro;

matr(1,2) = sinaz*cosel;
matr(2,2) = sinaz*sinel*sinro+cosaz*cosro;
matr(3,2) = sinaz*sinel*cosro-cosaz*sinro;

matr(1,3) = -sinel;
matr(2,3) = cosel*sinro;
matr(3,3) = cosel*cosro;
