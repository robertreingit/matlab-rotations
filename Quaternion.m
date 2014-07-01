classdef Quaternion
    % Quaternion
    % A simple Quaternion class which implements some
    % functionality used with Quaternions.

    properties(Access=protected)
        par = zeros(4,1);
    end % public properties
    
    methods
        
        function obj = Quaternion(p)
        %Quaternion c'tor
        %
        % INPUT:
        % p = parameter either
        %       1) scalar e R
        %       2) vector e R^3
        %       3) vector e R^4
        % OUTPUT:
        % obj = 1) obj.par = [s 0 0 0]'
        %       2) pure quaternion obj.par = [0 p(1) p(2) p(3)]'
        %       3) quaternion obj.par = [p(1) p(2) p(3) p(4)]'
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
            switch numel(p)
                case 1
                    obj.par(1) = p;
                case 3
                    obj.par(2:4) = p;
                case 4
                    if isrow(p)
                        p = p';
                    end
                    obj.par = p;
                otherwise
                    error('Quaternion can have only four entries.');
            end
        end
        
        function p = para(obj)
        % parameter Returns Quaternion parameters
        % Mainly for debugging.
        % INPUT:
        % obj = Quaternion object
        % OUTPUT:
        % p = parameters e R^4
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            p = obj.par;
        end
        
        function b = eq(obj,other)
        % eq Equality operator
        % b = obj == other
        % INPUT:
        % obj = Quaternion object
        % other = Quaternion object
        % OUTPUT:
        % b = boolean
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           b = all(obj.par == other.par); 
        end
        
        function obj = plus(obj,other)
        % addition operator
        % INPUT:
        % this = Quaternion object
        % other = Quaternion object
        % OUTPUT:
        % obj = Quaternion object
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.par = obj.par + other.par;
        end
        
        function obj = minus(obj,other)
        % minus subtraction
        % obj = obj - other
        % INPUT:
        % obj = Quaternion object
        % other = Quaternion object
        % OUTPUT:
        % obj = Quaternion object
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.par = obj.par - other.par;
        end
        
        function obj = mtimes(obj,other)
        % mtimes quaternion product
        % If other is a quaternion than the quaternion product is
        % calculated. If other is scalar than parameters are multiplied
        % by other.
        % obj = obj * other
        % INPUT:
        % obj = Quaternion object
        % other = other Quaternion object or scalar
        % OUTPUT:
        % obj = Quaternion object
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            bQ1 = isa(obj,'Quaternion');
            bQ2 = isa(other,'Quaternion');
            
            if bQ1 && bQ2
                tmp = zeros(4,1);
                tmp(1) = obj.par(1)*other.par(1) - ...
                   obj.par(2:4)'*other.par(2:4);
                tmp(2:4) = obj.par(1) * other.par(2:4) + ...
                   other.par(1) * obj.par(2:4) + ...
                   cross(obj.par(2:4),other.par(2:4));
                obj.par = tmp;
            elseif bQ1
                obj.par = obj.par * other;
            else
                other.par = obj * other.par;
                obj = other;
            end
        end
        
        function obj = conj(obj)
        % conj complex conjugate
        % INPUT:
        % obj = Quaternion object
        % OUTPUT:
        % obj = complex conjugate of obj
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.par(2:4) = -obj.par(2:4);
        end
        
        function obj = ctranspose(obj)
        % ctranspose complex conjugate operator short-cut
        % INPUT:
        % obj = Quaternion object
        % OUTPUT:
        % obj = transpose of obj
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj = obj.conj();
        end % complex conjugate
        
        function val = norm(obj)
        % norm norm of quaternion
        % INPUT:
        % obj = Quaternion object
        % OUTPUT:
        % val = norm of obj
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            val = norm(obj.par);
        end
        
        function obj = inv(obj)
        % inv inverse operator
        % INPUT:
        % obj = Quaternion object
        % OUTPUT:
        % obj = inverse of obj
        % SIDEEFFECTS:
        % None.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj = obj.conj();
            obj.par = obj.par/sum(obj.par.^2);
        end
        
        function display(obj)
        % display function
        % INPUT:
        % obj = Quaternion object
        % OUTPUT:
        % None.
        % SIDEEFFECTS:
        % Display content on cmd line.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            fprintf('(%.2f,%.2f,%.2f,%.2f)\n', obj.par);
            
        end % public display function
        
    end % public methods
    
    methods(Static=true)
        function obj = Identity()
           obj = Quaternion(1); 
        end
    end % public static methods
    
end % Quaternion
