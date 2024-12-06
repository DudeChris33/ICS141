% Define a relation my_length that takes two arguments, a list L, and an argument, R,
% for the number of top_level elements in L.

my_length([], 0).
my_length([_ | T], R) :-
    my_length(T, R1),
    R is R1 + 1.

test_my_length_1 :-
    my_length([], R),
    write('my_length([], R) E:0 A:'), write(R), nl.

test_my_length_2 :-
    my_length([b,[a,b,c]], R),
    write('my_length([b,[a,b,c]], R) E:2 A:'), write(R), nl.

test_my_length_3 :-
    my_length([a,[[[b]]],c], R),
    write('my_length([a,[[[b]]],c], R) E:3 A:'), write(R), nl.

test_my_length_4 :-
    my_length([a,b,c], R),
    write('my_length([a,b,c], R) E:3 A:'), write(R), nl.

% Define a relation my_member that takes two arguments, a symbol A and a list of symbols L,
% succeeds when the symbol bound to A is found within L. It fails otherwise.

my_member(A, [A | _]).
my_member(A, [_ | T]) :-
	my_member(A, T).

test_my_member_1 :-
	dif(my_member(a, []), true),
    write('my_member(a,[]) passed'), nl.

test_my_member_2 :-
	my_member(b,[a,b,c]),
    write('my_member(b,[a,b,c]) passed'), nl.

test_my_member_3 :-
	my_member(d,[a,b,c,d,e,f,g]),
    write('my_member(d,[a,b,c,d,e,f,g]) passed'), nl.

test_my_member_4 :-
	my_member(d,[a,b,c,d]),
    write('my_member(d,[a,b,c,d]) passed'), nl.

test_my_member_5 :-
	dif(my_member(d,[a,b,c]), true),
    write('my_member(d,[a,b,c]) passed'), nl.

% Define a relation my_append that takes three arguments, list L1 and list L2, and an argument,
% R, which is the result of appending the two lists L1 and L2 together.

my_append([], L, L).
my_append([L1H | L1T], L2, [L1H | R]) :-
    my_append(L1T, L2, R).

test_my_append_1 :-
    my_append([a,b,c],[d,e,f],R),
    write('my_append([a,b,c],[d,e,f],R) E:[a,b,c,d,e,f] A:'), write(R), nl.

test_my_append_2 :-
    my_append([[a],[b],[c]],[[d],[e],[f]],R),
    write('my_append([[a],[b],[c]],[[d],[e],[f]],R) E:[[a],[b],[c],[d],[e],[f]] A:'), write(R), nl.

test_my_append_3 :-
    my_append([],[d,e,f],R),
    write('my_append([],[d,e,f],R) E:[d,e,f] A:'), write(R), nl.

test_my_append_4 :-
    my_append([a,b,c],[],R),
    write('my_append([a,b,c],[],R) E:[a,b,c] A:'), write(R), nl.

% Define the relation my_reverse that takes a list L and another argument R which is the reversal of list L.

my_reverse(L, R) :- my_reverse_helper(L, [], R).

my_reverse_helper([], L, L).
my_reverse_helper([H | T], L, R) :-
    my_reverse_helper(T, [H | L], R).

test_my_reverse_1 :-
    my_reverse([],R),
    write('my_reverse([],R) E:[] A:'), write(R), nl.

test_my_reverse_2 :-
    my_reverse([a,b],R),
    write('my_reverse([a,b],R) E:[b,a] A:'), write(R), nl.

test_my_reverse_3 :-
    my_reverse([1,2,3,4,5],R),
    write('my_reverse([1,2,3,4,5],R) E:[5,4,3,2,1] A:'), write(R), nl.

test_my_reverse_4 :-
    my_reverse([[1,2,3],4,[[5,6]]],R),
    write('my_reverse([[1,2,3],4,[[5,6]]],R) E:[[[5,6]],4,[1,2,3]] A:'), write(R), nl.

