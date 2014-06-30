classdef UnitQuaternion < Quaternion
    % Simple UnitQuaternion class which implements some operations
    % usefull when working with 3D rotations.

    properties
        angle = [];
        axis = [];
    end % public properties
    
    methods
        
        function obj = UnitQuaternion(arg1,arg2)
        % UnitQuatnernion c'tor
        %
        % INPUT:
        % 1) arg1 = vector e R^4 which is being normalized
        % 2) arg1 = axis vector e R^3
        %    arg2 = double of rotation angle
        % OUTPUT:
        % obj = initialized UnitQuaternion object
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            switch nargin
                case 1
                    assert(numel(arg1)==4,'4-Tupel vector needed with single argument');
                    % normalize to unit length
                    if abs(norm(arg1)-1)>eps
                        arg1 = arg1 / norm(arg1);
                    end
                    par = arg1;
                    tmp_angle = 2*acos(par(1));
                    tmp_axis = par(2:4)/norm(par(2:4));
                    
                case 2
                    assert(numel(arg1)==3,'Rotation axis as 1st argument needed.');
                    assert(numel(arg2)==1,'Rotation angle needed as 2nd argument.');
                    
                    % re-normalize in case
                    if abs(norm(arg1)-1) > eps
                        arg1 = arg1/norm(arg1);
                    end
                    if isrow(arg1)
                        arg1 = arg1';
                    end
                    tmp_axis = arg1;
                    
                    tmp_angle = arg2/2;                    
                    par = [cos(tmp_angle);tmp_axis*sin(tmp_angle)];
                    
                otherwise
                    error('UnitQuaternion c''tor works only with 1 or 2 arguments');
            end
            % Call superclass constructor
            obj = obj@Quaternion(par);
            obj.axis = tmp_axis;
            obj.angle = tmp_angle;
            
        end % UnitQuaternion c'tor
        
        function w = le(v,obj)
        % less than overloaded to quaternion operator
        % Applies the Quaternion operator to 
        % the vector v and rotating therefore the vector.
        % ==> w = obj * v * obj'
        % Kuiper p.124
        % INPUT:
        % v = vector e R^3
        % obj = UnitQuaternion e SO(3)
        % OUTPUT:
        % w = vector e R^3 obj*v*obj'
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            w = (2*obj.par(1)^2 - 1 ) * v + ...
                2*(obj.par(2:4)'*v)*obj.par(2:4) + ...
                2 * obj.par(1) * cross(obj.par(2:4),v);
            
        end % public le function
        
        function mat = toMatrix(obj)
        % toMatrix
        % Calculates the rotation matrix belonging to Quaternion.
        % Kuiper p. 126
        % INPUT:
        % obj = UnitQuaternion object
        % OUTPUT:
        % mat = rotation matrix e SO(3)
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
            mat = zeros(3);
            q_sqr = obj.par.^2;
            q12 = obj.par(2)*obj.par(3);
            q13 = obj.par(2)*obj.par(4);
            q01 = obj.par(1)*obj.par(2);
            q02 = obj.par(1)*obj.par(3);
            q03 = obj.par(1)*obj.par(4);
            q23 = obj.par(3)*obj.par(4);
            
            mat(1,1) = 2*q_sqr(1) - 1 + 2*q_sqr(2);
            mat(1,2) = 2*q12 + 2*q03;
            mat(1,3) = 2*q13 - 2*q02;
            mat(2,1) = 2*q12 - 2*q03;
            mat(2,2) = 2*q_sqr(1) - 1 + 2*q_sqr(3);
            mat(2,3) = 2*q23 + 2*q01;
            mat(3,1) = 2*q13 + 2*q02;
            mat(3,2) = 2*q23 - 2*q01;
            mat(3,3) = 2*q_sqr(1) - 1 + 2*q_sqr(4);
            
        end
        
        function obj = slerp(obj,other,t)
        % slerp
        % Spherical linear interpolation
        % INPUT:
        % OUTPUT:
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            dot = obj.par'*other.par;
            if dot > 1
                dot = 1;
            elseif dot < -1
                dot = -1;
            end
            omega = acos(dot);
            obj = obj*sin((1-t)*omega) + other*sin(t*omega);
            obj = obj * (1/ sin(omega));
            
        end
        
        function display(obj)
            
            fprintf('Unit Quaternion\n');
            display@Quaternion(obj);
            fprintf('angle: %.2f, axis: (%.2f,%.2f,%.2f)\n', ...
                360*obj.angle/pi, ...
                obj.axis);
            
        end % public display function
        
    end % public methods
    
    methods(Static=true)
        
        function obj = fromRotMat(R)
        % fromRotMat
        % Calculates a UnitQuaternion from the rotation matrix R.
        % Relies on the get_axi_angle.m function
        % INPUT:
        % mat = rotation matrix e SO(3)
        % OUTPUT:
        % obj = UnitQuaternion
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
            [ax,an] = get_axis_angle(R);
            obj = UnitQuaternion(ax,an);
            
        end % public static fromRotMat
        
    end % public Static methods
    
end % UnitQuaternion
