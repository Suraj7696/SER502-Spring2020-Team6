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

for(t_for(X,Y,Z,W)) --> ['for'],['('],declaration(X),[';'],condition(Y),[';'],iterator(Z),[')'],block(W).
for(t_for(X,Y,Z,W)) -->['for'],['('],declaration(X),[';'],condition(Y),[';'],expression(Z),[')'],block(W).
for(t_for(X,Y,Z,W)) --> ['for'],['('],assignment(X),[';'],condition(Y),[';'],iterator(Z),[')'],block(W).
for(t_for(X,Y,Z,W)) -->['for'],['('],assignment(X),[';'],condition(Y),[';'],expression(Z),[')'],block(W).

while(t_while(X,Y)) --> ['while'], ['('],(condition(X);bool(X)),[')'], block(Y).

for_range(t_for_range(X,Y,Z,W)) --> ['for'], id(X), ['in'],['range'],['('],num(Y),[':'],num(Z),[')'],block(W).
for_range(t_for_range(X,Y,Z,W)) --> ['for'], id(X), ['in'],['range'],['('],id(Y),[':'],id(Z),[')'],block(W).
for_range(t_for_range(X,Y,Z,W)) --> ['for'], id(X), ['in'],['range'],['('],num(Y),[':'],id(Z),[')'],block(W).
for_range(t_for_range(X,Y,Z,W)) --> ['for'], id(X), ['in'],['range'],['('],id(Y),[':'],num(Z),[')'],block(W).

if(t_if(X,Y)) --> ['if'],['('],condition(X),[')'], block(Y) .
if(t_if(X,Y,Z)) --> ['if'],['('],condition(X),[')'], block(Y), ['else'], block(Z).

ternary(t_ternary(X,U,V)) --> condition(X), ['?'], command(U), [':'], command(V).

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
expression(X) --> assignment(X).
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