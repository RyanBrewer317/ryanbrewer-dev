-module(lustre@element@html).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([html/2, text/1, base/1, head/2, link/1, meta/1, style/2, title/2, body/2, address/2, article/2, aside/2, footer/2, header/2, h1/2, h2/2, h3/2, h4/2, h5/2, h6/2, hgroup/2, main/2, nav/2, section/2, search/2, blockquote/2, dd/2, 'div'/2, dl/2, dt/2, figcaption/2, figure/2, hr/1, li/2, menu/2, ol/2, p/2, pre/2, ul/2, a/2, abbr/2, b/2, bdi/2, bdo/2, br/1, cite/2, code/2, data/2, dfn/2, em/2, i/2, kbd/2, mark/2, q/2, rp/2, rt/2, ruby/2, s/2, samp/2, small/2, span/2, strong/2, sub/2, sup/2, time/2, u/2, var/2, wbr/1, area/1, audio/2, img/1, map/2, track/1, video/2, embed/1, iframe/1, object/1, picture/2, portal/1, source/1, svg/2, math/2, canvas/1, noscript/2, script/2, del/2, ins/2, caption/2, col/1, colgroup/2, table/2, tbody/2, td/2, tfoot/2, th/2, thead/2, tr/2, button/2, datalist/2, fieldset/2, form/2, input/1, label/2, legend/2, meter/2, optgroup/2, option/2, output/2, progress/2, select/2, textarea/2, details/2, dialog/2, summary/2, slot/1, template/2]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-file("src/lustre/element/html.gleam", 9).
?DOC("\n").
-spec html(
    list(lustre@internals@vdom:attribute(RAO)),
    list(lustre@internals@vdom:element(RAO))
) -> lustre@internals@vdom:element(RAO).
html(Attrs, Children) ->
    lustre@element:element(<<"html"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 16).
-spec text(binary()) -> lustre@internals@vdom:element(any()).
text(Content) ->
    lustre@element:text(Content).

-file("src/lustre/element/html.gleam", 23).
?DOC("\n").
-spec base(list(lustre@internals@vdom:attribute(RAW))) -> lustre@internals@vdom:element(RAW).
base(Attrs) ->
    lustre@element:element(<<"base"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 28).
?DOC("\n").
-spec head(
    list(lustre@internals@vdom:attribute(RBA)),
    list(lustre@internals@vdom:element(RBA))
) -> lustre@internals@vdom:element(RBA).
head(Attrs, Children) ->
    lustre@element:element(<<"head"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 36).
?DOC("\n").
-spec link(list(lustre@internals@vdom:attribute(RBG))) -> lustre@internals@vdom:element(RBG).
link(Attrs) ->
    lustre@element:element(<<"link"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 41).
?DOC("\n").
-spec meta(list(lustre@internals@vdom:attribute(RBK))) -> lustre@internals@vdom:element(RBK).
meta(Attrs) ->
    lustre@element:element(<<"meta"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 46).
?DOC("\n").
-spec style(list(lustre@internals@vdom:attribute(RBO)), binary()) -> lustre@internals@vdom:element(RBO).
style(Attrs, Css) ->
    lustre@element:element(<<"style"/utf8>>, Attrs, [text(Css)]).

-file("src/lustre/element/html.gleam", 51).
?DOC("\n").
-spec title(list(lustre@internals@vdom:attribute(RBS)), binary()) -> lustre@internals@vdom:element(RBS).
title(Attrs, Content) ->
    lustre@element:element(<<"title"/utf8>>, Attrs, [text(Content)]).

-file("src/lustre/element/html.gleam", 58).
?DOC("\n").
-spec body(
    list(lustre@internals@vdom:attribute(RBW)),
    list(lustre@internals@vdom:element(RBW))
) -> lustre@internals@vdom:element(RBW).
body(Attrs, Children) ->
    lustre@element:element(<<"body"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 68).
?DOC("\n").
-spec address(
    list(lustre@internals@vdom:attribute(RCC)),
    list(lustre@internals@vdom:element(RCC))
) -> lustre@internals@vdom:element(RCC).
address(Attrs, Children) ->
    lustre@element:element(<<"address"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 76).
?DOC("\n").
-spec article(
    list(lustre@internals@vdom:attribute(RCI)),
    list(lustre@internals@vdom:element(RCI))
) -> lustre@internals@vdom:element(RCI).
article(Attrs, Children) ->
    lustre@element:element(<<"article"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 84).
?DOC("\n").
-spec aside(
    list(lustre@internals@vdom:attribute(RCO)),
    list(lustre@internals@vdom:element(RCO))
) -> lustre@internals@vdom:element(RCO).
aside(Attrs, Children) ->
    lustre@element:element(<<"aside"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 92).
?DOC("\n").
-spec footer(
    list(lustre@internals@vdom:attribute(RCU)),
    list(lustre@internals@vdom:element(RCU))
) -> lustre@internals@vdom:element(RCU).
footer(Attrs, Children) ->
    lustre@element:element(<<"footer"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 100).
?DOC("\n").
-spec header(
    list(lustre@internals@vdom:attribute(RDA)),
    list(lustre@internals@vdom:element(RDA))
) -> lustre@internals@vdom:element(RDA).
header(Attrs, Children) ->
    lustre@element:element(<<"header"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 108).
?DOC("\n").
-spec h1(
    list(lustre@internals@vdom:attribute(RDG)),
    list(lustre@internals@vdom:element(RDG))
) -> lustre@internals@vdom:element(RDG).
h1(Attrs, Children) ->
    lustre@element:element(<<"h1"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 116).
?DOC("\n").
-spec h2(
    list(lustre@internals@vdom:attribute(RDM)),
    list(lustre@internals@vdom:element(RDM))
) -> lustre@internals@vdom:element(RDM).
h2(Attrs, Children) ->
    lustre@element:element(<<"h2"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 124).
?DOC("\n").
-spec h3(
    list(lustre@internals@vdom:attribute(RDS)),
    list(lustre@internals@vdom:element(RDS))
) -> lustre@internals@vdom:element(RDS).
h3(Attrs, Children) ->
    lustre@element:element(<<"h3"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 132).
?DOC("\n").
-spec h4(
    list(lustre@internals@vdom:attribute(RDY)),
    list(lustre@internals@vdom:element(RDY))
) -> lustre@internals@vdom:element(RDY).
h4(Attrs, Children) ->
    lustre@element:element(<<"h4"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 140).
?DOC("\n").
-spec h5(
    list(lustre@internals@vdom:attribute(REE)),
    list(lustre@internals@vdom:element(REE))
) -> lustre@internals@vdom:element(REE).
h5(Attrs, Children) ->
    lustre@element:element(<<"h5"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 148).
?DOC("\n").
-spec h6(
    list(lustre@internals@vdom:attribute(REK)),
    list(lustre@internals@vdom:element(REK))
) -> lustre@internals@vdom:element(REK).
h6(Attrs, Children) ->
    lustre@element:element(<<"h6"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 156).
?DOC("\n").
-spec hgroup(
    list(lustre@internals@vdom:attribute(REQ)),
    list(lustre@internals@vdom:element(REQ))
) -> lustre@internals@vdom:element(REQ).
hgroup(Attrs, Children) ->
    lustre@element:element(<<"hgroup"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 164).
?DOC("\n").
-spec main(
    list(lustre@internals@vdom:attribute(REW)),
    list(lustre@internals@vdom:element(REW))
) -> lustre@internals@vdom:element(REW).
main(Attrs, Children) ->
    lustre@element:element(<<"main"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 172).
?DOC("\n").
-spec nav(
    list(lustre@internals@vdom:attribute(RFC)),
    list(lustre@internals@vdom:element(RFC))
) -> lustre@internals@vdom:element(RFC).
nav(Attrs, Children) ->
    lustre@element:element(<<"nav"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 180).
?DOC("\n").
-spec section(
    list(lustre@internals@vdom:attribute(RFI)),
    list(lustre@internals@vdom:element(RFI))
) -> lustre@internals@vdom:element(RFI).
section(Attrs, Children) ->
    lustre@element:element(<<"section"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 188).
?DOC("\n").
-spec search(
    list(lustre@internals@vdom:attribute(RFO)),
    list(lustre@internals@vdom:element(RFO))
) -> lustre@internals@vdom:element(RFO).
search(Attrs, Children) ->
    lustre@element:element(<<"search"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 198).
?DOC("\n").
-spec blockquote(
    list(lustre@internals@vdom:attribute(RFU)),
    list(lustre@internals@vdom:element(RFU))
) -> lustre@internals@vdom:element(RFU).
blockquote(Attrs, Children) ->
    lustre@element:element(<<"blockquote"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 206).
?DOC("\n").
-spec dd(
    list(lustre@internals@vdom:attribute(RGA)),
    list(lustre@internals@vdom:element(RGA))
) -> lustre@internals@vdom:element(RGA).
dd(Attrs, Children) ->
    lustre@element:element(<<"dd"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 214).
?DOC("\n").
-spec 'div'(
    list(lustre@internals@vdom:attribute(RGG)),
    list(lustre@internals@vdom:element(RGG))
) -> lustre@internals@vdom:element(RGG).
'div'(Attrs, Children) ->
    lustre@element:element(<<"div"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 222).
?DOC("\n").
-spec dl(
    list(lustre@internals@vdom:attribute(RGM)),
    list(lustre@internals@vdom:element(RGM))
) -> lustre@internals@vdom:element(RGM).
dl(Attrs, Children) ->
    lustre@element:element(<<"dl"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 230).
?DOC("\n").
-spec dt(
    list(lustre@internals@vdom:attribute(RGS)),
    list(lustre@internals@vdom:element(RGS))
) -> lustre@internals@vdom:element(RGS).
dt(Attrs, Children) ->
    lustre@element:element(<<"dt"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 238).
?DOC("\n").
-spec figcaption(
    list(lustre@internals@vdom:attribute(RGY)),
    list(lustre@internals@vdom:element(RGY))
) -> lustre@internals@vdom:element(RGY).
figcaption(Attrs, Children) ->
    lustre@element:element(<<"figcaption"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 246).
?DOC("\n").
-spec figure(
    list(lustre@internals@vdom:attribute(RHE)),
    list(lustre@internals@vdom:element(RHE))
) -> lustre@internals@vdom:element(RHE).
figure(Attrs, Children) ->
    lustre@element:element(<<"figure"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 254).
?DOC("\n").
-spec hr(list(lustre@internals@vdom:attribute(RHK))) -> lustre@internals@vdom:element(RHK).
hr(Attrs) ->
    lustre@element:element(<<"hr"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 259).
?DOC("\n").
-spec li(
    list(lustre@internals@vdom:attribute(RHO)),
    list(lustre@internals@vdom:element(RHO))
) -> lustre@internals@vdom:element(RHO).
li(Attrs, Children) ->
    lustre@element:element(<<"li"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 267).
?DOC("\n").
-spec menu(
    list(lustre@internals@vdom:attribute(RHU)),
    list(lustre@internals@vdom:element(RHU))
) -> lustre@internals@vdom:element(RHU).
menu(Attrs, Children) ->
    lustre@element:element(<<"menu"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 275).
?DOC("\n").
-spec ol(
    list(lustre@internals@vdom:attribute(RIA)),
    list(lustre@internals@vdom:element(RIA))
) -> lustre@internals@vdom:element(RIA).
ol(Attrs, Children) ->
    lustre@element:element(<<"ol"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 283).
?DOC("\n").
-spec p(
    list(lustre@internals@vdom:attribute(RIG)),
    list(lustre@internals@vdom:element(RIG))
) -> lustre@internals@vdom:element(RIG).
p(Attrs, Children) ->
    lustre@element:element(<<"p"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 291).
?DOC("\n").
-spec pre(
    list(lustre@internals@vdom:attribute(RIM)),
    list(lustre@internals@vdom:element(RIM))
) -> lustre@internals@vdom:element(RIM).
pre(Attrs, Children) ->
    lustre@element:element(<<"pre"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 299).
?DOC("\n").
-spec ul(
    list(lustre@internals@vdom:attribute(RIS)),
    list(lustre@internals@vdom:element(RIS))
) -> lustre@internals@vdom:element(RIS).
ul(Attrs, Children) ->
    lustre@element:element(<<"ul"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 309).
?DOC("\n").
-spec a(
    list(lustre@internals@vdom:attribute(RIY)),
    list(lustre@internals@vdom:element(RIY))
) -> lustre@internals@vdom:element(RIY).
a(Attrs, Children) ->
    lustre@element:element(<<"a"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 317).
?DOC("\n").
-spec abbr(
    list(lustre@internals@vdom:attribute(RJE)),
    list(lustre@internals@vdom:element(RJE))
) -> lustre@internals@vdom:element(RJE).
abbr(Attrs, Children) ->
    lustre@element:element(<<"abbr"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 325).
?DOC("\n").
-spec b(
    list(lustre@internals@vdom:attribute(RJK)),
    list(lustre@internals@vdom:element(RJK))
) -> lustre@internals@vdom:element(RJK).
b(Attrs, Children) ->
    lustre@element:element(<<"b"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 333).
?DOC("\n").
-spec bdi(
    list(lustre@internals@vdom:attribute(RJQ)),
    list(lustre@internals@vdom:element(RJQ))
) -> lustre@internals@vdom:element(RJQ).
bdi(Attrs, Children) ->
    lustre@element:element(<<"bdi"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 341).
?DOC("\n").
-spec bdo(
    list(lustre@internals@vdom:attribute(RJW)),
    list(lustre@internals@vdom:element(RJW))
) -> lustre@internals@vdom:element(RJW).
bdo(Attrs, Children) ->
    lustre@element:element(<<"bdo"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 349).
?DOC("\n").
-spec br(list(lustre@internals@vdom:attribute(RKC))) -> lustre@internals@vdom:element(RKC).
br(Attrs) ->
    lustre@element:element(<<"br"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 354).
?DOC("\n").
-spec cite(
    list(lustre@internals@vdom:attribute(RKG)),
    list(lustre@internals@vdom:element(RKG))
) -> lustre@internals@vdom:element(RKG).
cite(Attrs, Children) ->
    lustre@element:element(<<"cite"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 362).
?DOC("\n").
-spec code(
    list(lustre@internals@vdom:attribute(RKM)),
    list(lustre@internals@vdom:element(RKM))
) -> lustre@internals@vdom:element(RKM).
code(Attrs, Children) ->
    lustre@element:element(<<"code"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 370).
?DOC("\n").
-spec data(
    list(lustre@internals@vdom:attribute(RKS)),
    list(lustre@internals@vdom:element(RKS))
) -> lustre@internals@vdom:element(RKS).
data(Attrs, Children) ->
    lustre@element:element(<<"data"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 378).
?DOC("\n").
-spec dfn(
    list(lustre@internals@vdom:attribute(RKY)),
    list(lustre@internals@vdom:element(RKY))
) -> lustre@internals@vdom:element(RKY).
dfn(Attrs, Children) ->
    lustre@element:element(<<"dfn"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 386).
?DOC("\n").
-spec em(
    list(lustre@internals@vdom:attribute(RLE)),
    list(lustre@internals@vdom:element(RLE))
) -> lustre@internals@vdom:element(RLE).
em(Attrs, Children) ->
    lustre@element:element(<<"em"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 394).
?DOC("\n").
-spec i(
    list(lustre@internals@vdom:attribute(RLK)),
    list(lustre@internals@vdom:element(RLK))
) -> lustre@internals@vdom:element(RLK).
i(Attrs, Children) ->
    lustre@element:element(<<"i"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 402).
?DOC("\n").
-spec kbd(
    list(lustre@internals@vdom:attribute(RLQ)),
    list(lustre@internals@vdom:element(RLQ))
) -> lustre@internals@vdom:element(RLQ).
kbd(Attrs, Children) ->
    lustre@element:element(<<"kbd"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 410).
?DOC("\n").
-spec mark(
    list(lustre@internals@vdom:attribute(RLW)),
    list(lustre@internals@vdom:element(RLW))
) -> lustre@internals@vdom:element(RLW).
mark(Attrs, Children) ->
    lustre@element:element(<<"mark"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 418).
?DOC("\n").
-spec q(
    list(lustre@internals@vdom:attribute(RMC)),
    list(lustre@internals@vdom:element(RMC))
) -> lustre@internals@vdom:element(RMC).
q(Attrs, Children) ->
    lustre@element:element(<<"q"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 426).
?DOC("\n").
-spec rp(
    list(lustre@internals@vdom:attribute(RMI)),
    list(lustre@internals@vdom:element(RMI))
) -> lustre@internals@vdom:element(RMI).
rp(Attrs, Children) ->
    lustre@element:element(<<"rp"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 434).
?DOC("\n").
-spec rt(
    list(lustre@internals@vdom:attribute(RMO)),
    list(lustre@internals@vdom:element(RMO))
) -> lustre@internals@vdom:element(RMO).
rt(Attrs, Children) ->
    lustre@element:element(<<"rt"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 442).
?DOC("\n").
-spec ruby(
    list(lustre@internals@vdom:attribute(RMU)),
    list(lustre@internals@vdom:element(RMU))
) -> lustre@internals@vdom:element(RMU).
ruby(Attrs, Children) ->
    lustre@element:element(<<"ruby"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 450).
?DOC("\n").
-spec s(
    list(lustre@internals@vdom:attribute(RNA)),
    list(lustre@internals@vdom:element(RNA))
) -> lustre@internals@vdom:element(RNA).
s(Attrs, Children) ->
    lustre@element:element(<<"s"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 458).
?DOC("\n").
-spec samp(
    list(lustre@internals@vdom:attribute(RNG)),
    list(lustre@internals@vdom:element(RNG))
) -> lustre@internals@vdom:element(RNG).
samp(Attrs, Children) ->
    lustre@element:element(<<"samp"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 466).
?DOC("\n").
-spec small(
    list(lustre@internals@vdom:attribute(RNM)),
    list(lustre@internals@vdom:element(RNM))
) -> lustre@internals@vdom:element(RNM).
small(Attrs, Children) ->
    lustre@element:element(<<"small"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 474).
?DOC("\n").
-spec span(
    list(lustre@internals@vdom:attribute(RNS)),
    list(lustre@internals@vdom:element(RNS))
) -> lustre@internals@vdom:element(RNS).
span(Attrs, Children) ->
    lustre@element:element(<<"span"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 482).
?DOC("\n").
-spec strong(
    list(lustre@internals@vdom:attribute(RNY)),
    list(lustre@internals@vdom:element(RNY))
) -> lustre@internals@vdom:element(RNY).
strong(Attrs, Children) ->
    lustre@element:element(<<"strong"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 490).
?DOC("\n").
-spec sub(
    list(lustre@internals@vdom:attribute(ROE)),
    list(lustre@internals@vdom:element(ROE))
) -> lustre@internals@vdom:element(ROE).
sub(Attrs, Children) ->
    lustre@element:element(<<"sub"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 498).
?DOC("\n").
-spec sup(
    list(lustre@internals@vdom:attribute(ROK)),
    list(lustre@internals@vdom:element(ROK))
) -> lustre@internals@vdom:element(ROK).
sup(Attrs, Children) ->
    lustre@element:element(<<"sup"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 506).
?DOC("\n").
-spec time(
    list(lustre@internals@vdom:attribute(ROQ)),
    list(lustre@internals@vdom:element(ROQ))
) -> lustre@internals@vdom:element(ROQ).
time(Attrs, Children) ->
    lustre@element:element(<<"time"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 514).
?DOC("\n").
-spec u(
    list(lustre@internals@vdom:attribute(ROW)),
    list(lustre@internals@vdom:element(ROW))
) -> lustre@internals@vdom:element(ROW).
u(Attrs, Children) ->
    lustre@element:element(<<"u"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 522).
?DOC("\n").
-spec var(
    list(lustre@internals@vdom:attribute(RPC)),
    list(lustre@internals@vdom:element(RPC))
) -> lustre@internals@vdom:element(RPC).
var(Attrs, Children) ->
    lustre@element:element(<<"var"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 530).
?DOC("\n").
-spec wbr(list(lustre@internals@vdom:attribute(RPI))) -> lustre@internals@vdom:element(RPI).
wbr(Attrs) ->
    lustre@element:element(<<"wbr"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 537).
?DOC("\n").
-spec area(list(lustre@internals@vdom:attribute(RPM))) -> lustre@internals@vdom:element(RPM).
area(Attrs) ->
    lustre@element:element(<<"area"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 542).
?DOC("\n").
-spec audio(
    list(lustre@internals@vdom:attribute(RPQ)),
    list(lustre@internals@vdom:element(RPQ))
) -> lustre@internals@vdom:element(RPQ).
audio(Attrs, Children) ->
    lustre@element:element(<<"audio"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 550).
?DOC("\n").
-spec img(list(lustre@internals@vdom:attribute(RPW))) -> lustre@internals@vdom:element(RPW).
img(Attrs) ->
    lustre@element:element(<<"img"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 556).
?DOC(" Used with <area> elements to define an image map (a clickable link area).\n").
-spec map(
    list(lustre@internals@vdom:attribute(RQA)),
    list(lustre@internals@vdom:element(RQA))
) -> lustre@internals@vdom:element(RQA).
map(Attrs, Children) ->
    lustre@element:element(<<"map"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 564).
?DOC("\n").
-spec track(list(lustre@internals@vdom:attribute(RQG))) -> lustre@internals@vdom:element(RQG).
track(Attrs) ->
    lustre@element:element(<<"track"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 569).
?DOC("\n").
-spec video(
    list(lustre@internals@vdom:attribute(RQK)),
    list(lustre@internals@vdom:element(RQK))
) -> lustre@internals@vdom:element(RQK).
video(Attrs, Children) ->
    lustre@element:element(<<"video"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 579).
?DOC("\n").
-spec embed(list(lustre@internals@vdom:attribute(RQQ))) -> lustre@internals@vdom:element(RQQ).
embed(Attrs) ->
    lustre@element:element(<<"embed"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 584).
?DOC("\n").
-spec iframe(list(lustre@internals@vdom:attribute(RQU))) -> lustre@internals@vdom:element(RQU).
iframe(Attrs) ->
    lustre@element:element(<<"iframe"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 589).
?DOC("\n").
-spec object(list(lustre@internals@vdom:attribute(RQY))) -> lustre@internals@vdom:element(RQY).
object(Attrs) ->
    lustre@element:element(<<"object"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 594).
?DOC("\n").
-spec picture(
    list(lustre@internals@vdom:attribute(RRC)),
    list(lustre@internals@vdom:element(RRC))
) -> lustre@internals@vdom:element(RRC).
picture(Attrs, Children) ->
    lustre@element:element(<<"picture"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 602).
?DOC("\n").
-spec portal(list(lustre@internals@vdom:attribute(RRI))) -> lustre@internals@vdom:element(RRI).
portal(Attrs) ->
    lustre@element:element(<<"portal"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 607).
?DOC("\n").
-spec source(list(lustre@internals@vdom:attribute(RRM))) -> lustre@internals@vdom:element(RRM).
source(Attrs) ->
    lustre@element:element(<<"source"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 614).
?DOC("\n").
-spec svg(
    list(lustre@internals@vdom:attribute(RRQ)),
    list(lustre@internals@vdom:element(RRQ))
) -> lustre@internals@vdom:element(RRQ).
svg(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"svg"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/html.gleam", 622).
?DOC("\n").
-spec math(
    list(lustre@internals@vdom:attribute(RRW)),
    list(lustre@internals@vdom:element(RRW))
) -> lustre@internals@vdom:element(RRW).
math(Attrs, Children) ->
    lustre@element:element(<<"math"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 632).
?DOC("\n").
-spec canvas(list(lustre@internals@vdom:attribute(RSC))) -> lustre@internals@vdom:element(RSC).
canvas(Attrs) ->
    lustre@element:element(<<"canvas"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 637).
?DOC("\n").
-spec noscript(
    list(lustre@internals@vdom:attribute(RSG)),
    list(lustre@internals@vdom:element(RSG))
) -> lustre@internals@vdom:element(RSG).
noscript(Attrs, Children) ->
    lustre@element:element(<<"noscript"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 645).
?DOC("\n").
-spec script(list(lustre@internals@vdom:attribute(RSM)), binary()) -> lustre@internals@vdom:element(RSM).
script(Attrs, Js) ->
    lustre@element:element(<<"script"/utf8>>, Attrs, [text(Js)]).

-file("src/lustre/element/html.gleam", 652).
?DOC("\n").
-spec del(
    list(lustre@internals@vdom:attribute(RSQ)),
    list(lustre@internals@vdom:element(RSQ))
) -> lustre@internals@vdom:element(RSQ).
del(Attrs, Children) ->
    lustre@element:element(<<"del"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 660).
?DOC("\n").
-spec ins(
    list(lustre@internals@vdom:attribute(RSW)),
    list(lustre@internals@vdom:element(RSW))
) -> lustre@internals@vdom:element(RSW).
ins(Attrs, Children) ->
    lustre@element:element(<<"ins"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 670).
?DOC("\n").
-spec caption(
    list(lustre@internals@vdom:attribute(RTC)),
    list(lustre@internals@vdom:element(RTC))
) -> lustre@internals@vdom:element(RTC).
caption(Attrs, Children) ->
    lustre@element:element(<<"caption"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 678).
?DOC("\n").
-spec col(list(lustre@internals@vdom:attribute(RTI))) -> lustre@internals@vdom:element(RTI).
col(Attrs) ->
    lustre@element:element(<<"col"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 683).
?DOC("\n").
-spec colgroup(
    list(lustre@internals@vdom:attribute(RTM)),
    list(lustre@internals@vdom:element(RTM))
) -> lustre@internals@vdom:element(RTM).
colgroup(Attrs, Children) ->
    lustre@element:element(<<"colgroup"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 691).
?DOC("\n").
-spec table(
    list(lustre@internals@vdom:attribute(RTS)),
    list(lustre@internals@vdom:element(RTS))
) -> lustre@internals@vdom:element(RTS).
table(Attrs, Children) ->
    lustre@element:element(<<"table"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 699).
?DOC("\n").
-spec tbody(
    list(lustre@internals@vdom:attribute(RTY)),
    list(lustre@internals@vdom:element(RTY))
) -> lustre@internals@vdom:element(RTY).
tbody(Attrs, Children) ->
    lustre@element:element(<<"tbody"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 707).
?DOC("\n").
-spec td(
    list(lustre@internals@vdom:attribute(RUE)),
    list(lustre@internals@vdom:element(RUE))
) -> lustre@internals@vdom:element(RUE).
td(Attrs, Children) ->
    lustre@element:element(<<"td"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 715).
?DOC("\n").
-spec tfoot(
    list(lustre@internals@vdom:attribute(RUK)),
    list(lustre@internals@vdom:element(RUK))
) -> lustre@internals@vdom:element(RUK).
tfoot(Attrs, Children) ->
    lustre@element:element(<<"tfoot"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 723).
?DOC("\n").
-spec th(
    list(lustre@internals@vdom:attribute(RUQ)),
    list(lustre@internals@vdom:element(RUQ))
) -> lustre@internals@vdom:element(RUQ).
th(Attrs, Children) ->
    lustre@element:element(<<"th"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 731).
?DOC("\n").
-spec thead(
    list(lustre@internals@vdom:attribute(RUW)),
    list(lustre@internals@vdom:element(RUW))
) -> lustre@internals@vdom:element(RUW).
thead(Attrs, Children) ->
    lustre@element:element(<<"thead"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 739).
?DOC("\n").
-spec tr(
    list(lustre@internals@vdom:attribute(RVC)),
    list(lustre@internals@vdom:element(RVC))
) -> lustre@internals@vdom:element(RVC).
tr(Attrs, Children) ->
    lustre@element:element(<<"tr"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 749).
?DOC("\n").
-spec button(
    list(lustre@internals@vdom:attribute(RVI)),
    list(lustre@internals@vdom:element(RVI))
) -> lustre@internals@vdom:element(RVI).
button(Attrs, Children) ->
    lustre@element:element(<<"button"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 757).
?DOC("\n").
-spec datalist(
    list(lustre@internals@vdom:attribute(RVO)),
    list(lustre@internals@vdom:element(RVO))
) -> lustre@internals@vdom:element(RVO).
datalist(Attrs, Children) ->
    lustre@element:element(<<"datalist"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 765).
?DOC("\n").
-spec fieldset(
    list(lustre@internals@vdom:attribute(RVU)),
    list(lustre@internals@vdom:element(RVU))
) -> lustre@internals@vdom:element(RVU).
fieldset(Attrs, Children) ->
    lustre@element:element(<<"fieldset"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 773).
?DOC("\n").
-spec form(
    list(lustre@internals@vdom:attribute(RWA)),
    list(lustre@internals@vdom:element(RWA))
) -> lustre@internals@vdom:element(RWA).
form(Attrs, Children) ->
    lustre@element:element(<<"form"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 781).
?DOC("\n").
-spec input(list(lustre@internals@vdom:attribute(RWG))) -> lustre@internals@vdom:element(RWG).
input(Attrs) ->
    lustre@element:element(<<"input"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 786).
?DOC("\n").
-spec label(
    list(lustre@internals@vdom:attribute(RWK)),
    list(lustre@internals@vdom:element(RWK))
) -> lustre@internals@vdom:element(RWK).
label(Attrs, Children) ->
    lustre@element:element(<<"label"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 794).
?DOC("\n").
-spec legend(
    list(lustre@internals@vdom:attribute(RWQ)),
    list(lustre@internals@vdom:element(RWQ))
) -> lustre@internals@vdom:element(RWQ).
legend(Attrs, Children) ->
    lustre@element:element(<<"legend"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 802).
?DOC("\n").
-spec meter(
    list(lustre@internals@vdom:attribute(RWW)),
    list(lustre@internals@vdom:element(RWW))
) -> lustre@internals@vdom:element(RWW).
meter(Attrs, Children) ->
    lustre@element:element(<<"meter"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 810).
?DOC("\n").
-spec optgroup(
    list(lustre@internals@vdom:attribute(RXC)),
    list(lustre@internals@vdom:element(RXC))
) -> lustre@internals@vdom:element(RXC).
optgroup(Attrs, Children) ->
    lustre@element:element(<<"optgroup"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 818).
?DOC("\n").
-spec option(list(lustre@internals@vdom:attribute(RXI)), binary()) -> lustre@internals@vdom:element(RXI).
option(Attrs, Label) ->
    lustre@element:element(
        <<"option"/utf8>>,
        Attrs,
        [lustre@element:text(Label)]
    ).

-file("src/lustre/element/html.gleam", 823).
?DOC("\n").
-spec output(
    list(lustre@internals@vdom:attribute(RXM)),
    list(lustre@internals@vdom:element(RXM))
) -> lustre@internals@vdom:element(RXM).
output(Attrs, Children) ->
    lustre@element:element(<<"output"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 831).
?DOC("\n").
-spec progress(
    list(lustre@internals@vdom:attribute(RXS)),
    list(lustre@internals@vdom:element(RXS))
) -> lustre@internals@vdom:element(RXS).
progress(Attrs, Children) ->
    lustre@element:element(<<"progress"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 839).
?DOC("\n").
-spec select(
    list(lustre@internals@vdom:attribute(RXY)),
    list(lustre@internals@vdom:element(RXY))
) -> lustre@internals@vdom:element(RXY).
select(Attrs, Children) ->
    lustre@element:element(<<"select"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 847).
?DOC("\n").
-spec textarea(list(lustre@internals@vdom:attribute(RYE)), binary()) -> lustre@internals@vdom:element(RYE).
textarea(Attrs, Content) ->
    lustre@element:element(
        <<"textarea"/utf8>>,
        Attrs,
        [lustre@element:text(Content)]
    ).

-file("src/lustre/element/html.gleam", 854).
?DOC("\n").
-spec details(
    list(lustre@internals@vdom:attribute(RYI)),
    list(lustre@internals@vdom:element(RYI))
) -> lustre@internals@vdom:element(RYI).
details(Attrs, Children) ->
    lustre@element:element(<<"details"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 862).
?DOC("\n").
-spec dialog(
    list(lustre@internals@vdom:attribute(RYO)),
    list(lustre@internals@vdom:element(RYO))
) -> lustre@internals@vdom:element(RYO).
dialog(Attrs, Children) ->
    lustre@element:element(<<"dialog"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 870).
?DOC("\n").
-spec summary(
    list(lustre@internals@vdom:attribute(RYU)),
    list(lustre@internals@vdom:element(RYU))
) -> lustre@internals@vdom:element(RYU).
summary(Attrs, Children) ->
    lustre@element:element(<<"summary"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 880).
?DOC("\n").
-spec slot(list(lustre@internals@vdom:attribute(RZA))) -> lustre@internals@vdom:element(RZA).
slot(Attrs) ->
    lustre@element:element(<<"slot"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 885).
?DOC("\n").
-spec template(
    list(lustre@internals@vdom:attribute(RZE)),
    list(lustre@internals@vdom:element(RZE))
) -> lustre@internals@vdom:element(RZE).
template(Attrs, Children) ->
    lustre@element:element(<<"template"/utf8>>, Attrs, Children).
