function [axis,angle] = get_axis_angle(R)
% get_axis_angle
% Calculates the rotation axis and the according rotation angle
% from a rotation matrix.
%
% INPUT:
% R = rotation matrix e SO(3)
% OUTPUT:
% angle = rotation angle in radiants
% SIDEEFFECTS:
% None.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    A = (R-R')/2;
    rho = -[A(3,2);A(1,3);A(2,1)];
    s = norm(rho);
    c = (trace(R)-1)/2;
    
    if abs(s)<eps && abs(c+1)<eps
        tmp = R + eye(3);
        idx = find(any(tmp),1);
        v = R(:,idx);
        axis = v / norm(v);
        angle = pi;
    else
        angle = atan2(s,c);
        axis = rho/s;
    end
    
end