% Define a relation my_nth that takes a list L and a positive integer N (N>0) and binds
% to the third argument, the tail of L beginning with the Nth element. When N=1, R=L.

my_nth(L, 1, L).
my_nth([_ | T], N, R) :-
    N > 1,
    N is N1 + 1,
    my_nth(T, N1, R).

test_my_nth_1 :-
    my_nth([a,b,c,d,e],1,R),
    write('my_nth([a,b,c,d,e],1,R) E:[a,b,c,d,e] A:'), write(R), nl.

test_my_nth_2 :-
    my_nth([a,b,c,d,e],3,R),
    write('my_nth([a,b,c,d,e],3,R) E:[c,d,e] A:'), write(R), nl.

test_my_nth_3 :-
    my_nth([a,b,c,d,e],5,R),
    write('my_nth([a,b,c,d,e],5,R) E:[e] A:'), write(R), nl.

test_my_nth_4 :-
    my_nth([a,b,c,d,e],30,R),
    write('my_nth([a,b,c,d,e],30,R) E:[] A:'), write(R), nl.

% Define a relation my_remove that takes a term X and a list L and binds the third argument
% R to a version of L with all top level occurrences of X removed from L.

my_remove(_, [], []).
my_remove(X, [X | T], R) :-
    my_remove(X, T, R).
my_remove(X, [H | T], [H | R]) :-
    dif(X, H),
    my_remove(X, T, R).

test_my_remove_1 :-
    my_remove([a,b],[a,b,[a,b],a,a,b,[a,b]],R),
    write('my_remove([a,b],[a,b,[a,b],a,a,b,[a,b]],R) E:[a,b,a,a,b] A:'), write(R), nl.

test_my_remove_2 :-
    my_remove(a,[a,b,[a,b],a,b],R),
    write('my_remove(a,[a,b,[a,b],a,b],R) E:[b,[a,b],b] A:'), write(R), nl.

% Define a relation my_subst that takes four arguments X Y Z and binds R to a version of Z
% with all occurrences of X replaced with Y.

my_subst(_, _, [], []).
my_subst(X, Y, [X | T], [Y | R]) :-
    my_subst(X, Y, T, R).
my_subst(X, Y, [H | T], [H | R]) :-
    dif(H, X),
    my_subst(X, Y, T, R).

test_my_subst_1 :-
    my_subst(b,a,[a,b,a,b,c,a,b],R),
    write('my_subst(b,a,[a,b,a,b,c,a,b],R) E:[a,a,a,a,c,a,a] A:'), write(R), nl.

test_my_subst_2 :-
    my_subst(c,d,[a,b,a,b,c,a,b],R),
    write('my_subst(c,d,[a,b,a,b,c,a,b],R) E:[a,b,a,b,d,a,b] A:'), write(R), nl.

% Define a relation my_subset that takes a relation P and a list L and binds a third argument
% R to a list with a subset of the elements of list L that satisfy the relation P. Satisfy
% means succeeds when P is applied to an element. Use =.. and maybe call() and the cut symbol ! for my_subset.

my_subset(atomic, L, R) :-
    my_subset_helper(atomic, L, R).

my_subset(compound, L, R) :-
    my_subset_helper(compound, L, R).

my_subset_helper(_, [], []).
my_subset_helper(P, [H | T], [H | R]) :-
    call(P, H),
    my_subset_helper(P, T, R).
my_subset_helper(P, [_ | T], R) :-
    my_subset_helper(P, T, R).

test_my_subset_1 :-
    my_subset(atomic,[a,[b],[c,d],e,f,g],R),
    write('my_subset(atomic,[a,[b],[c,d],e,f,g],R) E:[a,e,f,g] A:'), write(R), nl.

test_my_subset_2 :-
    my_subset(compound,[a,[b],[c,d],e,f,g],R),
    write('my_subset(compound,[a,[b],[c,d],e,f,g],R) E:[[b],[c,d]] A:'), write(R), nl.
    
