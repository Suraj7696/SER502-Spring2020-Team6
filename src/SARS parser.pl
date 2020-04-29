program --> block.

block --> ['{'],block_part,['}'].

block_part --> command, block_part.
block_part --> command.

command --> declaration,[;].
command --> assignment,[;].
command -->expression,[;].
command -->bool,[;].
command -->output,[;].
command -->if.
command --> ternary,[;].
command -->for.
command -->while.
command -->for_range.
command --> iterator,[;].

:- table bool/2.

bool --> [true].
bool --> [false].
%bool(t_eq(X,Y)) --> expression(X), [=], expression(Y).
bool --> [not],['('],bool,[')'].
bool --> bool, [and], bool.
bool --> bool, [or], bool.

declaration --> [int], id, [=], num.
declaration --> [string], id, [=], string.
declaration --> [bool], id, [=], [true].
declaration --> [bool], id, [=], [false].
declaration --> type, id.

assignment --> id(X), [=], expression.
assignment --> id(X), [=], string.
assignment --> id(X), [=], bool.

type --> [int].
type -->[string].
type --> [bool].

for --> [for],['('],assignment,[;],condition,[;],iterator,[;],[')'],block.
for -->[for],['('],assignment,[;],condition,[;],expression,[;],[')'],block.

while --> [while], ['('], condition,[')'], block.

for_range --> [for], id, [in],[range],['('],num,[:],num,[')'],block.
for_range --> [for], id, [in],[range],['('],id,[:],id,[')'],block.
for_range --> [for], id, [in],[range],['('],num,[:],id,[')'],block.
for_range --> [for], id, [in],[range],['('],id,[:],num,[')'],block.

if --> [if],['('],condition,[')'], block .
if --> [if],['('],condition,[')'], block, [else], block.

ternary --> condition, [?], block, [:], block.

output --> [print], ['('], id,[')'].
output --> [print], ['('], num,[')'].
output --> [print], ['('], string,[')'].

condition --> expression, condition_operator, expression.
condition --> string, condition_operator, string.
condition --> id, condition_operator, string.

condition_operator --> [==].
condition_operator --> ['!='].
condition_operator --> ['>'].
condition_operator --> ['<'].
condition_operator --> ['>='].
condition_operator --> ['<='].

:- table expression/2,term/2.
expression --> expression, [+], term.
expression --> expression, [-], term.
expression --> term.
term --> term, [*], term.
term --> term, [/], term.
term --> ['('], expression, [')'].
term --> num; id.

iterator --> id, [++].
iterator --> id, [--].

num --> digit,num.
num --> digit.

digit --> [0].
digit --> [1].
digit --> [2].
digit --> [3].
digit --> [4].
digit --> [5].
digit --> [6].
digit --> [7].
digit --> [8].
digit --> [9].

id --> lowerchar,id1.
id --> lowerchar.
id1 --> (num;upperchar;lowerchar),id1.
id1 --> num;upperchar;lowerchar.

:- table openstring/2, letterstring/2.
string --> ['\"'],openstring,['\"'].
openstring --> letterstring,openstring.
openstring --> num,openstring.
openstring --> num.
openstring --> letterstring.
openstring --> [].
letterstring --> letter.
letterstring --> letter,letterstring.

letter --> lowerchar; upperchar.
letter --> lowerchar; upperchar.
lowerchar --> [a];[b];[c];[d];[e];[f];[g];[h];[i];
    [j];[k];[l];[m];[n];[o];[p];[q];[r];[s];[t];
    [u];[v];[w];[x];[y];[z].
upperchar --> ['A'];['B'];['C'];['D'];['E'];['F'];['G'];['H'];['I'];['J']
    ;['K'];['L'];['M'];['N'];['O'];['P'];['Q'];['R'];['S'];['T'];['U'];['V'];
    ['W'];['X'];['Y'];['Z'].