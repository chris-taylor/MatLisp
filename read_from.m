function out = read_from(tokens)
% Read an expression from a sequence of tokens.
%
%   read_from :: java.util.LinkedList -> atom
%
if tokens.isEmpty
    error('lisp:read_from:SyntaxError', 'Unexpected EOF while reading');
end
token = tokens.pop;
if strcmp(token, '(')
    out = {};
    while ~strcmp(tokens.peek, ')')
        out{end+1} = read_from(tokens); %#ok<AGROW>
    end
    tokens.pop; % pop off ')'
elseif strcmp(token, ')')
    error('lisp:read_from:SyntaxError', 'Unexpected )');
else
    out = atom(token);
end

function atom = atom(token)
% Numbers are converted to constants, other variables are returned as is.
atom = str2num(token); %#ok
if isempty(atom)
    atom = token;
end