% Define a relation my_add that takes two lists of single digit integers, N1 and N2,
% which represent large magnitude positive integer numbers called big_nums, and binds
% the third parameter to a list in this big_num representation corresponding to adding
% the two big_nums N1 and N2. Each element of a big_num is in the range 0 to 9.  big_nums
% are stored in reverse order, so that the first element is the ones digit, the second
% element is the tens, the third is the hundreds, etc. Be sure to handle carry, and ensure
% no integer element exceeds 9 in value.  Valid big_nums will never be nil from the start.
% Zero is represented by the list [0], 10 is [0,1], 1999 is [9,9,9,1].

my_add(N1, N2, R) :-
    my_add_helper(N1, N2, 0, R).

my_add_helper([], [], 0, []).
my_add_helper([], [], Carry, [Carry]) :-
    Carry > 0.
my_add_helper([], [Num2 | N2T], Carry, [Sum | RT]) :-
    Sum is (Num2 + Carry) mod 10,
    NewCarry is (Num2 + Carry) // 10,
    my_add_helper([], N2T, NewCarry, RT).
my_add_helper([Num1 | N1T], [], Carry, [Sum | RT]) :-
    Sum is (Num1 + Carry) mod 10,
    NewCarry is (Num1 + Carry) // 10,
    my_add_helper(N1T, [], NewCarry, RT).
my_add_helper([Num1 | N1T], [Num2 | N2T], Carry, [Sum | RT]) :-
    TempSum is Num1 + Num2 + Carry,
    Sum is TempSum mod 10,
    NewCarry is TempSum // 10,
    my_add_helper(N1T, N2T, NewCarry, RT).

test_my_add_1 :-
    my_add([0],[0],R),
    write('my_add([0],[0],R) E:[0] A:'), write(R), nl.

test_my_add_2 :-
    my_add([1],[1],R),
    write('my_add([1],[1],R) E:[2] A:'), write(R), nl.

test_my_add_3 :-
    my_add([9],[9],R),
    write('my_add([9],[9],R) E:[8,1] A:'), write(R), nl.

test_my_add_4 :-
    my_add([1,1,1,1,1,1,1,1,1,1],[9,9,9,9,9,9,9,9,9,9],R),
    write('my_add([1,1,1,1,1,1,1,1,1,1],[9,9,9,9,9,9,9,9,9,9],R) E:[0,1,1,1,1,1,1,1,1,1,1] A:'), write(R), nl.

test_my_add_5 :-
    my_add([1],[9,9,9,9,9,9,9,9,9,9],R),
    write('my_add([1],[9,9,9,9,9,9,9,9,9,9],R) E:[0,0,0,0,0,0,0,0,0,0,1] A:'), write(R), nl.

% Define a relation my_merge that takes two sorted lists of integers L1 and L2, and binds
% the third argument, R, to the result of merging the two sorted lists of integers, similar
% to how merge_sort might do it.  Read this. Duplicates are allowed. All of the following
% test cases bind R to the list R=[1,2,3,4,5,6,7,8,9,10]

my_merge([], L, L).
my_merge(L, [], L).
my_merge([X | L1], [Y | L2], [X | R]) :-
    X =< Y,
    my_merge(L1, [Y | L2], R).
my_merge([X | L1], [Y | L2], [Y | R]) :-
    X > Y,
    my_merge([X | L1], L2, R).

test_my_merge_1 :-
    my_merge([1,3,5,7,9],[2,4,6,8,10],R),
    write('my_merge([1,3,5,7,9],[2,4,6,8,10],R) E:[1,2,3,4,5,6,7,8,9,10] A:'), write(R), nl.

test_my_merge_2 :-
    my_merge([1,2,3,7,8,9],[4,5,6,10],R),
    write('my_merge([1,2,3,7,8,9],[4,5,6,10],R) E:[1,2,3,4,5,6,7,8,9,10] A:'), write(R), nl.

