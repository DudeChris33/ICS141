% Write a Prolog relation eval(E,V) that evaluates integer arithmetic expressions
% consisting of integer constants and operators +,-,*,/,^ to a constant value.
% The first argument E is an arbitrary arithmetic expression,
% The second argument V is the single integer value Ring from evaluating the entire expression E. 

eval(E, V) :-
    number(E),
    V is E.

eval(E1 + E2, V) :-
    eval(E1, V1),
    eval(E2, V2),
    V is V1 + V2.

eval(E1 - E2, V) :-
    eval(E1, V1),
    eval(E2, V2),
    V is V1 - V2.

eval(E1 * E2, V) :-
    eval(E1, V1),
    eval(E2, V2),
    V is V1 * V2.

eval(E1 / E2, V) :-
    eval(E1, V1),
    eval(E2, V2),
    V2 =\= 0,
    V is V1 / V2.

eval(E1 ^ E2, V) :-
    eval(E1, V1),
    eval(E2, V2),
    V is V1 ** V2.

% Tests to get started:

test_eval_1 :-
    eval(5-6*18/3+2, Y),
    write('eval(5-6*18/3+2, Y) E:-29 A:'), write(Y), nl.

test_eval_2 :-
    eval(10*20-9/3+20, Y),
    write('eval(10*20-9/3+20, Y) E:217 A:'), write(Y), nl.

test_eval_3 :-
    eval(10^3*9-1, Y),
    write('eval(10^3*9-1, Y) E:8999 A:'), write(Y), nl.

% Write a Prolog relation simplify(E,S) that simplifies polynomial arithmetic expressions involving
% constants, variables (which are Prolog atoms that start with a lowercase letter), and operators +,-,*,/,^.  

% The first argument E is a polynomial arithmetic expression.
% The second argument is the simplified expression, which must be expressed in canonical form (for example, 2*x^2+4x-3).
% Handle the following operations: multiplying, dividing by 0 or 1, adding or subtracting 0, x/x=1, x-x=0, x^0, x^1

simplify(X, X) :- number(X), !.
simplify(X, X) :- atom(X), atom_chars(X, [C]), char_type(C, lower), !.

simplify(X + Y, R) :-
    simplify(X, SX),
    simplify(Y, SY),
    simplify_add(SX + SY, R).

simplify(X - Y, R) :-
    simplify(X, SX),
    simplify(Y, SY),
    simplify_sub(SX - SY, R).

simplify(X * Y, R) :-
    simplify(X, SX),
    simplify(Y, SY),
    simplify_mul(SX * SY, R).

simplify(X / Y, R) :-
    simplify(X, SX),
    simplify(Y, SY),
    simplify_div(SX / SY, R).

simplify(X ^ Y, R) :-
    simplify(X, SX),
    simplify(Y, SY),
    simplify_exp(SX ^ SY, R).

simplify(X, X).

% 010 010
% 010 011
% 010 110
% 010 111
% 011 010
% 011 011
% 011 110
% 011 111
% 110 010
% 110 011
% 110 110
% 110 111
% 111 010
% 111 011
% 111 110
% 111 111

simplify_add(0 + X, X) :- !.
simplify_add(X + 0, X) :- !.
simplify_add(X + Y, R) :-
    number(X), number(Y),
    R is X + Y, !.
simplify_add(X + X, 2 * X) :- !.
simplify_add(X + -Y, R) :- simplify(X - Y, R), !.
simplify_add(-X + Y, R) :- simplify(Y - X, R), !.
simplify_add(-X + -Y, R) :- simplify(X + Y, R), !.
simplify_add(X + (Y * X), R * X) :-
    number(Y),
    R is Y + 1, !.
simplify_add(X + (X * Y), R * X) :-
    number(Y),
    R is Y + 1, !.
simplify_add((Y * X) + X, R * X) :-
    number(Y),
    R is Y + 1, !.
simplify_add((X * Y) + X, R * X) :-
    number(Y),
    R is Y + 1, !.
simplify_add((Y * X) + (Z * X), R * X) :-
    number(Y), number(Z),
    R is Y + Z, !.
