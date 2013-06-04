function env = add_globals(env)

vars = {
    
    % Trigonometry / floating point
    'sin'   @sin
    'cos'   @cos
    'tan'   @tan
    'sinh'  @sinh
    'cosh'  @cosh
    'tanh'  @tanh
    'asin'  @asin
    'acos'  @acos
    'atan'  @atan
    'atan2' @atan2
    'sqrt'  @sqrt
    'log'   @log
    'log2'  @log2
    'log10' @log10
    'exp'   @exp
    
    % Booleans
    't'     true
    'f'     false
    'not'   @not
    'and'   @and
    'or'    @or
    'xor'   @xor
    
    % Arithmetic
    '+'     @plus
    '-'     @minus
    '*'     @times
    '/'     @rdivide
    'mod'   @mod
    'rem'   @rem
    'pow'   @power
    'abs'   @abs
    
    % Comparison operators
    '<'     @lt
    '>'     @gt
    '<='    @le
    '>='    @ge
    '=='    @eq
    
    % List manipulation
    'nil'   {}
    'car'   @(x)x{1}
    'cdr'   @(x)x(2:end)
    'cons'  @(h,t) [h,t]
    'list?' @iscell
    'sym?'  @ischar
    'null?' @isempty
    'list'  @(varargin)varargin
    'append'    @horzcat
    'length'    @length
    
    };
    
for ii = 1:length(vars)
    env(vars{ii,1}) = vars{ii,2};
end