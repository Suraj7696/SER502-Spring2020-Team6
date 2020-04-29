program(prog(X)) -->['begin'], block(X),['end'],['.'].

block(blk(X)) --> ['{'],block_part(X),['}'].

block_part(bp(X,Y)) --> command(X), block_part(Y).
block_part(bp(X)) --> command(X).

command(com(X)) --> declaration(X),[;].
command(com(X)) --> assignment(X),[;].
command(com(X)) -->expression(X),[;].
command(com(X)) -->bool(X),[;].
command(com(X)) -->output(X),[;].
command(com(X)) -->if(X).
command(com(X)) --> ternary(X),[;].
command(com(X)) -->for(X).
command(com(X)) -->while(X).
command(com(X)) -->for_range(X).
command(com(X)) --> iterator(X),[;].

:- table bool/3.

bool(true) --> ['true'].
bool(false) --> ['false'].
bool(t_not(X)) --> ['not'],['('],bool(X),[')'].
bool(t_not(X)) --> ['not'],['('],condition(X),[')'].
bool(t_and(X,Y)) --> bool(X), ['and'], bool(Y).
bool(t_and(X,Y)) --> condition(X), ['and'], condition(Y).
bool(t_or(X,Y)) --> bool(X), ['or'], bool(Y).
bool(t_or(X,Y)) --> condition(X), ['or'], condition(Y).



declaration(t_int_dec(int,X,Y)) --> ['int'], id(X), ['='], expression(Y).
declaration(t_str_dec(string,X,Y)) --> ['string'], id(X), ['='],string(Y).
declaration(t_bool_dec(bool,X,true)) --> ['bool'], id(X), [=], ['true'].
declaration(t_bool_dec(bool,X,false)) --> ['bool'], id(X), [=], ['false'].
declaration(t_dec(X,Y)) --> type(X), id(Y).

assignment(t_assign(X,Y)) --> id(X), ['='], expression(Y).
assignment(t_assign(X,Y)) --> id(X), ['='], bool(Y).

type(int) --> ['int'].
type(string) -->['string'].
type(bool) --> ['bool'].

for(t_for(X,Y,Z,W)) --> ['for'],['('],declaration(X),[';'],(condition(Y);bool(Y)),[';'],iterator(Z),[')'],block(W).
for(t_for(X,Y,Z,W)) -->['for'],['('],declaration(X),[';'],(condition(Y);bool(Y)),[';'],assignment(Z),[')'],block(W).
for(t_for(X,Y,Z,W)) --> ['for'],['('],assignment(X),[';'],(condition(Y);bool(Y)),[';'],iterator(Z),[')'],block(W).
for(t_for(X,Y,Z,W)) -->['for'],['('],assignment(X),[';'],(condition(Y);bool(Y)),[';'],expression(Z),[')'],block(W).

while(t_while(X,Y)) --> ['while'], ['('],(condition(X);bool(X)),[')'], block(Y).

for_range(t_for_range(X,Y,Z,W)) --> ['for'], id(X), ['in'],['range'],['('],num(Y),[':'],num(Z),[')'],block(W).
for_range(t_for_range(X,Y,Z,W)) --> ['for'], id(X), ['in'],['range'],['('],id(Y),[':'],id(Z),[')'],block(W).
for_range(t_for_range(X,Y,Z,W)) --> ['for'], id(X), ['in'],['range'],['('],num(Y),[':'],id(Z),[')'],block(W).
for_range(t_for_range(X,Y,Z,W)) --> ['for'], id(X), ['in'],['range'],['('],id(Y),[':'],num(Z),[')'],block(W).

if(t_if(X,Y)) --> ['if'],['('],(condition(X);bool(X)),[')'], block(Y) .
if(t_if(X,Y,Z)) --> ['if'],['('],(condition(X);bool(X)),[')'], block(Y), ['else'], block(Z).

ternary(t_ternary(X,U,V)) --> (condition(X);bool(X)), ['?'], command(U), [':'], command(V).

output(out(X)) --> ['print'], ['('], id(X),[')'].
output(out(X)) --> ['print'], ['('], num(X),[')'].
output(out(X)) --> ['print'], ['('], string(X),[')'].


condition(t_cond(X,Y,Z)) --> expression(X), condition_operator(Y), expression(Z).
condition(t_cond(X,Y,Z)) --> string(X), condition_operator(Y), string(Z).
condition(t_cond(X,Y,Z)) --> id(X), condition_operator(Y), string(Z).


