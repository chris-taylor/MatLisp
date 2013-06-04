function repl()
% Run the Matlisp repl. Currently has support for multi-line input
% and minimal error checking.

% Globals
global TRACE
global PROMPT
global LEN_PROMPT
global COL
global PAREN_CNT
global ALL_INPUT

PROMPT     = 'matlisp> ';
LEN_PROMPT = length(PROMPT);
TRACE      = false;
ALL_INPUT  = [];
COL        = 0;
PAREN_CNT  = 0;

% Increase recursion limit
set(0, 'RecursionLimit', 10000);

% Initial environment
env = add_globals(containers.Map);

% Read-eval-print loop
while true
    
    % Multi-line support
    if PAREN_CNT > 0
        DISPLAY = ['...' blanks(LEN_PROMPT - 3 + COL(end))];
    else
        DISPLAY = PROMPT;
    end
    
    % Get user input
    inp = strtrim(input(DISPLAY, 's'));
    
    % If input is empty, just print a blank line
    if isempty(inp)
        continue
    end
    
    % Check for keywords
    if strcmpi(inp,':quit') || strcmpi(inp,':q')
        return
    elseif strncmpi(inp,':set',4)
        words = regexp(inp, ':set\s+(\w+)\s+(.+)', 'tokens');
        name  = words{1}{1};
        val   = words{1}{2};
        setenv(name,val);
        continue
    end
    
    % Count parens (for multi-line input)
    lisp_count_parens(inp);
    
    % If there are open parens, use multi-line input
    if PAREN_CNT > 0
        continue
    end

    % Parse input
    try
        exp = lisp_read(ALL_INPUT);
        ALL_INPUT = [];
    catch err
        report(err, '*** parsing error ***')
        continue
    end

    % Evaluate
    try
        val = lisp_eval(exp,env);
    catch err
        report(err, '*** evaluation error ***')
        continue
    end

    % Display result
    try
        if ~isempty(val)
            disp(lisp_to_string(val));
        end
    catch err
        report(err, '*** display error ***')
        continue
    end
    
end

function report(err, type)
% Report errors.
disp(type)
disp(err.identifier)
disp(err.message)

function setenv(name,val)
% Set environment variables.
global TRACE PROMPT LEN_PROMPT
if strcmp(name, 'TRACE')
    TRACE = str2num(val); %#ok
elseif strcmp(name, 'PROMPT')
    PROMPT = val(val ~= '"');
    LEN_PROMPT = length(PROMPT);
end

function lisp_count_parens(s)
% Keeps track of the number of open parens and column of last open paren,
% for multi-line input.
global PAREN_CNT COL ALL_INPUT

ALL_INPUT = [ALL_INPUT ' ' s];

for i = 1:length(s)
    if s(i) == '('
        PAREN_CNT  = PAREN_CNT + 1;
        COL(end+1) = i + COL(end); %#ok<AGROW>
    elseif s(i) == ')'
        PAREN_CNT = PAREN_CNT - 1;
        COL(end)  = [];
    end
end