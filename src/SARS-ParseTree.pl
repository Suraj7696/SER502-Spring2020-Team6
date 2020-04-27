:- use_rendering(svgtree).
program(prog(X)) -->[begin], block(X),[end],[.].

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

bool(true) --> [true].
bool(false) --> [false].
bool(t_not(X)) --> [not],['('],bool(X),[')'].
bool(t_not(X)) --> [not],['('],condition(X),[')'].
bool(t_and(X,Y)) --> bool(X), [and], bool(Y).
bool(t_and(X,Y)) --> ['('],condition(X),[')'], [and], ['('],condition(Y),[')'].
bool(t_or(X,Y)) --> bool(X), [or], bool(Y).
bool(t_or(X,Y)) --> ['('],condition(X),[')'], [or], ['('],condition(Y),[')'].



declaration(t_int_dec(int,X,Y)) --> [int], id(X), [=], expression(Y).
declaration(t_str_dec(string,X,Y)) --> [string], id(X), [=], string(Y).
declaration(t_bool_dec(bool,X,true)) --> [bool], id(X), [=], [true].
declaration(t_bool_dec(bool,X,false)) --> [bool], id(X), [=], [false].
declaration(t_dec(X,Y)) --> type(X), id(Y).

assignment(t_assign(X,Y)) --> id(X), [=], expression(Y).
assignment(t_assign(X,Y)) --> id(X), [=], string(Y).
assignment(t_assign(X,Y)) --> id(X), [=], bool(Y).

type(int) --> [int].
type(string) -->[string].
type(bool) --> [bool].

for(t_for(X,Y,Z,W)) --> [for],['('],declaration(X),[;],condition(Y),[;],iterator(Z),[;],[')'],block(W).
for(t_for(X,Y,Z,W)) -->[for],['('],declaration(X),[;],condition(Y),[;],expression(Z),[;],[')'],block(W).
for(t_for(X,Y,Z,W)) --> [for],['('],assignment(X),[;],condition(Y),[;],iterator(Z),[;],[')'],block(W).
for(t_for(X,Y,Z,W)) -->[for],['('],assignment(X),[;],condition(Y),[;],expression(Z),[;],[')'],block(W).

while(t_while(X,Y)) --> [while], ['('],(condition(X);bool(X)),[')'], block(Y).

for_range(t_for_range(X,Y,Z,W)) --> [for], id(X), [in],[range],['('],num(Y),[:],num(Z),[')'],block(W).
for_range(t_for_range(X,Y,Z,W)) --> [for], id(X), [in],[range],['('],id(Y),[:],id(Z),[')'],block(W).
for_range(t_for_range(X,Y,Z,W)) --> [for], id(X), [in],[range],['('],num(Y),[:],id(Z),[')'],block(W).
for_range(t_for_range(X,Y,Z,W)) --> [for], id(X), [in],[range],['('],id(Y),[:],num(Z),[')'],block(W).

if(t_if(X,Y)) --> [if],['('],condition(X),[')'], block(Y) .
if(t_if(X,Y,Z)) --> [if],['('],condition(X),[')'], block(Y), [else], block(Z).

ternary(t_ternary(X,U,V)) --> condition(X), [?], block(U), [:], block(V).

output(out(X)) --> [print], ['('], id(X),[')'].
output(out(X)) --> [print], ['('], num(X),[')'].
output(out(X)) --> [print], ['('], string(X),[')'].

condition(t_cond(X,Y,Z)) --> expression(X), condition_operator(Y), expression(Z).
condition(t_cond(X,Y,Z)) --> string(X), condition_operator(Y), string(Z).
condition(t_cond(X,Y,Z)) --> id(X), condition_operator(Y), string(Z).

condition_operator(==) --> [==].
condition_operator('!=') --> ['!='].
condition_operator('>') --> ['>'].
condition_operator('<') --> ['<'].
condition_operator('>=') --> ['>='].
condition_operator('<=') --> ['<='].

:- table expression/3,term/3.

expression(X) --> assignment(X).
expression(t_add(X,Y)) --> expression(X), [+], term(Y).
expression(t_sub(X,Y)) --> expression(X), [-], term(Y).
expression(X) --> term(X).
term(t_mult(X,Y)) --> term(X), [*], term(Y).
term(t_div(X,Y)) --> term(X), [/], term(Y).
term(X) --> ['('], expression(X), [')'].
term(X) --> num(X); id(X).

iterator(t_plus(X)) --> id(X), [++].
iterator(t_minus(X)) --> id(X), [--].

num(t_num(X,Y)) --> digit(X),num(Y).
num(t_num(X)) --> digit(X).

digit(0) --> [0].
digit(1) --> [1].
digit(2) --> [2].
digit(3) --> [3].
digit(4) --> [4].
digit(5) --> [5].
digit(6) --> [6].
digit(7) --> [7].
digit(8) --> [8].
digit(9) --> [9].

id(id(X,Y)) --> lowerchar(X),id1(Y).
id(id(X)) --> lowerchar(X).
id1(id1(X,Y)) --> (num(X);upperchar(X);lowerchar(X)),id1(Y).
id1(id1(X)) --> num(X);upperchar(X);lowerchar(X).

:- table openstring/3, letterstring/3.
string(t_str(X)) --> ['\"'],openstring(X),['\"'].
openstring(op(X,Y)) --> letterstring(X),openstring(Y).
openstring(op(X,Y)) --> num(X),openstring(Y).
openstring(op(X)) --> num(X).
openstring(op(Y)) --> letterstring(Y).
openstring(op(t)) --> [].
letterstring(ls(X)) --> letter(X).
letterstring(ls(X,Y)) --> letter(X),letterstring(Y).

letter(X) --> lowerchar(X); upperchar(X).
lowerchar(a) --> [a].
lowerchar(b) --> [b].
lowerchar(c) --> [c].
lowerchar(d) --> [d].
lowerchar(e) --> [e].
lowerchar(f) --> [f].
lowerchar(g) --> [g].
lowerchar(h) --> [h].
lowerchar(i) --> [i].
lowerchar(j) --> [j].
lowerchar(k) --> [k].
lowerchar(l) --> [l].
lowerchar(m) --> [m].
lowerchar(n) --> [n].
lowerchar(o) --> [o].
lowerchar(p) --> [p].
lowerchar(q) --> [q].
lowerchar(r) --> [r].
lowerchar(s) --> [s].
lowerchar(t) --> [t].
lowerchar(u) --> [u].
lowerchar(v) --> [v].
lowerchar(w) --> [w].
lowerchar(x) --> [x].
lowerchar(y) --> [y].
lowerchar(z) --> [z].

upperchar('A') --> ['A'].
upperchar('B') --> ['B'].
upperchar('C') --> ['C'].
upperchar('D') --> ['D'].
upperchar('E') --> ['E'].
upperchar('F') --> ['F'].
upperchar('G') --> ['G'].
upperchar('H') --> ['H'].
upperchar('I') --> ['I'].
upperchar('J') --> ['J'].
upperchar('K') --> ['K'].
upperchar('L') --> ['L'].
upperchar('M') --> ['M'].
upperchar('N') --> ['N'].
upperchar('O') --> ['O'].
upperchar('P') --> ['P'].
upperchar('Q') --> ['Q'].
upperchar('R') --> ['R'].
upperchar('S') --> ['S'].
upperchar('T') --> ['T'].
upperchar('U') --> ['U'].
upperchar('V') --> ['V'].
upperchar('W') --> ['W'].
upperchar('X') --> ['X'].
upperchar('Y') --> ['Y'].
upperchar('Z') --> ['Z'].