condition_operator(==) --> ['=='].
condition_operator('!=') --> ['!='].
condition_operator(>) --> ['>'].
condition_operator(<) --> ['<'].
condition_operator(>=) --> ['>='].
condition_operator(<=) --> ['<='].

:- table expression/3,term/3.
expression(t_add(X,Y)) --> expression(X), ['+'], term(Y).
expression(t_sub(X,Y)) --> expression(X), ['-'], term(Y).
expression(X) --> term(X).
term(t_mult(X,Y)) --> term(X), ['*'], term(Y).
term(t_div(X,Y)) --> term(X), ['/'], term(Y).
term(X) --> ['('], expression(X), [')'].
term(X) --> num(X).
term(X) --> id(X).

iterator(t_plus(X)) --> id(X), ['++'].
iterator(t_minus(X)) --> id(X), ['--'].

num(t_num(Y)) --> [Y], {number(Y)}.
id(id(Y)) --> [Y],{atom(Y)}.
string(Y) --> ['\"'],openstring(Y),['\"'].
openstring(op(Y)) --> [Y],{atom(Y)}.
%--------------------------------------------------------------------------------
check_type(Val,T) :- string(Val),T = string.
check_type(Val,T) :- integer(Val),T = int.
check_type(Val,T) :- (Val = true ; Val = false),T = bool.

not(true,false).
not(false,true).

and(false,_,false).
and(_,false,false).
and(true,true,true).

or(true,_,true).
or(_,true,true).
or(false,false,false).
%------------------------------- ENVIRONMENT MANIPULATIONS----------------------
lookup(Id, [(_Type,Id, X)|_], X).
lookup(Id, [_|T], X) :- lookup(Id, T, X).

lookup_type(Id, [_|T], X) :- lookup_type(Id, T, X).
lookup_type(Id,[(Type,Id,_X)|_],Type).


add_env(Type, Id, Val, Env, NE):- T = [(Type, Id, Val)], append(Env, T, NE).
update(Type,Id, Val, [], [(Type,Id, Val)]).
update(Type,Id, Val, [(Type,Id,_)|T], [(Type,Id, Val)|T]).
update(Type,Id, Val, [H|T], [H|R]) :- update(Type,Id, Val, T, R).
%---------------------------------- SEMANTICS ------------------------------------
program_semantics(prog(X),FinalEnv) :- block_eval(X,[],FinalEnv),!.

block_eval(blk(X),Env,FinalEnv) :- bp_eval(X,Env,FinalEnv).

bp_eval(bp(X,Y),Env,FinalEnv) :- com_eval(X,Env,Env1),bp_eval(Y,Env1,FinalEnv).
bp_eval(bp(X),Env,FinalEnv) :- com_eval(X,Env,FinalEnv).

com_eval(com(X),Env,FinalEnv) :- 
    dec_eval(X,Env,FinalEnv);assign_eval(X,Env,FinalEnv);
    bool_eval(X,Env,FinalEnv,_Val);print_eval(X,Env,FinalEnv);
    if_eval(X,Env,FinalEnv);while_eval(X,Env,FinalEnv);
    for_eval(X,Env,FinalEnv);for_range_eval(X,Env,FinalEnv);
    ternary_eval(X,Env,FinalEnv);iter_eval(X,Env,FinalEnv).

dec_eval(t_dec(X,Y),Env,NE):- 
    char_tree_to_atom(Y,Id),
    update(X,Id,_,Env,NE).
dec_eval(t_int_dec(int,Y,Z),Env,NE):- 
    char_tree_to_atom(Y,Id),
    eval_expr(Z,Env,E1,Val),update(int,Id,Val,E1,NE).
dec_eval(t_str_dec(string,Y,Z),Env,NE):- 
    char_tree_to_atom(Y,Id),
    str_eval(Z,Env,NE1,Val),update(string,Id,Val,NE1,NE).
dec_eval(t_bool_dec(bool,Y,true),Env,NE):- 
    char_tree_to_atom(Y,Id),
    update(bool,Id,true,Env,NE).
dec_eval(t_bool_dec(bool,Y,false),Env,NE):- 
    char_tree_to_atom(Y,Id),
    update(bool,Id,false,Env,NE).


