function out = lisp_eval(x, env)

global PRINT_TRACE

out = [];

if ischar(x)                            % variable reference
    out = env(x);
elseif ~iscell(x)                       % constant literal
    out = x;
elseif strcmp(car(x), 'quote')          % (quote exp)
    out = x{2};
elseif strcmp(car(x), 'if')             % (if test conseq alt)
    test   = x{2};
    conseq = x{3};
    alt    = x{4};
    t_val  = lisp_eval(test, env);      % ;; treat both nil and 0 as false
    if isempty(t_val) || ((isnumeric(t_val) || islogical(t_val)) && ~t_val)
        out = lisp_eval(alt, env);
    else
        out = lisp_eval(conseq, env);
    end
elseif strcmp(car(x), 'set!')           % (set! var exp)
    var = x{2};
    exp = x{3};
    if env.isKey(var)
        env(var) = lisp_eval(exp, env); %#ok
    else
        error('lisp_eval:KeyNotFound','Could not set var %s', var)
    end
elseif strcmp(car(x), 'define')         % (define var exp)
    var = x{2};
    exp = x{3};
    env(var) = lisp_eval(exp, env);     %#ok
elseif strcmp(car(x), 'lambda')         % (lambda (var*) exp)  
    vars = x{2};
    exp  = x{3};
    out  = @(varargin) lisp_eval(exp, extendenv(env,vars,varargin));
elseif strcmp(car(x), 'begin')          % (begin exp*)
    exps = cdr(x);
    for ii = 1:length(exps)
        out = lisp_eval(exps{ii}, env);
    end
else
    exps = cellfun(@(arg) lisp_eval(arg, env), x, 'UniformOutput', false);
    proc = car(exps);
    args = cdr(exps);
    out  = feval(proc, args{:});
    if PRINT_TRACE
        fprintf('*** applied function %s to arguments %s\n', strtrim(evalc('disp(proc)')), strtrim(evalc('disp(args)')))
    end
end

function y = car(x)
y = x{1};

function y = cdr(x)
y = x(2:end);

function newenv = extendenv(env,vars,args)
newenv = containers.Map(env.keys, env.values);
for ii = 1:length(vars)
    newenv(vars{ii}) = args{ii};
end