test_my_merge_3 :-
    my_merge([1,2,3],[4,5,6,7,8,9,10],R),
    write('my_merge([1,2,3],[4,5,6,7,8,9,10],R) E:[1,2,3,4,5,6,7,8,9,10] A:'), write(R), nl.

test_my_merge_4 :-
    my_merge([1,3,5,6,7,8,9,10],[2,4],R),
    write('my_merge([1,3,5,6,7,8,9,10],[2,4],R) E:[1,2,3,4,5,6,7,8,9,10] A:'), write(R), nl.

test_my_merge_5 :-
    my_merge([],[1,2,3,4,5,6,7,8,9,10],R),
    write('my_merge([],[1,2,3,4,5,6,7,8,9,10],R) E:[1,2,3,4,5,6,7,8,9,10] A:'), write(R), nl.

% Define a relation my_sublist that takes two lists of atoms L1 and L2 and succeeds only if L1 is a sublist of L2.

my_sublist(L1, L2) :-
    my_sublist_helper(L1, L2, 0).

my_sublist_helper([], _, _).
my_sublist_helper([X | L1], [X | L2], 0) :-
    my_sublist_helper(L1, L2, 1).
my_sublist_helper(L1, [_ | L2], 0) :-
    my_sublist_helper(L1, L2, 0).
my_sublist_helper([X | L1], [X | L2], 1) :-
    my_sublist_helper(L1, L2, 1).

test_my_sublist_1 :-
    my_sublist([1,2,3],[1,2,3,4,5]),
    write('my_sublist([1,2,3],[1,2,3,4,5]) passed'), nl.

test_my_sublist_2 :-
    my_sublist([3,4,5],[1,2,3,4,5]),
    write('my_sublist([3,4,5],[1,2,3,4,5]) passed'), nl.

test_my_sublist_3 :-
    my_sublist([c,d],[a,b,c,d,e]),
    write('my_sublist([c,d],[a,b,c,d,e]) passed'), nl.

test_my_sublist_4 :-
    dif(my_sublist([3,4],[1,2,3,5,6]), true),
    write('my_sublist([3,4],[1,2,3,5,6]) passed'), nl.

test_my_sublist_5 :-
    dif(my_sublist([1,2,3,4,5],[3,4,5]), true),
    write('my_sublist([1,2,3,4,5],[3,4,5]) passed'), nl.

test_my_sublist_6 :-
    dif(my_sublist([2,4],[1,2,3,4,5]), true),
    write('my_sublist([2,4],[1,2,3,4,5]) passed'), nl.

test_my_sublist_7 :-
    dif(my_sublist([1,3,5],[1,2,3,4,5]), true),
    write('my_sublist([1,3,5],[1,2,3,4,5]) passed'), nl.

test_my_sublist_8 :-
    my_sublist([3,4,5],[1,2,3,4,X]),
    write('my_sublist([1,3,5],[1,2,3,4,5]) passed'), nl.


% Define the relation my_assoc that takes an atom A and an association list ALIST and
% binds R to the value associated with A in ALIST. If there is no association for A, it fails.
% Prolog does not have association lists, but we can invent them—a little different than they
% are in Lisp.  An association list is a list of key/value pairs, where the key (always a symbol)
% is followed by the value, so the length of an ALIST is always even. An association list is
% of the form [key_1,value_1,key_2,value_2],… key_n,value_n] Examples:

my_assoc(A, [A, R | _], R).
my_assoc(A, [_ | ALIST], R) :-
    my_assoc(A, ALIST, R).

test_my_assoc_1 :-
    dif(my_assoc(a,[],R), true),
    write('my_assoc(a,[],R) passed'), nl.

test_my_assoc_2 :-
    my_assoc(a,[a,b,c,e,f,b],R),
    write('my_assoc(a,[a,b,c,e,f,b],R) E:b A:'), write(R), nl.