assign_eval(t_assign(X,Y), Env, NE) :- 
    eval_expr(Y,Env,E1,Val),check_type(Val,T),char_tree_to_atom(X,Id),
    lookup_type(Id,E1,T1),T =@= T1,update(T,Id,Val,E1,NE).
assign_eval(t_assign(X,Y), Env, NE) :- 
    str_eval(Y,Env,Env,Val),check_type(Val,T),char_tree_to_atom(X,Id),
    lookup_type(Id,Env,T1),T =@= T1,update(T,Id,Val,Env,NE).
assign_eval(t_assign(X,Y), Env, NE) :- 
   bool_eval(Y,Env,Env,Val),check_type(Val,T),char_tree_to_atom(X,Id),
   lookup_type(Id,Env,T1),T =@= T1,update(T,Id,Val,Env,NE).

bool_eval(true,_E1,_NE,true).
bool_eval(false,_E1,_NE,false).
bool_eval(t_not(B),E,NE,Val) :- (bool_eval(B,E,NE,Val1);con_eval(B,E,NE,Val1)), not(Val1,Val2), Val = Val2.
bool_eval(t_and(X,Y),E,NE,Val) :- bool_eval(X,E,NE,Val1),bool_eval(Y,E,NE,Val2), and(Val1,Val2,Val).
bool_eval(t_and(X,Y),E,NE,Val) :- con_eval(X,E,NE,Val1),con_eval(Y,E,NE,Val2), and(Val1,Val2,Val).
bool_eval(t_or(X,Y),E,NE,Val) :- bool_eval(X,E,NE,Val1),bool_eval(Y,E,NE,Val2), or(Val1,Val2,Val).
bool_eval(t_or(X,Y),E,NE,Val) :- con_eval(X,E,NE,Val1),con_eval(Y,E,NE,Val2), or(Val1,Val2,Val).

con_eval(t_cond(X,==,Y),E,NE,Val) :- eval_expr(X,E,NE,Val1),eval_expr(Y,E,NE,Val2),
    (( Val1 =:= Val2, Val = true); ( \+(Val1 =:= Val2), Val = false)).
con_eval(t_cond(X,'!=',Y),E,NE,Val) :- eval_expr(X,E,NE,Val1),eval_expr(Y,E,NE,Val2),
    (( Val1 =\= Val2, Val = true);( \+(Val1 =\= Val2), Val = false)).
con_eval(t_cond(X,'>',Y),E,NE,Val) :- eval_expr(X,E,NE,Val1),eval_expr(Y,E,NE,Val2),
    (( Val1 > Val2, Val = true);( \+(Val1 > Val2), Val = false)).
con_eval(t_cond(X,'<',Y),E,NE,Val) :- eval_expr(X,E,NE,Val1),eval_expr(Y,E,NE,Val2),
    (( Val1 < Val2, Val = true);( \+(Val1 < Val2), Val = false)).
con_eval(t_cond(X,'>=',Y),E,NE,Val) :- eval_expr(X,E,NE,Val1),eval_expr(Y,E,NE,Val2),
    (( Val1 >= Val2, Val = true);( \+(Val1 >= Val2), Val = false)).
con_eval(t_cond(X,'<=',Y),E,NE,Val) :- eval_expr(X,E,NE,Val1),eval_expr(Y,E,NE,Val2),
    (( Val1 =< Val2, Val = true);( \+(Val1 =< Val2), Val = false)).
con_eval(t_cond(X,==,Y),E,NE,Val) :- str_eval(X,E,NE,Val1),str_eval(Y,E,NE,Val2),
    ((Val1 = Val2, Val = true);(\+(Val1 = Val2), Val = false)).
con_eval(t_cond(X,'!=',Y),E,NE,Val) :- str_eval(X,E,NE,Val1),str_eval(Y,E,NE,Val2),
    ((Val1 = Val2, Val = false);(\+(Val1 = Val2), Val = true)).
con_eval(t_cond(X,'>',Y),E,NE,_Val) :- str_eval(X,E,NE,_Val1),str_eval(Y,E,NE,_Val2),
    write("cannot perform this operation on strings").
con_eval(t_cond(X,'<',Y),E,NE,_Val) :- str_eval(X,E,NE,_Val1),str_eval(Y,E,NE,_Val2),
    write("cannot perform this operation on strings").
