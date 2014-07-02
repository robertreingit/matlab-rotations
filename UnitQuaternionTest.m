classdef UnitQuaternionTest < matlab.unittest.TestCase
    
    methods(Test)
        
        function UnitQuatertionMulTest(testCase)
           
            q1 = UnitQuaternion([1 1 1],0.345);
            q2 = Quaternion(1:4);
            s = 35.43435343;
            testCase.verifyTrue(isa(q1*q1,'UnitQuaternion'));
            testCase.verifyTrue(isa(q1*q2,'Quaternion') && ~isa(q1*q2,'UnitQuaternion'));
            testCase.verifyTrue(~isa(q1*s,'UnitQuaternion') && isa(q1*s,'Quaternion'));
            testCase.verifyTrue(~isa(s*q1,'UnitQuaternion') && isa(s*q1,'Quaternion'));
            
        end
        
        function QuaternionOperatorTest(testCase)
            
            testFunc = @(v1,q1,v2) all(abs((v1<=q1)-v2)<10*eps);
            
            % rotate x-vector around z-axis by pi/2
            v = [1 0 0]';
            v_end = [0 1 0]';
            q = UnitQuaternion([0 0 1]',pi/2);            
            
            testCase.verifyTrue(abs(norm(v<=q)-norm(v))<eps);
            testCase.verifyTrue(testFunc(v,q,v_end));
            testCase.verifyTrue(all(abs(v_end-q*v)<10*eps));
            
            % rotate vector [1 1 1]' into x-z-plane          
            v = [1 1 1]';
            v_end = [1 0 sqrt(2)]';
            q = UnitQuaternion([1 0 0],pi/4);
            testCase.verifyTrue(abs(norm(v<=q)-norm(v))<10*eps);
            testCase.verifyTrue(testFunc(v,q,v_end));
            
            % testing operator sequences
            q1 = UnitQuaternion([1 0 0],pi/4);
            q2 = UnitQuaternion([1 0 0],pi/2);
            q_res = q1 * q1;
            testCase.verifyTrue(UnitQuaternionTest.compareQuaternionsEPS(q2,q_res));
            
            q1 = UnitQuaternion([0 1 0],pi/3);
            q2 = UnitQuaternion([0 1 0],2*pi/3);
            q_res = q1 * q1;
            testCase.verifyTrue(UnitQuaternionTest.compareQuaternionsEPS(q2,q_res));
            
            q1 = UnitQuaternion([0 0 1],0.8);
            q2 = UnitQuaternion([0 0 1],1.6);
            q_res = q1 * q1;
            testCase.verifyTrue(UnitQuaternionTest.compareQuaternionsEPS(q2,q_res));
            
        end
        
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
        
        function b = compareQuaternionsEPS(q1,q2,factor)
           if nargin == 2
               factor = 1;
           end
           
           b = all(abs(q1.wxyz() - q2.wxyz())<factor*eps);
        end
        
    end % private helper methods
    
end % UnitQuaternionTest