simplify_add((Y * X) + (X * Z), R * X) :-
    number(Y), number(Z),
    R is Y + Z, !.
simplify_add((X * Y) + (Z * X), R * X) :-
    number(Y), number(Z),
    R is Y + Z, !.
simplify_add((X * Y) + (X * Z), R * X) :-
    number(Y), number(Z),
    R is Y + Z, !.
simplify_add(X + Y, X + Y).

simplify_sub(0 - X, -X) :- !.
simplify_sub(X - 0, X) :- !.
simplify_sub(X - X, 0) :- !.
simplify_sub(X - Y, R) :-
    number(X), number(Y),
    R is X - Y, !.
simplify_sub(X - -Y, R) :- simplify(X + Y, R), !.
simplify_sub(-X - Y, R) :- simplify(-(X + Y), R), !.
simplify_sub(-X - -Y, R) :- simplify(Y - X, R), !.
simplify_sub(X - (Y * X), R * X) :-
    number(Y),
    R is 1 - Y, !.
simplify_sub(X - (X * Y), R * X) :-
    number(Y),
    R is 1 - Y, !.
simplify_sub((Y * X) - X, R * X) :-
    number(Y),
    R is Y - 1, !.
simplify_sub((X * Y) - X, R * X) :-
    number(Y),
    R is Y - 1, !.
simplify_sub((Y * X) - (Z * X), R * X) :-
    number(Y), number(Z),
    R is Y - Z, !.
simplify_sub((Y * X) - (X * Z), R * X) :-
    number(Y), number(Z),
    R is Y - Z, !.
simplify_sub((X * Y) - (Z * X), R * X) :-
    number(Y), number(Z),
    R is Y - Z, !.
simplify_sub((X * Y) - (X * Z), R * X) :-
    number(Y), number(Z),
    R is Y - Z, !.

% NEEDS WORK FOR Y < Z

simplify_sub(X - Y, X - Y).

simplify_mul(0 * _, 0) :- !.
simplify_mul(_ * 0, 0) :- !.
simplify_mul(1 * X, X) :- !.
simplify_mul(X * 1, X) :- !.
simplify_mul(X * Y, R) :- number(X), number(Y), R is X * Y, !.
simplify_mul(-X * Y, R) :- simplify(-(X * Y), R), !.
simplify_mul(X * -Y, R) :- simplify(-(X * Y), R), !.
simplify_mul(-X * -Y, R) :- simplify(X * Y, R), !.
simplify_mul(Y * (Z * X), R * Z) :-
    number(X), number(Y),
    R is X * Y, !.
simplify_mul(Y * (X * Z), R * Z) :-
    number(X), number(Y),
    R is X * Y, !.
simplify_mul(X * X, X ^ 2) :- !.
simplify_mul(X * (X ^ E2), X ^ R) :-
    number(E2),
    R is E2 + 1, !.
simplify_mul((X ^ E1) * X, X ^ R) :-
    number(E1),
    R is E1 + 1, !.
simplify_mul((X ^ E1) * (X ^ E2), X ^ R) :-
    number(E1), number(E2),
    R is E1 + E2, !.
simplify_mul((Y * X) * X, Y * X ^ 2) :- !.
simplify_mul((Y * X) * (X ^ E2), Y * X ^ R) :-
    number(E2),
    R is E2 + 1, !.
simplify_mul((Y * X ^ E1) * X, Y * X ^ R) :-
    number(E1),
    R is E1 + 1, !.
simplify_mul((Y * X ^ E1) * (X ^ E2), Y * X ^ R) :-
    number(E1), number(E2),
    R is E1 + E2, !.
simplify_mul(X * (Y * X), Y * X ^ 2) :- !.
simplify_mul(X * (Y * X ^ E2), Y * X ^ R) :-
    number(E2),
    R is E2 + 1, !.
simplify_mul((X ^ E1) * (Y * X), Y * X ^ R) :-
    number(E1),
    R is E1 + 1, !.
