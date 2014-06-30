classdef QuaternionTest < matlab.unittest.TestCase
    
    methods(Test)
        
        function testOperators(testCase)
            
            % some random numbers
            p1 = linspace(-30.34,350,4);
            p2 = linspace(1,103.34,4);
            s = 0.87;
            
            q1 = Quaternion(p1);
            q2 = Quaternion(p2);
            
            testCase.verifyEqual(q1+q2,Quaternion(p1 + p2));
            testCase.verifyEqual(q1-q2,Quaternion(p1 - p2));
            testCase.verifyEqual(s * q1,Quaternion(s * p1));
            testCase.verifyEqual(q1 * s,Quaternion(s * p1));
            testCase.verifyEqual(q1.norm(), norm(p1));
            testCase.verifyTrue(norm(q1 * q1.inv() - Quaternion.Identity) < eps);
            
        end % testOperators
        
    end % public Test
    
end % QuaternionTest