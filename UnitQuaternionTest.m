classdef UnitQuaternionTest < matlab.unittest.TestCase
    
    methods(Test)
        
        function toMatrixTest(testCase)
                       
            R = rotX(pi/7);
            q = UnitQuaternion([1 0 0],pi/7);
            R_calc = q.toMatrix();
            testCase.verifyTrue(UnitQuaternionTest.compareMatricesEPS(R,R_calc,10));
            
            R = rotX(-0.2);
            q = UnitQuaternion([1 0 0],-0.2);
            R_calc = q.toMatrix();
            testCase.verifyTrue(UnitQuaternionTest.compareMatricesEPS(R,R_calc,10));
            
            R = rotY(-pi/3);
            q = UnitQuaternion([0 1 0],-pi/3);
            R_calc = q.toMatrix();
            testCase.verifyTrue(UnitQuaternionTest.compareMatricesEPS(R,R_calc,10));
            
            R = rotZ(0.1);
            q = UnitQuaternion([0 0 1],0.1);
            R_calc = q.toMatrix();
            testCase.verifyTrue(UnitQuaternionTest.compareMatricesEPS(R,R_calc,10));
            
            R = rotZ(pi/2+0.5);
            q = UnitQuaternion([0 0 1],pi/2+0.5);
            R_calc = q.toMatrix();
            testCase.verifyTrue(UnitQuaternionTest.compareMatricesEPS(R,R_calc,10));
            
        end
        
        function fromMatrixTest(testCase)
           
            R = euler2RM(0.1,0.2,0.3);
            q = UnitQuaternion.fromRotMat(R);
            R_calc = q.toMatrix();
            testCase.verifyTrue(UnitQuaternionTest.compareMatricesEPS(R,R_calc,10));
            
        end
        
    end % public Test Methods
    
    methods(Static=true)
        
        function b = compareMatricesEPS(R1,R2,factor)
            if nargin == 2
                factor = 1;
            end
            
            b = all(all(abs(R1-R2)<factor*eps));
        end
        
    end % private helper methods
    
end % UnitQuaternionTest