function tokens = lisp_tokenize(str)
str = strrep(str, '(', ' ( ');
str = strrep(str, ')', ' ) ');
str = regexp(str, '\s+', 'split');
loc = cellfun(@isempty, str);
str(loc) = [];
tokens = java.util.LinkedList;
for ii = 1:length(str)
    tokens.add(str{ii});
end