simplify_mul((X ^ E1) * (Y * X ^ E2), Y * X ^ R) :-
    number(E1), number(E2),
    R is E1 + E2, !.
simplify_mul((Y * X) * (Z * X), V * X ^ 2) :-
    number(Y), number(Z),
    V is Y * Z, !.
simplify_mul((Y * X) * (Z * X ^ E2), V * X ^ R) :-
    number(Y), number(Z), number(E2),
    V is Y * Z, R is E2 + 1, !.
simplify_mul((Y * X ^ E1) * (Z * X), V * X ^ R) :-
    number(Y), number(Z), number(E1),
    V is Y * Z, R is E1 + 1, !.
simplify_mul((Y * X ^ E1) * (Z * X ^ E2), V * X ^ R) :-
    number(Y), number(Z), number(E1), number(E2),
    V is Y * Z, R is E1 + E2, !.
simplify_mul(X * Y, X * Y).

simplify_div(_ / 0, _) :- !, fail.
simplify_div(0 / _, 0) :- !.
simplify_div(X / 1, X) :- !.
simplify_div(X / X, 1) :- !.
simplify_div(X / Y, R) :- number(X), number(Y), R is X / Y, !.
simplify_div(-X / Y, R) :- simplify(-(X / Y), R), !.
simplify_div(X / -Y, R) :- simplify(-(X / Y), R), !.
simplify_div(-X / -Y, R) :- simplify(X / Y, R), !.
% simplify_div(Y * (Z * X), R * Z) :-
%     number(X), number(Y),
%     R is X * Y, !.
% simplify_div(Y * (X * Z), R * Z) :-
%     number(X), number(Y),
%     R is X * Y, !.
simplify_div(X / (X ^ E2), 1 / X ^ R) :-
    number(E2),
    R is E2 - 1, !.
simplify_div((X ^ E1) / X, X ^ R) :-
    number(E1),
    R is E1 - 1, !.
simplify_div((X ^ E1) / (X ^ E2), X ^ R) :-
    number(E1), number(E2),
    E1 >= E2,
    R is E1 - E2, !.
simplify_div((X ^ E1) / (X ^ E2), 1 / X ^ R) :-
    number(E1), number(E2),
    E1 < E2,
    R is E2 - E1, !.
simplify_div((Y * X) / X, Y) :- !.
simplify_div((Y * X) / (X ^ E2), Y / X ^ R) :-
    number(E2),
    R is E2 - 1, !.
simplify_div((Y * X ^ E1) / X, Y * X ^ R) :-
    number(E1),
    R is E1 - 1, !.
simplify_div((Y * X ^ E1) / (X ^ E2), Y * X ^ R) :-
    number(E1), number(E2),
    E1 >= E2,
    R is E1 - E2, !.
simplify_div((Y * X ^ E1) / (X ^ E2), Y / X ^ R) :-
    number(E1), number(E2),
    E1 < E2,
    R is E2 - E1, !.
simplify_div(X / (Y * X), 1 / Y) :- !.
simplify_div(X / (Y * X ^ E2), 1 / (Y * X ^ R)) :-
    number(E2),
    R is E2 - 1, !.
simplify_div((X ^ E1) / (Y * X), X ^ R / Y) :-
    number(E1),
    R is E1 - 1, !.
simplify_div((X ^ E1) / (Y * X ^ E2), X ^ R / Y) :-
    number(E1), number(E2),
    E1 >= E2,
    R is E1 - E2, !.
simplify_div((X ^ E1) / (Y * X ^ E2), 1 / (Y * X ^ R)) :-
    number(E1), number(E2),
    E1 < E2,
    R is E2 - E1, !.
simplify_div((Y * X) / (Z * X), V * X ^ 2) :-
    number(Y), number(Z),
    Y >= Z,
    V is Y / Z,
    number(V), !.
simplify_div((Y * X) / (Z * X), X ^ 2 / V) :-
    number(Y), number(Z),
    Y < Z,
    V is Z / Y,
    number(V), !.
simplify_div((Y * X) / (Z * X ^ E2), V / X ^ R) :-
    number(Y), number(Z), number(E2),
    Y >= Z,
    V is Y / Z, R is E2 - 1,
    number(V), !.
