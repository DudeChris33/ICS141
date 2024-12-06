; Allowed functions:
; DEFUN
; COND
; CONS
; CAR
; CDR
; QUOTE
; EQ, EQUAL
; PRINT, EVAL, SETQ
; NULL
; ATOM
; LISTP
; SYMBOLP, STRINGP, NUMBERP
; AND, OR, NOT
; APPLY
; any arithmetics +, -, *, /, <, >, 1+, 1-, MOD, FLOOR

; Do not use any of these:  IF, SET, SETQ, PROG, REPLICA, RPLACD, GO. (One exception: You may use SETQ at the top level to create test data for your functions.)
; While writing one function, invent helper functions, so that each function does only one thing, keeping it small and easy to understand and debug. Then later write the helper functions, breaking them into smaller ones in the same way. Using this process, you can write complex software recursively. For example, call a helper function to introduce an additional parameter, as you will see in some of these functions, such as MY-REVERSE. Since there is no assignment operator, the way a parameter gets a new value is through recursion.
; Be thoughtful about efficiency when you are programming. For example, make only a single pass over the list for all these functions. For example, do not FLATTEN the list before processing it. Also, do not APPEND two lists when CONS’ing one element on to the front of a list could be done instead.
; Test each function with 1 to 4 test cases, just as you should do in any programming language. The examples in the problem statement are a good start.
; The functions

