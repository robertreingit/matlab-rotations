classdef AxisAngleTest < matlab.unittest.TestCase
    
    methods(Test)
        
        function testAngle(testCase)
           
            angle = pi/3;
            axis = [1 0 0]';
            R1 = rotX(angle);            
            [ax,an] = get_axis_angle(R1);
            testCase.verifyEqual(ax,axis);
            testCase.verifyEqual(an,angle);
            
            angle = -pi/7;
            R2 = rotX(angle);
            [ax,an] = get_axis_angle(R2);
            if ( abs(ax'*axis+1) < eps )
                ax = -1*ax;
                an = -1*an;
            end
            testCase.verifyTrue(all(abs(ax-axis)<eps));
            testCase.verifyTrue(abs(an-angle)<eps);
            
        end
        
    end % public Test methods
    
end % AxisAngleTest