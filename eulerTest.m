classdef eulerTest < matlab.unittest.TestCase
    
    methods(Test)
        
        function testEuler2RM(testCase)
           
            R_org = eye(3);
            R_calc = euler2RM(0,0,0);
            testCase.verifyTrue(compareMatricesEPS(R_org,R_calc,10));
            
            angle = 0.345;
            R_org = rotX(angle);
            R_calc = euler2RM(0,0,angle);
            testCase.verifyTrue(compareMatricesEPS(R_org,R_calc,10));
            
            angle = -1.23456;
            R_org = rotX(angle);
            R_calc = euler2RM(0,0,angle);
            testCase.verifyTrue(compareMatricesEPS(R_org,R_calc,10));
            
            angle = 0.9876;
            R_org = rotY(angle);
            R_calc = euler2RM(0,angle,0);
            testCase.verifyTrue(compareMatricesEPS(R_org,R_calc,10));
            angle = -1.23456;
            R_org = rotY(angle);
            R_calc = euler2RM(0,angle,0);
            testCase.verifyTrue(compareMatricesEPS(R_org,R_calc,10));
            
            angle = -1.0203;
            R_org = rotZ(angle);
            R_calc = euler2RM(angle,0,0);
            testCase.verifyTrue(compareMatricesEPS(R_org,R_calc,10));
            angle = 0.123456;
            R_org = rotZ(angle);
            R_calc = euler2RM(angle,0,0);
            testCase.verifyTrue(compareMatricesEPS(R_org,R_calc,10));
            
            angle = [1.23, 0.123, 0.345];
            R_org = rotX(angle(3))*rotY(angle(2))*rotZ(angle(1));
            R_calc = euler2RM(angle);
            testCase.verifyTrue(compareMatricesEPS(R_org,R_calc,10));
            
        end
        
        function testRM2euler(testCase)
           
            angle_org = [1.23, 0.123, 0.345];
            R = rotX(angle_org(3))*rotY(angle_org(2))*rotZ(angle_org(1));
            angle_calc = RM2euler(R);
            testCase.verifyTrue(all(abs(angle_org-angle_calc)<eps));
            
            angle_org = [1.23, -0.123, 0.345];
            R = rotX(angle_org(3))*rotY(angle_org(2))*rotZ(angle_org(1));
            angle_calc = RM2euler(R);
            testCase.verifyTrue(all(abs(angle_org-angle_calc)<eps));
            
            angle_org = [-1.23, -1.123, pi/2-eps];
            R = rotX(angle_org(3))*rotY(angle_org(2))*rotZ(angle_org(1));
            angle_calc = RM2euler(R);
            testCase.verifyTrue(all(abs(angle_org-angle_calc)<eps));
            
        end
        
        
    end % publc test Methods
    
end % eulerTest

function b = compareMatricesEPS(R1,R2,factor)
    if nargin == 2
        factor = 1;
    end

    b = all(all(abs(R1-R2)<factor*eps));
end