test_my_assoc_3 :-
    my_assoc(c,[a,b,c,e,f,b],R),
    write('my_assoc(c,[a,b,c,e,f,b],R) E:e A:'), write(R), nl.

test_my_assoc_4 :-
    my_assoc(f,[a,b,c,e,f,b],R),
    write('my_assoc(f,[a,b,c,e,f,b],R) E:b A:'), write(R), nl.

test_my_assoc_5 :-
    dif(my_assoc(b,[a,b,c,e,f,b],R), true),
    write('my_assoc(b,[a,b,c,e,f,b],R) passed'), nl.

% Define a relation my_replace that takes an association list ALIST and an arbitrary list L,
% that binds to a third argument R the list L with each variable (key) in ALIST replaced with
% the corresponding value it is bound to in ALIST.

my_replace(_, [], []).
my_replace(ALIST, [X | L], [Y | R]) :-
    (ground(X), my_assoc(X, ALIST, Y) -> true ; Y = X),
    my_replace(ALIST, L, R).

test_my_replace_1 :-
    my_replace([g,c,c,g,t,a,a,u],[g,a,t,c,c,t,c,c,a,t,a,t,a,c,a,a,c,g,g,t],R),
    write('my_replace([g,c,c,g,t,a,a,u],[g,a,t,c,c,t,c,c,a,t,a,t,a,c,a,a,c,g,g,t],R)'), nl,
    write('E:[c,u,a,g,g,a,g,g,u,a,u,a,u,g,u,u,g,c,c,a] A:'), write(R), nl.

test_my_replace_2 :-
    my_replace([ucb,ucla,ucsd,uci,basketball,tennis],[ucsd,is,playing,basketball,against,ucb],R),
    write('my_replace([ucb,ucla,ucsd,uci,basketball,tennis],[ucsd,is,playing,basketball,against,ucb],R)'), nl,
    write('E:[uci,is,playing,tennis,against,ucla] A:'), write(R), nl.

test_my_replace_3 :-
    my_replace([dog,cat,fleas,kittens,sunday,friday],[my,dog,has,fleas,on,sunday],R),
    write('my_replace([dog,cat,fleas,kittens,sunday,friday],[my,dog,has,fleas,on,sunday],R)'), nl,
    write('E:[my,cat,has,kittens,on,friday] A:'), write(R), nl.

run_tests :-
    test_my_length_1,
    test_my_length_2,
    test_my_length_3,
    test_my_length_4,
    nl,
	test_my_member_1,
	test_my_member_2,
	test_my_member_3,
	test_my_member_4,
	test_my_member_5,
    nl,
	test_my_append_1,
	test_my_append_2,
	test_my_append_3,
	test_my_append_4,
    nl,
	test_my_reverse_1,
	test_my_reverse_2,
	test_my_reverse_3,
	test_my_reverse_4,
    nl,
    test_my_remove_1,
    test_my_remove_2,
    nl,
    test_my_subst_1,
    test_my_subst_2,
    nl,
    test_my_subset_1,
    test_my_subset_2,
    nl,
    test_my_add_1,
    test_my_add_2,
    test_my_add_3,
    test_my_add_4,
    test_my_add_5,
    nl,
    test_my_merge_1,
    test_my_merge_2,
    test_my_merge_3,
    test_my_merge_4,
    test_my_merge_5,
    nl,
    test_my_sublist_1,
    test_my_sublist_2,
    test_my_sublist_3,
    test_my_sublist_4,
    test_my_sublist_5,
    test_my_sublist_6,
    test_my_sublist_7,
    test_my_sublist_8,
    nl,
    test_my_assoc_1,
    test_my_assoc_2,
    test_my_assoc_3,
    test_my_assoc_4,
    test_my_assoc_5,
    nl,
    test_my_replace_1,
    test_my_replace_2,
    test_my_replace_3.