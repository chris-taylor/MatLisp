function expr = lisp_read(s)
expr = read_from(lisp_tokenize(s));