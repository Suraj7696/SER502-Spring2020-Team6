:- use_rendering(svgtree).
program(prog(X)) --> block(X).

block(blk(X)) --> ['{'],block_part(X),['}'].

block_part(bp(X,Y)) --> command(X), block_part(Y).
block_part(bp(X)) --> command(X).

command(t_com(X)) --> declaration(X),[;].
command(X) --> assignment(X),[;].
command(X) -->expression(X),[;].
command(X) -->bool(X),[;].
command(X) -->output(X),[;].
command(X) -->if(X).
command(X) --> ternary(X),[;].
command(X) -->for(X).
command(X) -->while(X).
command(X) -->for_range(X).
command(X) --> iterator(X),[;].

:- table bool/3.
bool(true) --> [true].
bool(false) --> [false].
bool(t_eq(X,Y)) --> expression(X), [=], expression(Y).
bool(t_not(X)) --> [not],['('],bool(X),[')'].
bool(t_and(X,Y)) --> bool(X), [and], bool(Y).
bool(t_or(X,Y)) --> bool(X), [or], bool(Y).
bool(X) --> condition(X).

declaration(t_int_dec(X,Y)) --> [int], id(X), [=], num(Y).
declaration(t_str_dec(X,Y)) --> [string], id(X), [=], string(Y).
declaration(t_bool_dec(X,true)) --> [bool], id(X), [=], [true].
declaration(t_bool_dec(X,false)) --> [bool], id(X), [=], [true].
declaration(t_dec(X,Y)) --> type(X), id(Y).

assignment(t_assign(X,Y)) --> id(X), [=], expression(Y).
assignment(t_assign(X,Y)) --> id(X), [=], string(Y).
assignment(t_assign(X,Y)) --> id(X), [=], bool(Y).

type(int) --> [int].
type(int) -->[string].
type(int) --> [bool].

for(t_for(X,Y,Z,W)) --> [for],['('],assignment(X),[;],condition(Y),[;],iterator(Z),[;],[')'],block(W).
for(t_for(X,Y,Z,W)) -->[for],['('],assignment(X),[;],condition(Y),[;],expression(Z),[;],[')'],block(W).

while(t_while(X,Y)) --> [while], ['('], condition(X),[')'], block(Y).

for_range(t_for_range(X,Y,Z,W)) --> [for], id(X), [in],[range],['('],num(Y),num(Z),[')'],block(W).
for_range(t_for_range(X,Y,Z,W)) --> [for], id(X), [in],[range],['('],id(Y),id(Z),[')'],block(W).
for_range(t_for_range(X,Y,Z,W)) --> [for], id(X), [in],[range],['('],num(Y),id(Z),[')'],block(W).
for_range(t_for_range(X,Y,Z,W)) --> [for], id(X), [in],[range],['('],id(Y),num(Z),[')'],block(W).

if(t_if(X,Y)) --> [if],['('],condition(X),[')'], block(Y) .
if(t_if(X,Y,Z)) --> [if],['('],condition(X),[')'], block(Y), [else], block(Z).

ternary(t_ternary(X,Y,Z,U,V)) --> expression(X), condition_operator(Y), expression(Z), [?], block(U), [:], block(V).
ternary(t_ternary(X,Y,Z,U,V)) --> id(X), condition_operator(Y), string(Z), [?], block(U), [:], block(V).

output(t_out(X)) --> [print], ['('], id(X),[')'].
output(X) --> [print], ['('], num(X),[')'].
output(X) --> [print], ['('], string(X),[')'].

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
expression(t_add(X,Y)) --> expression(X), [+], term(Y).
expression(t_sub(X,Y)) --> expression(X), [-], term(Y).
expression(X) --> term(X).
term(t_mult(X,Y)) --> term(X), [*], term(Y).
term(t_div(X,Y)) --> term(X), [/], term(Y).
term(X) --> ['('], expression(X), [')'].
term(X) --> num(X); id(X).

iterator(t_plus(X)) --> id(X), [++].
iterator(t_minus(X)) --> id(X), [--].

