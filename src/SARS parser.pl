program --> block.

block --> ['{'],block_part,['}'].

block_part --> command, block_part.
block_part --> command.

command --> declaration,[;].
command --> while.
command --> assignment,[;].
command -->output,[;].
command -->if.
command --> ternary,[;].
command -->for.
command -->for_range.
command --> iterator, [;].

type --> [int].
type --> [string].
type --> [bool].

declaration --> [int], id, [=], num.
declaration --> [string], id, [=], string.
declaration --> [bool], id, [=], [true].
declaration --> [bool], id, [=], [false]. 
declaration --> type, id.

assignment --> id, [=], expression.
assignment --> id, [=], string.
assignment --> id, [=], bool.

:- table bool/2.
bool --> [true].
bool --> [false].
bool --> [not],['('],bool,[')'].
bool --> bool, [and], bool.
bool --> bool, [or], bool.
bool --> condition.

condition --> expression, condition_operator, expression.
condition --> string, condition_operator, string.
condition --> id, condition_operator, string.

condition_operator --> [==];['!='];['>'];['<'];['>='];['<='].




for --> [for],['('],assignment,[;],condition,[;],iterator,[;],[')'],block.
for --> [for],['('],assignment,[;],condition,[;],expression,[;],[')'],block.

while --> [while], ['('], condition,[')'], block.

for_range --> [for], id, [in],[range],['('],num,num,[')'],block.
for_range --> [for], id, [in],[range],['('],id,id,[')'],block.
for_range --> [for], id, [in],[range],['('],num,id,[')'],block.
for_range --> [for], id, [in],[range],['('],id,num,[')'],block.

if --> [if],['('],condition,[')'], block .
if --> [if],['('],condition,[')'], block, [else], block.

ternary --> expression, condition_operator, expression, [?], block, [:], block.
ternary --> id, condition_operator, string, [?], block, [:], block.

output --> [print], ['('], id,[')'].
output --> [print], ['('], num,[')'].
output --> [print], ['('], string,[')'].



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

:- table num/2.
num --> num,digit.
num --> digit.
digit --> [0];[1];[2];[3];[4];[5];[6];[7];[8];[9].

id --> lowerchar, id.
id --> num, id.
id --> num;lowerchar.

:- table openstring/2, letterstring/2.
string --> ['\"'],openstring,['\"'].
openstring --> openstring,letterstring.
openstring --> openstring,num.
openstring --> [].
letterstring --> letter.
letterstring -->  letterstring,letter.

letter --> lowerchar; upperchar.
lowerchar --> [a];[b];[c];[d];[e];[f];[g];[h];[i];
    [j];[k];[l];[m];[n];[o];[p];[q];[r];[s];[t];
    [u];[v];[w];[x];[y];[z].
upperchar --> ['A'];['B'];['C'];['D'];['E'];['F'];['G'];['H'];['I'];['J']
    ;['K'];['L'];['M'];['N'];['O'];['P'];['Q'];['R'];['S'];['T'];['U'];['V'];
    ['W'];['X'];['Y'];['Z'].