simplify_div((Y * X) / (Z * X ^ E2), 1 / (V * X ^ R)) :-
    number(Y), number(Z), number(E2),
    Y < Z,
    V is Z / Y, R is E2 - 1,
    number(V), !.
simplify_div((Y * X) / (Z * X ^ E2), Y / (Z * X ^ R)) :-
    number(E2),
    R is E2 - 1, !.
simplify_div((Y * X ^ E1) * (Z * X), V * X ^ R) :-
    number(Y), number(Z), number(E1),
    Y >= Z,
    V is Y / Z, R is E1 - 1,
    number(V), !.
simplify_div((Y * X ^ E1) * (Z * X), X ^ R / V) :-
    number(Y), number(Z), number(E1),
    Y < Z,
    V is Z / Y, R is E1 - 1,
    number(V), !.
simplify_div((Y * X ^ E1) * (Z * X), (Y * X ^ R) / Z) :-
    number(E1),
    R is E1 - 1, !.
simplify_div((Y * X ^ E1) * (Z * X ^ E2), V * X ^ R) :-
    number(Y), number(Z), number(E1), number(E2),
    Y >= Z, E1 >= E2,
    V is Y / Z, R is E1 - E2,
    number(V), !.
simplify_div((Y * X ^ E1) * (Z * X ^ E2), V / X ^ R) :-
    number(Y), number(Z), number(E1), number(E2),
    Y >= Z, E1 < E2,
    V is Y / Z, R is E2 - E1,
    number(V), !.
    
simplify_div((Y * X ^ E1) * (Z * X ^ E2), X ^ R / V) :-
    number(Y), number(Z), number(E1), number(E2),
    Y < Z, E1 >= E2,
    V is Z / Y, R is E1 - E2,
    number(V), !.
simplify_div((Y * X ^ E1) * (Z * X ^ E2), 1 / (V * X ^ R)) :-
    number(Y), number(Z), number(E1), number(E2),
    Y < Z, E1 < E2,
    V is Z / Y, R is E2 - E1,
    number(V), !.
simplify_div((Y * X ^ E1) * (Z * X ^ E2), (Y * X ^ R) / Z) :-
    number(E1), number(E2),
    E1 >= E2,
    R is E1 - E2, !.
simplify_div((Y * X ^ E1) * (Z * X ^ E2), Y / (Z * X ^ R)) :-
    number(E1), number(E2),
    E1 < E2,
    R is E2 - E1, !.
simplify_div(X / Y, X / Y).

simplify_exp(_ ^ 0, 1) :- !.
simplify_exp(X ^ 1, X) :- !.
simplify_exp(X ^ -Exp, 1 / X ^ Exp) :- !.
simplify_exp(X ^ Y, R) :- number(X), number(Y), R is X ** Y, !.
simplify_exp((X ^ Y) ^ Z, X ^ R) :- number(Y), number(Z), R is Y * Z, !.
simplify_exp(X ^ Exp, X ^ Exp).

% Tests to get started:

test_simplify_1 :-
    simplify(5-x*(3/3)+2, Y),
    write('simplify(5-x*(3/3)+2, Y) E:5-x+2 A:'), write(Y), nl.

test_simplify_2 :-
    simplify(1*x-0/3+2, Y),
    write('simplify(1*x-0/3+2, Y) E:x+2 A:'), write(Y), nl.

% Write a Prolog program deriv(E,D) to do symbolic differentiation of polynomial arithmetic expressions with respect to x.

% The first argument E is a polynomial arithmetic expression.
% The second argument is the fully simplified expression, which must be expressed in canonical form.
% You may use the cut symbol, !, e.g., after the Prolog interpreter finds an answer,
% to prevent the interpreter from returning the same answer again.
% Tip:  Beware of unary operators!  -10 is different from -(10) or -x, and they have different expression trees.
% Simplify as much as possible.

deriv(E, SD) :-
    simplify(E, SE),
    derivative(SE, D),
    simplify(D, SD).
    