; (DEFUN MY-OUTPUT (F A B)
;     (PRINT (APPLY F 'A))
;     (PRINC B)
;     (PRINT (EQUAL (APPLY F 'A) B))
; )

(DEFUN MY-LENGTH (L)
	(COND
		((NULL L)
			0
		)
		((NULL (CDR L))
			1
		)
		(T
			(+ 1 (MY-LENGTH (CDR L)))
		)
	)
)

; Define a function MY-LENGTH that takes one parameter, a proper list L, and returns the number of top-level elements in L. Examples:
(PRINT "MY-LENGTH")
(PRINT (MY-LENGTH NIL)) (PRINC 0)
(PRINT (MY-LENGTH '(B (A B C)))) (PRINC 2)
(PRINT (MY-LENGTH '(A (((B))) C))) (PRINC 3)
(PRINT (MY-LENGTH '(A B C))) (PRINC 3)

(DEFUN MY-MEMQ (A L)
	(COND
		((NULL A)
			NIL
		)
		((NULL L)
			NIL
		)
		((EQUAL (CAR L) A)
			L
		)
		(T
			(MY-MEMQ A (CDR L))
		)
	)
)

; ; Define a function MY-MEMQ that takes two parameters, a symbol A and a proper list of symbols L, and returns the list starting where the symbol bound to A was found.   It returns nil otherwise.  Examples:
(PRINT "MY-MEMQ")
(PRINT (MY-MEMQ 'A NIL)) (PRINC NIL)
(PRINT (MY-MEMQ 'B '(A B C))) (PRINC '(B C))
(PRINT (MY-MEMQ 'D '(A B C D E F G))) (PRINC '(D E F G))
(PRINT (MY-MEMQ 'D '(A B C D))) (PRINC '(D))
(PRINT (MY-MEMQ 'D '(A B C))) (PRINC NIL)

(DEFUN MY-APPEND (L1 L2)
	(COND
		((NULL L1)
			L2
		)
		((NULL L2)
			L1
		)
		(T
			(CONS (CAR L1) (MY-APPEND (CDR L1) L2))
		)
	)
)

; ; Define a function MY-APPEND that takes two proper list parameters, L1 and L2, and returns the result of appending the two lists together.  Use only CONS to build the new list.
(PRINT "MY-APPEND")
(PRINT (MY-APPEND '(A B C) '(D E F))) (PRINC '(A B C D E F))
(PRINT (MY-APPEND '((A) (B) (C)) '((D) (E) (F)))) (PRINC '((A) (B) (C) (D) (E) (F)))
(PRINT (MY-APPEND NIL '(D E F))) (PRINC '(D E F))
(PRINT (MY-APPEND '(A B C) NIL)) (PRINC '(A B C))

(DEFUN MY-REVERSE (L)
	(COND
		((NULL L)
			NIL
		)
		(T
			(MY-APPEND (MY-REVERSE (CDR L)) (CONS (CAR L) NIL))
		)
	)
)

; Define the function MY-REVERSE that takes a proper list L and returns the reverse of L. Examples:
(PRINT "MY-REVERSE")
(PRINT (MY-REVERSE NIL)) (PRINC NIL)
(PRINT (MY-REVERSE '(A))) (PRINC '(A))
(PRINT (MY-REVERSE '(1 2 3 4 5))) (PRINC '(5 4 3 2 1))
(PRINT (MY-REVERSE '((1 2 3) 4 ((5 6))))) (PRINC '(((5 6)) 4 (1 2 3)))

(DEFUN MY-MAPCAR (F L)
	(COND
		((NULL F)
			NIL
		)
		((NULL L)
			NIL
		)
		(T
			(CONS (APPLY F (CONS (CAR L) NIL)) (MY-MAPCAR F (CDR L)))
		)
	)
)

; Define a function MY-MAPCAR that takes a function, F, and a proper list, L, and collects the list of results of applying the function F to each element of the list L. Use APPLY for this function. Examples:
(PRINT "MY-MAPCAR")
(PRINT (MY-MAPCAR 'CAR '((A B C) (X Y Z) (1 2 3)))) (PRINC '(A X 1))
(PRINT (MY-MAPCAR 'CDR '((A B C) (X Y Z) (1 2 3)))) (PRINC '((B C) (Y Z) (2 3)))
(PRINT (MY-MAPCAR '1+ '(1 3 5 7))) (PRINC '(2 4 6 8))
(PRINT (MY-MAPCAR 'ATOM '(A (B) C (D) E))) (PRINC '(T NIL T NIL T))

(DEFUN MY-COPY (L)
	(COND
		((NULL L)
			NIL
		)
		((ATOM L)
			L
		)
		(T
			(CONS (MY-COPY (CAR L)) (MY-COPY (CDR L)))
		)
	)
)

; Define a function MY-COPY that takes an S-expression L and returns a full duplicate of it in new storage.
(PRINT "MY-COPY")
(PRINT (MY-COPY '(A B ((C 1)) 2 3))) (PRINC '(A B ((C 1)) 2 3))
(PRINT (MY-COPY '(1 2 3))) (PRINC '(1 2 3))
(PRINT (MY-COPY '(A B . C))) (PRINC '(A B . C))
(PRINT (EQ (SETQ L '(A (B) C)) (MY-COPY L))) (PRINC NIL)

(DEFUN MY-NTH (L N)
	(COND
		((NULL L)
			NIL
		)
		((EQUAL N 0)
			(CONS NIL L)
		)
		((EQUAL N 1)
			L
		)
		(T
			(MY-NTH (CDR L) (- N 1))
		)
	)
)

; Define a function MY-NTH that takes a proper list L and a positive integer N and returns the tail of L beginning with the Nth element. E.g,. if N=2, the value is (CDR L), if N=3, (CDDR L), etc. If N=1, the value is L, for consistency; if N=0, the value returned is (nil . L).
(PRINT "MY-NTH")
(PRINT (MY-NTH '(A B C D E) 1)) (PRINC '(A B C D E))
(PRINT (MY-NTH '(A B C D E) 3)) (PRINC '(C D E))
(PRINT (MY-NTH '(A B C D E) 30)) (PRINC NIL)
(PRINT (MY-NTH '(A B C D E) 0)) (PRINC '(NIL A B C D E))

(DEFUN MY-REMOVE (X L)
	(COND
		((NULL L)
			NIL
		)
		((EQUAL (CAR L) X)
			(MY-REMOVE X (CDR L))
		)
		(T
			(CONS (MY-COPY (CAR L)) (MY-REMOVE X (CDR L)))
		)
	)
)

; Define a function MY-REMOVE that takes an S-expression X and a proper list L and returns a version of L with all top level occurrences of X removed from L, giving a COPY of L with all top level elements equal to X removed.
(PRINT "MY-REMOVE")
(PRINT (MY-REMOVE '(A B) '(A B (A B) A A B (A B)))) (PRINC '(A B A A B))
(PRINT (MY-REMOVE 'A '(A B (A B) A B))) (PRINC '(B (A B) B))

(DEFUN MY-SUBST (X Y Z)
	(COND
		((NULL Z)
			NIL
		)
		((EQUAL X (CAR Z))
			(CONS Y (MY-SUBST X Y (CDR Z)))
		)
		((ATOM (CAR Z))
			(CONS (MY-COPY (CAR Z)) (MY-SUBST X Y (CDR Z)))
		)
		(T
			(CONS (MY-SUBST X Y (CAR Z)) (MY-SUBST X Y (CDR Z)))
		)
	)
)

; Define a function MY-SUBST that takes three parameters X Y Z. It replaces all occurrences of S-expression X with S-expression Y in S-expression Z.
(PRINT "MY-SUBST")
(PRINT (MY-SUBST 'B 'A '(A B (A B) (C (A B))))) (PRINC '(A A (A A) (C (A A))))

(DEFUN MY-SUBSET (FN L)
	(COND
		((NULL L)
			NIL
		)
		((NULL FN)
			NIL
		)
		((APPLY FN (CONS (CAR L) NIL))
			(CONS (CAR L) (MY-SUBSET FN (CDR L)))
		)
		(T
			(MY-SUBSET FN (CDR L))
		)
	)
)

; Define a function MY-SUBSET that takes a function FN and a proper list L and returns a subset of the elements of list L that satisfy the function FN (that means returns non-nil when FN is applied to the element).
(PRINT "MY-SUBSET")
(PRINT (MY-SUBSET 'ATOM '(A (B) (C D) E F G))) (PRINC '(A E F G))
(PRINT (MY-SUBSET 'LISTP '(A (B) (C D) E F G))) (PRINC '((B) (C D)))

(DEFUN MY-ADD (N1 N2)
	(DEFUN MY-ADD-HELPER (N1 N2 CARRY)
		(DEFUN MY-MOD-HELPER (N)
			(/ (- N (MOD N 10)) 10)
		)
		(COND
			((AND (NULL N1) (NULL N2) (EQUAL CARRY 0))
				NIL
			)
			((AND (NULL N1) (NULL N2))
				(CONS (MOD CARRY 10) (MY-ADD-HELPER NIL NIL (MY-MOD-HELPER CARRY)))
			)
			((NULL N1)
				(CONS (MOD (+ (CAR N2) CARRY) 10) (MY-ADD-HELPER NIL (CDR N2) (MY-MOD-HELPER (+ (CAR N2) CARRY))))
			)
			((NULL N2)
				(CONS (MOD (+ (CAR N1) CARRY) 10) (MY-ADD-HELPER NIL (CDR N1) (MY-MOD-HELPER (+ (CAR N1) CARRY))))
			)
			(T
				(CONS (MOD (+ (CAR N1) (CAR N2) CARRY) 10) (MY-ADD-HELPER (CDR N1) (CDR N2) (MY-MOD-HELPER (+ (CAR N1) (CAR N2) CARRY))))
			)
		)
	)
	(MY-ADD-HELPER N1 N2 0)
)

; Define a function MY-ADD that takes two proper lists of single digit integers, N1 and N2, which represent large magnitude positive integer numbers called big-nums, and returns a list in this big-num representation corresponding to adding the two big-nums N1 and N2. Each element of a big-num is in the range 0 to 9.  big-nums are stored in reverse order so that the first element is the ones digit, the second element is the tens, the third is the hundreds, etc. Be sure to handle carry, and ensure no integer element exceeds 9 in value.  Valid big-nums will never be nil from the start.  Zero is represented by the list (0), 10 is (0 1), 1999 is (9 9 9 1). (This is a LeetCode problem testing fluency with singly linked lists, the hardest problem this week. Handling the carry and dealing with numbers of different lengths are the hard parts.)
(PRINT "MY-ADD")
(PRINT (MY-ADD '(0) '(0))) (PRINC '(0))
(PRINT (MY-ADD '(1) '(1))) (PRINC '(2))
(PRINT (MY-ADD '(9) '(9))) (PRINC '(8 1))
(PRINT (MY-ADD '(1 1 1 1 1 1 1 1 1 1) '(9 9 9 9 9 9 9 9 9 9))) (PRINC '(0 1 1 1 1 1 1 1 1 1 1))
(PRINT (MY-ADD '(1) '(9 9 9 9 9 9 9 9 9 9))) (PRINC '(0 0 0 0 0 0 0 0 0 0 1))

(DEFUN MY-MERGE (L1 L2)
	(COND
		((NULL L1)
			L2
		)
		((NULL L2)
			L1
		)
		((<= (CAR L1) (CAR L2))
			(CONS (CAR L1) (MY-MERGE (CDR L1) L2))
		)
		(T
			(CONS (CAR L2) (MY-MERGE L1 (CDR L2)))
		)
	)
)

; Define a function MY-MERGE that takes two sorted proper lists of integers L1 and L2 and returns the result of merging the two sorted lists of integers similar to how merge-sort might do it.  Duplicates are allowed. All of these test cases return the list (1 2 3 4 5 6 7 8 9 10)
(PRINT "MY-MERGE")
(PRINT (MY-MERGE '(1 3 5 7 9) '(2 4 6 8 10))) (PRINC '(1 2 3 4 5 6 7 8 9 10))
(PRINT (MY-MERGE '(1 2 3 7 8 9) '(4 5 6 10))) (PRINC '(1 2 3 4 5 6 7 8 9 10))
(PRINT (MY-MERGE '(1 2 3) '(4 5 6 7 8 9 10))) (PRINC '(1 2 3 4 5 6 7 8 9 10))
(PRINT (MY-MERGE '(1 3 5 6 7 8 9 10) '(2 4))) (PRINC '(1 2 3 4 5 6 7 8 9 10))
(PRINT (MY-MERGE NIL '(1 2 3 4 5 6 7 8 9 10))) (PRINC '(1 2 3 4 5 6 7 8 9 10))

(DEFUN MY-SUBLIST (L1 L2)
	(DEFUN MY-SUBLIST-HELPER (L1 L2 STREAK)
		(COND
			((NULL L1)
				T
			)
			((NULL L2)
				NIL
			)
			((EQ (CAR L1) (CAR L2))
				(MY-SUBLIST-HELPER (CDR L1) (CDR L2) 1)
			)
			((EQUAL STREAK 1)
				NIL
			)
			(T
				(MY-SUBLIST-HELPER L1 (CDR L2) 0)
			)
		)
	)
	(MY-SUBLIST-HELPER L1 L2 0)
)

; Define a function MY-SUBLIST that takes two proper lists of atoms L1 and  L2 and returns T only if L1 is a sublist of L2. Use EQ to test for equality of corresponding elements.
(PRINT "MY-SUBLIST")
(PRINT (MY-SUBLIST '(1 2 3) '(1 2 3 4 5))) (PRINC T)
(PRINT (MY-SUBLIST '(3 4 5) '(1 2 3 4 5))) (PRINC T)
(PRINT (MY-SUBLIST '(C D) '(A B C D E))) (PRINC T)
(PRINT (MY-SUBLIST '(3 4) '(1 2 3 5 6))) (PRINC NIL)
(PRINT (MY-SUBLIST '(1 2 3 4 5) '(3 4 5))) (PRINC NIL)
(PRINT (MY-SUBLIST '(2 4) '(1 2 3 4 5))) (PRINC NIL)
(PRINT (MY-SUBLIST '(1 3 5) '(1 2 3 4 5))) (PRINC NIL)

(DEFUN MY-ASSOC (A ALIST)
	(COND
		((NULL A)
			NIL
		)
		((NULL ALIST)
			NIL
		)
		((EQ A (CAR (CAR ALIST)))
			(CONS A (CDR (CAR ALIST)))
		)
		(T
			(MY-ASSOC A (CDR ALIST))
		)
	)
)

; Define the function MY-ASSOC that takes an atom A and an association list ALIST and returns the association pair for A in ALIST. If there is no association, it returns nil (so that you can distinguish between an unbound variable and a variable bound to nil).  An association list is a proper list of key/value pairs where the key (always a symbol) is the CAR and the value (any S-expression) is the CDR of that pair. An association list is of the form ((key1 . value1) (key2 . value2) … (keyn . valuen)) Association lists are useful for specifying variables and their bindings. This function will be useful for Homework 5 when we write EVAL.  Examples:
(PRINT "MY-ASSOC")
(PRINT (MY-ASSOC 'A NIL)) (PRINC NIL)
(PRINT (MY-ASSOC 'A '((A . B)(C E F)(B)))) (PRINC '(A . B))
(PRINT (MY-ASSOC 'C '((A . B)(C E F)(B)))) (PRINC '(C E F))
(PRINT (MY-ASSOC 'B '((A . B)(C E F)(B)))) (PRINC '(B)) ;; B’s value is nil
(PRINT (MY-ASSOC 'F '((A . B)(C E F)(B)))) (PRINC NIL)

(DEFUN MY-REPLACE (ALIST L)
	(DEFUN MY-REPLACE-HELPER (ALIST L)
		(COND
			((NULL ALIST)
				NIL
			)
			((NULL L)
				NIL
			)
			((EQ L (CAAR ALIST))
				(CDAR ALIST)
			)
			(T
				(MY-REPLACE-HELPER (CDR ALIST) L)
			)
		)
	)
	(COND
		((NULL ALIST)
			NIL
		)
		((NULL L)
			NIL
		)
		; ((NOT (NULL (MY-REPLACE-HELPER ALIST L)))
		((AND (ATOM L) (NOT (NULL (MY-REPLACE-HELPER ALIST L))))
			; (CONS (CAR L) (MY-REPLACE ALIST (CDR L)))
			(MY-REPLACE-HELPER ALIST L)
		)
		((ATOM L)
			L
		)
		(T
			; (CONS (MY-REPLACE-HELPER ALIST (CAR L)) (MY-REPLACE ALIST (CDR L)))
			(CONS (MY-REPLACE ALIST (CAR L)) (MY-REPLACE ALIST (CDR L)))
		)
	)
)

; Define a function MY-REPLACE that takes an association list ALIST and an arbitrary S-expression L that returns L with each variable (key) in ALIST replaced with the corresponding value it is bound to in ALIST.
; This function could be used to convert a DNA strand to its RNA complement per RNA transcription according to the following rules: Both DNA and RNA strands are a sequence of nucleotides. The four nucleotides found in DNA are adenine (A), cytosine (C), guanine (G) and thymine (T). The four nucleotides found in RNA are adenine (A), cytosine (C), guanine (G) and uracil (U). Given a DNA strand, its transcribed RNA strand is formed by replacing each nucleotide with its complement (X → Y means that X is replaced by Y):          G → C; C → G; T → A; A → U  Example:

(PRINT "MY-REPLACE")
(PRINT (MY-REPLACE '((G . C)(C . G)(T . A)(A . U)) '(G A T C C T C C A T A T A C A A C G G T))) (PRINC '(C U A G G A G G U A U A U G U U G C C A))

; This function could also change a phrase with new values.  Example:

(PRINT (MY-REPLACE '((UCB . UCLA)(UCSD . UCI)(BASKETBALL . TENNIS)) '(UCSD IS PLAYING BASKETBALL AGAINST UCB))) (PRINC '(UCI IS PLAYING TENNIS AGAINST UCLA))
