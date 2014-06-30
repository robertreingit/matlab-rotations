function Rf = eulerSeq(seq)
% eulerSeq Generates an Euler Sequence rotation matrix.
% The sequence describes the successive rotations around the
% sequence angles. For example to obtain the Aeorspace sequence:
% eulerSeq('zyx')
%
% INPUT:
% seq = Sequence of euler axis as strings {xyzXYZ} are allowed.
% OUTPUT:
% Rf   = Function handle to a rotation matrix function
% SIDEEFFECTS:
% None.
%%%%%%%%%%%%%%%%%%%%%%%%%%

seq_ids = regexp(lower(seq),'[xyzXYZ]','match');
if numel(seq) ~= 3 || numel(seq_ids) ~= numel(seq)
    error('Only {x(X), y(Y), z(Z)} are allowed as sequence identifiers. Got %s\n', seq);
end
fun_handles = cellfun(...
                    @str2func,...
                    regexprep(seq_ids,{'x','y','z'},{'rotX','rotY','rotZ'}),...
                    'Uniform',false);
Rf = @(x) fun_handles{3}(x(3)) * fun_handles{2}(x(2)) * fun_handles{1}(x(1));