derivative(C, 0) :- number(C).
derivative(X, 1) :- atom(X), atom_chars(X, [C]), char_type(C, lower).

derivative(X + Y, R) :-
    deriv(X, DX),
    deriv(Y, DY),
    simplify(DX + DY, R).

derivative(X - Y, R) :-
    deriv(X, DX),
    deriv(Y, DY),
    simplify(DX - DY, R).

derivative(X * Y, R) :-
    deriv(X, DX),
    deriv(Y, DY),
    simplify(DX * Y + X * DY, R).

derivative(X / Y, R) :-
    deriv(X, DX),
    deriv(Y, DY),
    simplify((DX * Y - X * DY) / (Y ^ 2), R).

derivative(X ^ Exp, R) :-
    deriv(X, DX),
    simplify(Exp * X ^ (Exp - 1) * DX, R).

derivative(-Term, R) :-
    deriv(Term, Deriv),
    simplify(-Deriv, R).

% Test cases:

test_deriv_1 :-
    deriv(x^2, Y),
    write('deriv(x^2, Y) E:2*x A:'), write(Y), nl.

test_deriv_2 :-
    deriv((x*2*x)/x, Y),
    write('deriv((x*2*x)/x, Y) E:2 A:'), write(Y), nl.

test_deriv_3 :-
    deriv(x^4+2*x^3-x^2+5*x-1/x, Y),
    write('deriv(x^4+2*x^3-x^2+5*x-1/x, Y) E:4*x^3+6*x^2-2*x+5+1/x^2 A:'), write(Y), nl.

test_deriv_4 :-
    deriv(4*x^3+6*x^2-2*x+5+1/x^2, Y),
    write('deriv(4*x^3+6*x^2-2*x+5+1/x^2, Y) E:12*x^2+12*x-2-2/x^3 A:'), write(Y), nl.

test_deriv_5 :-
    deriv(12*x^2+12*x-2-2/x^3, Y),
    write('deriv(12*x^2+12*x-2-2/x^3, Y) E:24*x+12+6/x^4 A:'), write(Y), nl.

% Write a Prolog relation party_seating(L) that seats party guests around a round
% table according to the following constraints, when given a list of facts about the guests (provided by the autograder).

% Constraints:
% Because the table is round, the first person in the list will be seated next to the last person in the list.
% Adjacent guests must speak the same language.
% No two females sit next to each other.

% Facts about guests and languages they speak
% speaks(klefstad, english).
% speaks(bill, english).
% speaks(emily, english).
% speaks(heidi, english).
% speaks(isaac, english).

% speaks(beth, french).
% speaks(mark, french).
% speaks(susan, french).
% speaks(isaac, french).

% speaks(klefstad, spanish).
% speaks(bill, spanish).
% speaks(susan, spanish).
% speaks(fred, spanish).
% speaks(jane, spanish).

% male(klefstad).
% male(bill).
% male(mark).
% male(isaac).
% male(fred).

% female(emily).
% female(heidi).
% female(beth).
% female(susan).
% female(jane).

party_seating(L) :-
    same_length(L, LP),
    permute(L, LP),
    langCheck(L),
    womanCheck(L).

permute([], []).
permute([X | Rest], L) :-
    permute(Rest, L1),
    select(X, L, L1).

langCheck([_]).
langCheck([A , B | R]) :-
    speaks(A, Lang),
    speaks(B, Lang),
    langCheck([B | R]).

womanCheck([_]).
womanCheck([G1 , G2 | R]) :-
    (female(G1), female(G2) -> fail ; true),
    womanCheck([G2 | R]).

% Test Cases:

test_party_1 :-
    party_seating([bill, emily, susan, jane, isaac, beth, klefstad, heidi, fred, mark]),
    write('party_seating passed'), nl.

run_tests :-
    test_eval_1,
    test_eval_2,
    test_eval_3,
    nl,
    test_simplify_1,
    test_simplify_2,
    nl,
    test_deriv_1,
    test_deriv_2,
    test_deriv_3,
    test_deriv_4,
    test_deriv_5,
    nl,
    test_party_1.