:- table num/3.
num(t_num(X,Y)) --> num(X),digit(Y).
num(t_num(X)) --> digit(X).

digit(t_digit(0)) --> [0].
digit(t_digit(1)) --> [1].
digit(t_digit(2)) --> [2].
digit(t_digit(3)) --> [3].
digit(t_digit(4)) --> [4].
digit(t_digit(5)) --> [5].
digit(t_digit(6)) --> [6].
digit(t_digit(7)) --> [7].
digit(t_digit(8)) --> [8].
digit(t_digit(9)) --> [9].

id(t_id(X,Y)) --> lowerchar(X), id(Y).
id(t_id(X,Y)) --> num(X), id(Y).
id(t_id(X)) --> lowerchar(X);num(X).

:- table openstring/3, letterstring/3.
string(t_str(X)) --> ['\"'],openstring(X),['\"'].
openstring(op(X,Y)) --> openstring(X),letterstring(Y).
openstring(op(X,Y)) --> openstring(X),num(Y).
openstring(_) --> [].
letterstring(ls(X)) --> letter(X).
letterstring(ls(X,Y)) -->  letterstring(X),letter(Y).

letter(X) --> lowerchar(X); upperchar(X).
lowerchar(t_lowC(a)) --> [a].
lowerchar(t_lowC(b)) --> [b].
lowerchar(t_lowC(c)) --> [c].
lowerchar(t_lowC(d)) --> [d].
lowerchar(t_lowC(e)) --> [e].
lowerchar(t_lowC(f)) --> [f].
lowerchar(t_lowC(g)) --> [g].
lowerchar(t_lowC(h)) --> [h].
lowerchar(t_lowC(i)) --> [i].
lowerchar(t_lowC(j)) --> [j].
lowerchar(t_lowC(k)) --> [k].
lowerchar(t_lowC(l)) --> [l].
lowerchar(t_lowC(m)) --> [m].
lowerchar(t_lowC(n)) --> [n].
lowerchar(t_lowC(o)) --> [o].
lowerchar(t_lowC(p)) --> [p].
lowerchar(t_lowC(q)) --> [q].
lowerchar(t_lowC(r)) --> [r].
lowerchar(t_lowC(s)) --> [s].
lowerchar(t_lowC(t)) --> [t].
lowerchar(t_lowC(u)) --> [u].
lowerchar(t_lowC(v)) --> [v].
lowerchar(t_lowC(w)) --> [w].
lowerchar(t_lowC(x)) --> [x].
lowerchar(t_lowC(y)) --> [y].
lowerchar(t_lowC(z)) --> [z].

upperchar(t_upC('A')) --> ['A'].
upperchar(t_upC('B')) --> ['B'].
upperchar(t_upC('C')) --> ['C'].
upperchar(t_upC('D')) --> ['D'].
upperchar(t_upC('E')) --> ['E'].
upperchar(t_upC('F')) --> ['F'].
upperchar(t_upC('G')) --> ['G'].
upperchar(t_upC('H')) --> ['H'].
upperchar(t_upC('I')) --> ['I'].
upperchar(t_upC('J')) --> ['J'].
upperchar(t_upC('K')) --> ['K'].
upperchar(t_upC('L')) --> ['L'].
upperchar(t_upC('M')) --> ['M'].
upperchar(t_upC('N')) --> ['N'].
upperchar(t_upC('O')) --> ['O'].
upperchar(t_upC('P')) --> ['P'].
upperchar(t_upC('Q')) --> ['Q'].
upperchar(t_upC('R')) --> ['R'].
upperchar(t_upC('S')) --> ['S'].
upperchar(t_upC('T')) --> ['T'].
upperchar(t_upC('U')) --> ['U'].
upperchar(t_upC('V')) --> ['V'].
upperchar(t_upC('W')) --> ['W'].
upperchar(t_upC('X')) --> ['X'].
upperchar(t_upC('Y')) --> ['Y'].
upperchar(t_upC('Z')) --> ['Z'].