con_eval(t_cond(X,'>=',Y),E,NE,_Val) :- str_eval(X,E,NE,_Val1),str_eval(Y,E,NE,_Val2),
    write("cannot perform this operation on strings").
con_eval(t_cond(X,'<=',Y),E,NE,_Val) :- str_eval(X,E,NE,_Val1),str_eval(Y,E,NE,_Val2),
    write("cannot perform this operation on strings").
con_eval(t_cond(X,==,Y),E,NE,Val) :- char_tree_to_atom(X,Id),lookup(Id,E,Val1),
    check_type(Val1,T),T=string,str_eval(Y,E,NE,Val2),
    ((Val1 =@= Val2, Val = true);(\+(Val1 =@= Val2), Val = false)).
con_eval(t_cond(X,'!=',Y),E,NE,Val) :- char_tree_to_atom(X,Id),lookup(Id,E,Val1),check_type(Val1,T),
    T=string,str_eval(Y,E,NE,Val2),
    ((Val1 = Val2, Val = false);(\+(Val1 = Val2), Val = true)).
con_eval(t_cond(X,'>',Y),E,NE,_Val) :- char_tree_to_atom(X,Id),lookup(Id,E,Val1),check_type(Val1,T),
    T=string,str_eval(Y,E,NE,_Val2),
    write("cannot perform this operation on strings").
con_eval(t_cond(X,'<',Y),E,NE,_Val) :- char_tree_to_atom(X,Id),lookup(Id,E,Val1),check_type(Val1,T),
    T=string,str_eval(Y,E,NE,_Val2),
    write("cannot perform this operation on strings").
con_eval(t_cond(X,'>=',Y),E,NE,_Val) :- char_tree_to_atom(X,Id),lookup(Id,E,Val1),check_type(Val1,T),
    T=string,str_eval(Y,E,NE,_Val2),
    write("cannot perform this operation on strings").
con_eval(t_cond(X,'<=',Y),E,NE,_Val) :- char_tree_to_atom(X,Id),lookup(Id,E,Val1),check_type(Val1,T),
    T=string,str_eval(Y,E,NE,_Val2),
    write("cannot perform this operation on strings").



print_eval(out(X),Env,Env) :- char_tree_to_atom(X,Id),lookup(Id,Env,Val),writeln(Val).
print_eval(out(X),Env,Env) :- num_tree(X,Val),writeln(Val).
print_eval(out(X),Env,Env) :- str_eval(X,Env,Env,Val),writeln(Val).

if_eval(t_if(X,Y),Env,FinalEnv):- ((con_eval(X,Env,NE,true);bool_eval(X,Env,NE,true)),block_eval(Y,NE,FinalEnv)).
if_eval(t_if(X,_Y),Env,NE):- con_eval(X,Env,NE,false);bool_eval(X,Env,NE,false).
if_eval(t_if(X,Y,_Z),Env,FinalEnv):- (con_eval(X,Env,NE,true);bool_eval(X,Env,NE,true)),block_eval(Y,NE,FinalEnv).
if_eval(t_if(X,_Y,Z),Env,FinalEnv):- (con_eval(X,Env,NE,false);bool_eval(X,Env,NE,false)),block_eval(Z,NE,FinalEnv).

while_eval(t_while(X,Y),Env,FinalEnv):- 
    bool_eval(X,Env,NE,true),block_eval(Y,NE,NE1),while_eval(t_while(X,Y),NE1,FinalEnv).
while_eval(t_while(X,_Y),Env,Env) :- bool_eval(X,Env,Env,false).

while_eval(t_while(X,Y),Env,FinalEnv):- 
    con_eval(X,Env,NE,true),block_eval(Y,NE,NE1),while_eval(t_while(X,Y),NE1,FinalEnv).
while_eval(t_while(X,_Y),Env,Env) :- con_eval(X,Env,Env,false).

for_eval(t_for(X,Y,Z,W),Env,FinalEnv):- 
    dec_eval(X,Env,NE),looper(Y,Z,W,NE,FinalEnv).
for_eval(t_for(X,Y,Z,W),Env,FinalEnv):- 
    assign_eval(X,Env,NE),looper(Y,Z,W,NE,FinalEnv).
looper(X,Y,Z,Env,FinalEnv) :- 
    con_eval(X,Env,Env,true),block_eval(Z,Env,NE),
    (iter_eval(Y,NE,NE1);eval_expr(Y,NE,NE1)),looper(X,Y,Z,NE1,FinalEnv).
