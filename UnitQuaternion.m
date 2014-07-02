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
                    tmp_angle = acos(par(1));
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
        
        function robj = mtimes(this,that)
        % mtimes quaternion product
        % Just passed the object to the mtimes@Quaternion for proper
        % Quaternion multiplication. Subsequently, if both objects are
        % UnitQuaternions the result is wrapped into a UnitQuaternion
        % object. Attention, the result is renormalized if necessary which
        % might lead to numerical problems.
        % INPUT:
        % this = Quaternion or scalar
        % that = Quaternion or scalar or vector e R^3
        % OUTPUT:
        % robj = Either Quaternion or UnitQuaternion
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
            if ~isa(that,'UnitQuaternion') && numel(that) == 3
                robj = that <= this;
                return;
            end
            
            tmp_obj = mtimes@Quaternion(this,that);
            
            if isa(this,'UnitQuaternion') && isa(that,'UnitQuaternion')
                robj = UnitQuaternion(tmp_obj.par);
            else
                robj = Quaternion(tmp_obj.par);
            end
            
        end
        
        function w = le(v,obj)
        % less than overloaded to quaternion operator
        % Applies the Quaternion operator to 
        % the vector v and rotating therefore the vector.
        % ==> w = obj * v * obj'
        % point rotation => frame fixed point rotates
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
        
        function obj = slerp(q1,q2,t)
        % slerp
        % Spherical linear interpolation
        % INPUT:
        % obj = Quaternion object
        % other = Quaternion object
        % t = interpolation parameter obj = 0 <= t <= 1 = other
        % OUTPUT:
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            dot = q1.par'*q2.par;
            if dot > 1
                dot = 1;
            elseif dot < -1
                dot = -1;
            end
            omega = acos(dot);
            tmp_par = q1.par*(sin((1-t)*omega)/sin(omega)) + ...
                q2.par*(sin(t*omega)/sin(omega));
            obj = UnitQuaternion(tmp_par);
            
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
        % Used the algorithm from
        % http://www.cs.ucr.edu/~vbz/resources/quatut.pdf, p.8
        % INPUT:
        % mat = rotation matrix e SO(3)
        % OUTPUT:
        % obj = UnitQuaternion
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
            %[ax,an] = get_axis_angle(R);
            %obj = UnitQuaternion(ax,an);
            
            function p = estimate_wxyz(R,x,y,z,XX,YY,ZZ)
                s = sqrt(R(XX,XX) - (R(YY,YY)+R(ZZ,ZZ)) + 1);
                p(x) = s * 0.5;
                s = 0.5 / s;
                p(y) = (R(XX,YY) + R(YY,XX)) * s;
                p(z) = (R(YY,XX) + R(XX,ZZ)) * s;
                p(1) = (R(ZZ,YY) - R(YY,ZZ)) * s;                
            end
            
            p = zeros(4,1);
            tr = trace(R);
            if ( tr > eps )
                s = sqrt(tr + 1);
                p(1) = s * 0.5;
                s = 0.5 / s;
                p(2) = (R(2,3) - R(3,2))*s;
                p(3) = (R(3,1) - R(1,3))*s;
                p(4) = (R(1,2) - R(2,1))*s;
            else
                [~,idx] = max(diag(R));
                switch idx
                    case 1
                        p = estimate_wxyz(R,2,3,4,1,2,3);
                    case 2
                        p = estimate_wxyz(R,3,4,2,2,3,1);
                    case 3
                        p = estimate_wxyz(R,4,2,3,3,1,2);
                end
            end
            obj = UnitQuaternion(p);
            
        end % public static fromRotMat
        
    end % public Static methods
    
end % UnitQuaternion
