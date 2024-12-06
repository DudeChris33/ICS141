;; A simple LISP interpreter written by Dr Klefstad for ICS 141 at UC Irvine.
;; Of course, I deleted lots of it to let you learn more about evaluation.
;; Note the new top-level function, my-top, is defined at the bottom of this file.

;; To run this, load this file into the lisp interpreter, then call
;; (my-top)
;; then type in expressions to be evaluated.

;; The homework assignment gives a list of good test cases
;; listed in order that you should probably implement thim in to ensure you
;; enough working to go on to the next test case.

;; We will use association lists, alists, for the stack of variables and
;; their values.  An alist is a list of this form:
;; ((var1 . val1) (var2 . val2) ... (varN . valN))
;; where each vari is a symbol representing a variable (or parameter) name
;; and each vali is the value of the variable.  assoc returns the association
;; of a given symbol, e.g,
;; (assoc 'myvar '((a . 10)(b a b c)(myvar d e f)))
;; returns (myvar d e f) and you take the cdr of that to get myvar's value
;; (d e f)

;; Assoc returns the association (binding) of a variable in the association
;; list. An association list may contain multiple definitions of a variable
;; with the same name, for example with parameters to a recursive function.
;; Assoc always finds the first association of a variable, and this is how we
;; implement dynamic scoping. 

;; As evaluation proceeds deeper into recursion, new variables are added onto
;; the front of the current association list.  New defintions of a variable 
;; will hide previously made definitions effectively hiding them from access.
;; The previously made definitions will come back into scope when
;; recursive evaluation unwinds.

;; We us a special global variable, called global-alist, for saving top-level
;; definitions made using defun or setq. Note the global-alist is passed in
;; to my-eval only in the call made by my-top defined below.

(DEFVAR GLOBAL-ALIST NIL) ; DONE BY PROF
;; to push a new value, (SETQ GLOBAL-ALIST (CONS (CONS 'NEWVAR 'NEWVAL) GLOBAL-ALIST))

(DEFUN MY-ASSOC (A ALIST)
	(COND
		((NULL ALIST)
			NIL
		)
		((EQUAL A (CAAR ALIST))
			(CONS A (CDAR ALIST))
		)
		(T
			(MY-ASSOC A (CDR ALIST))
		)
	)
)

(DEFUN MY-EVAL (E ALIST)
	(COND
		((ATOM E)
			(MY-EVAL-ATOM E ALIST)
		)
		(T
			(MY-APPLY (CAR E) (CDR E) ALIST)
		)
    )
)

(DEFUN MY-EVAL-ATOM (E ALIST)
	(COND
		((NULL E)
			NIL
		)
		((EQ T E)
			T
		)
		((NUMBERP E)
			E
		)
		((STRINGP E)
			E
		)
		((SYMBOLP E)
			(CDR (MY-ASSOC E GLOBAL-ALIST))
		)
		(T
			(MY-EVAL (CDR (MY-ASSOC E ALIST)) ALIST)
		)
	)
)

(DEFUN MY-APPLY (FN ARGS ALIST) ; DONE BY PROF
	(COND
		((ATOM FN)
			(MY-APPLY-ATOM FN ARGS ALIST)
		)
		(T
			(MY-APPLY-LAMBDA FN ARGS ALIST)
		)
	)
)