looper(X,_Y,_Z,Env,Env) :- con_eval(X,Env,Env,false).
looper(X,Y,Z,Env,FinalEnv) :- 
    bool_eval(X,Env,Env,true),block_eval(Z,Env,NE),
    (iter_eval(Y,NE,NE1);eval_expr(Y,NE,NE1)),looper(X,Y,Z,NE1,FinalEnv).
looper(X,_Y,_Z,Env,Env) :- bool_eval(X,Env,Env,false).

for_range_eval(t_for_range(X,Y,Z,W),Env,FinalEnv):- 
    char_tree_to_atom(X,Id),
    ((num_tree(Y,Val),update(int,Id,Val,Env,NE));
    (lookup(Y,Env,Val),update(int,Id,Val,Env,NE))),
    ((num_tree(Z,N));
    (char_tree_to_atom(Z,Id1),lookup(Id1,NE,N))),
    looper2(Id,N,W,NE,FinalEnv).

looper2(X,Z,W,Env,FinalEnv):- 
    lookup(X,Env,Val),Val < Z, block_eval(W,Env,NE),Val1 is Val + 1,
    update(int, X, Val1, NE, NE1),looper2(X,Z,W,NE1,FinalEnv).
looper2(X,Z,_W,Env,Env) :- 
    lookup(X,Env,Val), Val >= Z.

ternary_eval(t_ternary(X,Y,_Z),Env,FinalEnv):- (con_eval(X,Env,NE,true);bool_eval(X,Env,NE,true)),com_eval(Y,NE,FinalEnv).
ternary_eval(t_ternary(X,_Y,Z),Env,FinalEnv):- (con_eval(X,Env,NE,false);bool_eval(X,Env,NE,false)),com_eval(Z,NE,FinalEnv).

iter_eval(t_plus(X),Env,NE) :- 
    char_tree_to_atom(X,Id),lookup_type(Id,Env,int),lookup(Id,Env,Val),
    Val1 is Val + 1, update(int,Id,Val1,Env,NE).

iter_eval(t_minus(X),Env,NE) :- 
    char_tree_to_atom(X,Id),lookup_type(Id,Env,int),lookup(Id,Env,Val),
    Val1 is Val - 1, update(int,Id,Val1,Env,NE).

eval_expr(X, Env, NE) :- assign_eval(X,Env,NE).
eval_expr(X, Env, NE, Val) :- eval_term(X, Env, NE, Val).
eval_expr(t_sub(X,Y), Env, NE, Val):-
    eval_expr(X, Env, E1, Val1), eval_term(Y, E1, NE, Val2),
    Val is Val1 - Val2.
eval_term(X, Env, NE, Val) :- eval_term1(X, Env, NE, Val).
eval_term(t_add(X,Y), Env, NE, Val):-
    eval_term(X, Env, E1, Val1), eval_term1(Y, E1, NE, Val2),
    Val is Val1 + Val2.
eval_term1(X, Env, NE, Val) :- eval_term2(X, Env,NE, Val).
eval_term1(t_mult(X,Y), Env, NE, Val):-
    eval_term1(X, Env, E1, Val1), eval_term2(Y, E1, NE, Val2),
    Val is Val1 * Val2.
eval_term2(X, Env, NE, Val) :- eval_term3(X, Env, NE, Val).
eval_term2(t_div(X,Y),  Env, NE, Val):-
    eval_term2(X, Env, E1, Val1), eval_term3(Y, E1, NE, Val2),
    Val is floor(Val1 / Val2).
eval_term3(X,  Env, NE, Val) :- eval_num(X, Env,NE, Val).
eval_term3(t_bracks(X), Env, NE, Val):- eval_expr(X, Env, NE, Val).

eval_num(t_num(Val), Env,Env, Val).
eval_num(id(I), Env,Env, Val) :- term_to_atom(Id,I),lookup(Id, Env, Val).
num_tree(t_num(Val),Val).
char_tree_to_atom(id(I),Id):- term_to_atom(Id,I).
str_eval(op(I), Env,Env, Val) :- atom_string(I,Val).




/** <examples>
?- trace, (program(T,['begin', '{', 'string', 'a', '=', '”Hello World”', ';','print','(','a',')',';','}', 'end', '.'],[]),program_semantics(T,Final)).
*/
