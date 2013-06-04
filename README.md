## MatLisp

Lisp interpreter in Matlab. Just because.

## Demo

    >> repl
    matlisp> (+ 1 2)
    3
    matlisp> (car (list 1 2 3))
    1
    matlisp> (define fact
    ...        (lambda (n)
    ...          (if (<= n 1)
    ...            1
    ...            (* n (fact (- n 1)))
    ...          )
    ...        )
    ...      )
    matlisp> (fact 10)
    3628800
    matlisp> 
