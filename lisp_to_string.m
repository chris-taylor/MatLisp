function str = lisp_to_string(expr)
% Convert a cell array back into a readable string.
if iscell(expr)
    str = cellfun(@lisp_to_string, expr, 'UniformOutput', false);
    str = ['(' join(str) ')'];
elseif isnumeric(expr) || islogical(expr)
    str = num2str(expr);
elseif ischar(expr)
    str = expr;
elseif isa(expr,'function_handle')
    str = evalc('disp(expr)');
    str = str(5:end-1);
else
    error('lisp:lisp_to_string:UnrecognizedObject', 'Did not recognize class: %s', class(expr))
end

function result = join(args)
% Join strings with spaces
result = args{1};
for ii = 2:length(args)
    result = [result ' ' args{ii}]; %#ok<AGROW>
end