(DEFUN MY-APPLY-ATOM (FN ARGS ALIST)
	;; You need to write this one.  Handle the primitives as special cases, then
	;; handle user defined functions (defined via defun) in the default case.
	;; Handle car, cdr, cons, eq, quote, cond, defun, setq, eval, print, atom, null,
	;; listp, apply, equal, +, -, mod, floor and user defined functions (defined via defun).
	;; This should allow you to interpret your functions from HW4.
	(COND
		((EQ FN 'EQ) ; DONE BY PROF
			(EQ (MY-EVAL (CAR ARGS) ALIST) (MY-EVAL (CADR ARGS) ALIST))
		)
		((EQ FN 'CAR)
			(CAR (MY-EVAL (CAR ARGS) ALIST))
		)
		((EQ FN 'CDR)
			(CDR (MY-EVAL (CAR ARGS) ALIST))
		)
		((EQ FN 'CONS)
			(CONS (MY-EVAL (CAR ARGS) ALIST) (MY-EVAL (CADR ARGS) ALIST))
		)
		((EQ FN 'QUOTE)
			(CAR ARGS)
		)
		((EQ FN 'SETQ)
			(MY-EVAL-SETQ (CAR ARGS) (CADR ARGS))
		)
		((EQ FN 'COND) ; DONE BY PROF
			(MY-EVAL-COND ARGS ALIST)
		)
		((EQ FN 'DEFUN) ; DONE BY PROF
			(MY-EVAL-DEFUN ARGS ALIST)
		)
		((EQ FN 'EVAL) ; DONE BY PROF
			(MY-EVAL (MY-EVAL (CAR ARGS) ALIST) ALIST)
		)
		((EQ FN 'PRINT)
			(PRINT (MY-EVAL (CAR ARGS) ALIST))
		)
		((EQ FN 'ATOM)
			(ATOM (MY-EVAL (CAR ARGS) ALIST))
		)
		((EQ FN 'NULL)
			(NULL (MY-EVAL (CAR ARGS) ALIST))
		)
		((EQ FN 'LISTP)
			(LISTP (MY-EVAL (CAR ARGS) ALIST))
		)
		((EQ FN 'APPLY)
			(MY-APPLY (CAR ARGS) (CADR ARGS) ALIST)
		)
		((EQ FN 'EQUAL)
			(EQUAL (MY-EVAL (CAR ARGS) ALIST) (MY-EVAL (CADR ARGS) ALIST))
		)
		((EQ FN '+)
			(+ (MY-EVAL (CAR ARGS) ALIST) (MY-EVAL (CADR ARGS) ALIST))
		)
		((EQ FN '-)
			(- (MY-EVAL (CAR ARGS) ALIST) (MY-EVAL (CADR ARGS) ALIST))
		)
		((EQ FN 'MOD)
			(MOD (MY-EVAL (CAR ARGS) ALIST) (MY-EVAL (CADR ARGS) ALIST))
		)
		((EQ FN 'FLOOR)
			(FLOOR (MY-EVAL (CAR ARGS) ALIST) (MY-EVAL (CADR ARGS) ALIST))
		)
		(T ;; get the lambda from the alist
			; (MY-APPLY-LAMBDA FN ARGS GLOBAL-ALIST)
			(MY-APPLY (CDR (MY-ASSOC FN ALIST)) ARGS ALIST)
		)
	)
)

(DEFUN MY-APPLY-LAMBDA (FN ARGS ALIST)
	;; bind the formals to the evaluated actuals then evaluate the body in that
	;; new scoping context (i.e., that becomes the new alist for recursive
	;; evaluation of the function body.  Return the value of the last 
	;; expression in the body (using eval-list)).
	; (MY-EVAL-LIST (CDR (MY-ASSOC FN ALIST)) (MY-BIND-FORMALS (CADR (MY-ASSOC FN ALIST)) ARGS ALIST))
	(MY-EVAL-LIST (CAR FN) (MY-BIND-FORMALS (CDR FN) ARGS ALIST))
)

(DEFUN MY-BIND-FORMALS (F A ALIST) ; DONE BY PROF
	;; This takes a list of formals and unevaluated actuals.  It should evaluate
	;; each actual and bind it to its corresponding formal placing them all on
	;; the front of the alist.  It should return the alist with the new bindings
	;; on the front.  This will be used to evaluate calls to functions defined
	;; via defun.
	;; Note there will be one actual parameter for each formal parameter.
	(COND
		((NULL F)
			ALIST
		)
		(T
			(CONS (CONS (CAR F) (MY-EVAL (CAR A) ALIST)) (MY-BIND-FORMALS (CDR F) (CDR A) ALIST))
		)
	)
)

(DEFUN MY-EVAL-LIST (L ALIST)
	;; Utility function for eval-cond and apply-lambda.  Evaluates each expression
	;; in l and returns the value of the last expression
	(COND
		((NULL L)
			NIL
		)
		((NULL (CDR L))
			(MY-EVAL (CAR L) ALIST)
		)
		(T
			(MY-EVAL-LIST (CDR L) ALIST)
		)
	)
)

(DEFUN MY-EVAL-COND (CLAUSES ALIST)
	;; Remember, cond clauses have one or more expressions in each clause.
	(COND
		((NULL CLAUSES)
			NIL
		)
		((MY-EVAL (CAAR CLAUSES) ALIST)
			(MY-EVAL-LIST (CDAR CLAUSES) ALIST)
		)
		(T
			(MY-EVAL-COND (CDR CLAUSES) ALIST)
		)
	)
)

;; setq and defun will push a new association on the global-alist.
;; whenever we apply a function, we will bind the formals to the evaluated
;; actuals pushing these new bindings onto the local alist and then
;; evaluate the body of the function in that new scoping context.
(DEFUN MY-EVAL-DEFUN (BODY ALIST)
	;; Hint: just push the function body onto the global alist.  It is already an
	;; association, e.g., (equal (L1 L2) (cond (...))) and (assoc 'equal in
	;; the global alist will return this.  You can then take the cdr and you
	;; have a list containing the formal parameters and the expressions in
	;; the function body. defun returns the name of the function.
	(SETQ GLOBAL-ALIST (CONS (CONS (CAR BODY) (CDR BODY)) GLOBAL-ALIST))
	(CAR BODY)
)

(DEFUN MY-EVAL-SETQ (VAR VAL)
	;; just push a new association of the var and its evaluated val onto the global alist
	(SETQ GLOBAL-ALIST (CONS (CONS VAR (MY-EVAL VAL GLOBAL-ALIST)) GLOBAL-ALIST))
	(MY-EVAL VAL GLOBAL-ALIST)
)

;; This one is done, it will become the new top-level for LISP.  After you
;; load this file, call (my-top) and then you can type in expressions and
;; define and call functions to test your my-eval. Note it uses the prog which
;; allows defining local variables, labels and goto looping similar to features
;; found in imperative languages.

(DEFUN MY-TOP () ; DONE BY PROF
    (PROG ()
        TOP
            ;; read an s-expression, evaluate it using my-eval passing in the global-alist,
            ;; then print the result, functions and global variables will be on global-alist

            (PRINT (MY-EVAL (READ) GLOBAL-ALIST))
            (TERPRI) ;; prints a newline
            (GO TOP) ;; loops forever
    )
)


(defun my-error (msg)
    (princ "Error: ")
    (princ msg)
    (terpri)
    nil
)

;; (trace my-eval my-apply-lambda my-eval-cond my-apply my-eval-list my-bind-formals)

(defun my-test (exp)
    (print exp )
    (print (my-eval exp global-alist))
    (terpri)
    (terpri)
)

(defun testallhw5 ()
    (my-test t)
    (my-test nil)
    (my-test "hello")
    (my-test 10)
    (my-test '(eq t t))
    (my-test '(eq nil nil))
    (my-test '(eq t nil))
    (my-test '(null nil))
    (my-test '(null t))
    (my-test '(quote (a b c)))
    (my-test '(eq 'a 'a))
    (my-test '(eq '(a b) '(a b)))
    (my-test '(car '(a b c)))
    (my-test '(cdr '(a b c)))
    (my-test '(cons 'foo '(a b c)))
    (my-test '(setq a '(a b c)))
    (my-test '(print '(a b c)))
    (my-test 'a)
    (my-test '(cond (nil 1)(t 2) (t 3)))
    (my-test '(cond ((eq t nil) (print "in case 1") 1)((eq t t) (print "in case 2") 2)(t (print "in case 3") 3)))
    (my-test '(defun rev (L R) (cond ((null L) R) (t (rev (cdr L) (cons (car L) R))))))
    (my-test '(rev a nil))
    (my-test '(rev (rev  a nil) nil))
    (my-test '(defun app (L R)(cond ((null L) R)(t (cons (car L) (app (cdr L) R))))))
    (my-test '(app (app a a) (app a a)))
)

(testallhw5)