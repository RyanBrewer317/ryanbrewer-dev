-module(lustre@element@html).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([html/2, text/1, base/1, head/2, link/1, meta/1, style/2, title/2, body/2, address/2, article/2, aside/2, footer/2, header/2, h1/2, h2/2, h3/2, h4/2, h5/2, h6/2, hgroup/2, main/2, nav/2, section/2, search/2, blockquote/2, dd/2, 'div'/2, dl/2, dt/2, figcaption/2, figure/2, hr/1, li/2, menu/2, ol/2, p/2, pre/2, ul/2, a/2, abbr/2, b/2, bdi/2, bdo/2, br/1, cite/2, code/2, data/2, dfn/2, em/2, i/2, kbd/2, mark/2, q/2, rp/2, rt/2, ruby/2, s/2, samp/2, small/2, span/2, strong/2, sub/2, sup/2, time/2, u/2, var/2, wbr/1, area/1, audio/2, img/1, map/2, track/1, video/2, embed/1, iframe/1, object/1, picture/2, portal/1, source/1, svg/2, math/2, canvas/1, noscript/2, script/2, del/2, ins/2, caption/2, col/1, colgroup/2, table/2, tbody/2, td/2, tfoot/2, th/2, thead/2, tr/2, button/2, datalist/2, fieldset/2, form/2, input/1, label/2, legend/2, meter/2, optgroup/2, option/2, output/2, progress/2, select/2, textarea/2, details/2, dialog/2, summary/2, slot/1, template/2]).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 9).
-spec html(
    list(lustre@internals@vdom:attribute(QLY)),
    list(lustre@internals@vdom:element(QLY))
) -> lustre@internals@vdom:element(QLY).
html(Attrs, Children) ->
    lustre@element:element(<<"html"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 16).
-spec text(binary()) -> lustre@internals@vdom:element(any()).
text(Content) ->
    lustre@element:text(Content).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 23).
-spec base(list(lustre@internals@vdom:attribute(QMG))) -> lustre@internals@vdom:element(QMG).
base(Attrs) ->
    lustre@element:element(<<"base"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 28).
-spec head(
    list(lustre@internals@vdom:attribute(QMK)),
    list(lustre@internals@vdom:element(QMK))
) -> lustre@internals@vdom:element(QMK).
head(Attrs, Children) ->
    lustre@element:element(<<"head"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 36).
-spec link(list(lustre@internals@vdom:attribute(QMQ))) -> lustre@internals@vdom:element(QMQ).
link(Attrs) ->
    lustre@element:element(<<"link"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 41).
-spec meta(list(lustre@internals@vdom:attribute(QMU))) -> lustre@internals@vdom:element(QMU).
meta(Attrs) ->
    lustre@element:element(<<"meta"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 46).
-spec style(list(lustre@internals@vdom:attribute(QMY)), binary()) -> lustre@internals@vdom:element(QMY).
style(Attrs, Css) ->
    lustre@element:element(<<"style"/utf8>>, Attrs, [text(Css)]).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 51).
-spec title(list(lustre@internals@vdom:attribute(QNC)), binary()) -> lustre@internals@vdom:element(QNC).
title(Attrs, Content) ->
    lustre@element:element(<<"title"/utf8>>, Attrs, [text(Content)]).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 58).
-spec body(
    list(lustre@internals@vdom:attribute(QNG)),
    list(lustre@internals@vdom:element(QNG))
) -> lustre@internals@vdom:element(QNG).
body(Attrs, Children) ->
    lustre@element:element(<<"body"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 68).
-spec address(
    list(lustre@internals@vdom:attribute(QNM)),
    list(lustre@internals@vdom:element(QNM))
) -> lustre@internals@vdom:element(QNM).
address(Attrs, Children) ->
    lustre@element:element(<<"address"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 76).
-spec article(
    list(lustre@internals@vdom:attribute(QNS)),
    list(lustre@internals@vdom:element(QNS))
) -> lustre@internals@vdom:element(QNS).
article(Attrs, Children) ->
    lustre@element:element(<<"article"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 84).
-spec aside(
    list(lustre@internals@vdom:attribute(QNY)),
    list(lustre@internals@vdom:element(QNY))
) -> lustre@internals@vdom:element(QNY).
aside(Attrs, Children) ->
    lustre@element:element(<<"aside"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 92).
-spec footer(
    list(lustre@internals@vdom:attribute(QOE)),
    list(lustre@internals@vdom:element(QOE))
) -> lustre@internals@vdom:element(QOE).
footer(Attrs, Children) ->
    lustre@element:element(<<"footer"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 100).
-spec header(
    list(lustre@internals@vdom:attribute(QOK)),
    list(lustre@internals@vdom:element(QOK))
) -> lustre@internals@vdom:element(QOK).
header(Attrs, Children) ->
    lustre@element:element(<<"header"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 108).
-spec h1(
    list(lustre@internals@vdom:attribute(QOQ)),
    list(lustre@internals@vdom:element(QOQ))
) -> lustre@internals@vdom:element(QOQ).
h1(Attrs, Children) ->
    lustre@element:element(<<"h1"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 116).
-spec h2(
    list(lustre@internals@vdom:attribute(QOW)),
    list(lustre@internals@vdom:element(QOW))
) -> lustre@internals@vdom:element(QOW).
h2(Attrs, Children) ->
    lustre@element:element(<<"h2"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 124).
-spec h3(
    list(lustre@internals@vdom:attribute(QPC)),
    list(lustre@internals@vdom:element(QPC))
) -> lustre@internals@vdom:element(QPC).
h3(Attrs, Children) ->
    lustre@element:element(<<"h3"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 132).
-spec h4(
    list(lustre@internals@vdom:attribute(QPI)),
    list(lustre@internals@vdom:element(QPI))
) -> lustre@internals@vdom:element(QPI).
h4(Attrs, Children) ->
    lustre@element:element(<<"h4"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 140).
-spec h5(
    list(lustre@internals@vdom:attribute(QPO)),
    list(lustre@internals@vdom:element(QPO))
) -> lustre@internals@vdom:element(QPO).
h5(Attrs, Children) ->
    lustre@element:element(<<"h5"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 148).
-spec h6(
    list(lustre@internals@vdom:attribute(QPU)),
    list(lustre@internals@vdom:element(QPU))
) -> lustre@internals@vdom:element(QPU).
h6(Attrs, Children) ->
    lustre@element:element(<<"h6"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 156).
-spec hgroup(
    list(lustre@internals@vdom:attribute(QQA)),
    list(lustre@internals@vdom:element(QQA))
) -> lustre@internals@vdom:element(QQA).
hgroup(Attrs, Children) ->
    lustre@element:element(<<"hgroup"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 164).
-spec main(
    list(lustre@internals@vdom:attribute(QQG)),
    list(lustre@internals@vdom:element(QQG))
) -> lustre@internals@vdom:element(QQG).
main(Attrs, Children) ->
    lustre@element:element(<<"main"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 172).
-spec nav(
    list(lustre@internals@vdom:attribute(QQM)),
    list(lustre@internals@vdom:element(QQM))
) -> lustre@internals@vdom:element(QQM).
nav(Attrs, Children) ->
    lustre@element:element(<<"nav"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 180).
-spec section(
    list(lustre@internals@vdom:attribute(QQS)),
    list(lustre@internals@vdom:element(QQS))
) -> lustre@internals@vdom:element(QQS).
section(Attrs, Children) ->
    lustre@element:element(<<"section"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 188).
-spec search(
    list(lustre@internals@vdom:attribute(QQY)),
    list(lustre@internals@vdom:element(QQY))
) -> lustre@internals@vdom:element(QQY).
search(Attrs, Children) ->
    lustre@element:element(<<"search"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 198).
-spec blockquote(
    list(lustre@internals@vdom:attribute(QRE)),
    list(lustre@internals@vdom:element(QRE))
) -> lustre@internals@vdom:element(QRE).
blockquote(Attrs, Children) ->
    lustre@element:element(<<"blockquote"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 206).
-spec dd(
    list(lustre@internals@vdom:attribute(QRK)),
    list(lustre@internals@vdom:element(QRK))
) -> lustre@internals@vdom:element(QRK).
dd(Attrs, Children) ->
    lustre@element:element(<<"dd"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 214).
-spec 'div'(
    list(lustre@internals@vdom:attribute(QRQ)),
    list(lustre@internals@vdom:element(QRQ))
) -> lustre@internals@vdom:element(QRQ).
'div'(Attrs, Children) ->
    lustre@element:element(<<"div"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 222).
-spec dl(
    list(lustre@internals@vdom:attribute(QRW)),
    list(lustre@internals@vdom:element(QRW))
) -> lustre@internals@vdom:element(QRW).
dl(Attrs, Children) ->
    lustre@element:element(<<"dl"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 230).
-spec dt(
    list(lustre@internals@vdom:attribute(QSC)),
    list(lustre@internals@vdom:element(QSC))
) -> lustre@internals@vdom:element(QSC).
dt(Attrs, Children) ->
    lustre@element:element(<<"dt"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 238).
-spec figcaption(
    list(lustre@internals@vdom:attribute(QSI)),
    list(lustre@internals@vdom:element(QSI))
) -> lustre@internals@vdom:element(QSI).
figcaption(Attrs, Children) ->
    lustre@element:element(<<"figcaption"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 246).
-spec figure(
    list(lustre@internals@vdom:attribute(QSO)),
    list(lustre@internals@vdom:element(QSO))
) -> lustre@internals@vdom:element(QSO).
figure(Attrs, Children) ->
    lustre@element:element(<<"figure"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 254).
-spec hr(list(lustre@internals@vdom:attribute(QSU))) -> lustre@internals@vdom:element(QSU).
hr(Attrs) ->
    lustre@element:element(<<"hr"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 259).
-spec li(
    list(lustre@internals@vdom:attribute(QSY)),
    list(lustre@internals@vdom:element(QSY))
) -> lustre@internals@vdom:element(QSY).
li(Attrs, Children) ->
    lustre@element:element(<<"li"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 267).
-spec menu(
    list(lustre@internals@vdom:attribute(QTE)),
    list(lustre@internals@vdom:element(QTE))
) -> lustre@internals@vdom:element(QTE).
menu(Attrs, Children) ->
    lustre@element:element(<<"menu"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 275).
-spec ol(
    list(lustre@internals@vdom:attribute(QTK)),
    list(lustre@internals@vdom:element(QTK))
) -> lustre@internals@vdom:element(QTK).
ol(Attrs, Children) ->
    lustre@element:element(<<"ol"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 283).
-spec p(
    list(lustre@internals@vdom:attribute(QTQ)),
    list(lustre@internals@vdom:element(QTQ))
) -> lustre@internals@vdom:element(QTQ).
p(Attrs, Children) ->
    lustre@element:element(<<"p"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 291).
-spec pre(
    list(lustre@internals@vdom:attribute(QTW)),
    list(lustre@internals@vdom:element(QTW))
) -> lustre@internals@vdom:element(QTW).
pre(Attrs, Children) ->
    lustre@element:element(<<"pre"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 299).
-spec ul(
    list(lustre@internals@vdom:attribute(QUC)),
    list(lustre@internals@vdom:element(QUC))
) -> lustre@internals@vdom:element(QUC).
ul(Attrs, Children) ->
    lustre@element:element(<<"ul"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 309).
-spec a(
    list(lustre@internals@vdom:attribute(QUI)),
    list(lustre@internals@vdom:element(QUI))
) -> lustre@internals@vdom:element(QUI).
a(Attrs, Children) ->
    lustre@element:element(<<"a"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 317).
-spec abbr(
    list(lustre@internals@vdom:attribute(QUO)),
    list(lustre@internals@vdom:element(QUO))
) -> lustre@internals@vdom:element(QUO).
abbr(Attrs, Children) ->
    lustre@element:element(<<"abbr"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 325).
-spec b(
    list(lustre@internals@vdom:attribute(QUU)),
    list(lustre@internals@vdom:element(QUU))
) -> lustre@internals@vdom:element(QUU).
b(Attrs, Children) ->
    lustre@element:element(<<"b"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 333).
-spec bdi(
    list(lustre@internals@vdom:attribute(QVA)),
    list(lustre@internals@vdom:element(QVA))
) -> lustre@internals@vdom:element(QVA).
bdi(Attrs, Children) ->
    lustre@element:element(<<"bdi"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 341).
-spec bdo(
    list(lustre@internals@vdom:attribute(QVG)),
    list(lustre@internals@vdom:element(QVG))
) -> lustre@internals@vdom:element(QVG).
bdo(Attrs, Children) ->
    lustre@element:element(<<"bdo"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 349).
-spec br(list(lustre@internals@vdom:attribute(QVM))) -> lustre@internals@vdom:element(QVM).
br(Attrs) ->
    lustre@element:element(<<"br"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 354).
-spec cite(
    list(lustre@internals@vdom:attribute(QVQ)),
    list(lustre@internals@vdom:element(QVQ))
) -> lustre@internals@vdom:element(QVQ).
cite(Attrs, Children) ->
    lustre@element:element(<<"cite"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 362).
-spec code(
    list(lustre@internals@vdom:attribute(QVW)),
    list(lustre@internals@vdom:element(QVW))
) -> lustre@internals@vdom:element(QVW).
code(Attrs, Children) ->
    lustre@element:element(<<"code"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 370).
-spec data(
    list(lustre@internals@vdom:attribute(QWC)),
    list(lustre@internals@vdom:element(QWC))
) -> lustre@internals@vdom:element(QWC).
data(Attrs, Children) ->
    lustre@element:element(<<"data"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 378).
-spec dfn(
    list(lustre@internals@vdom:attribute(QWI)),
    list(lustre@internals@vdom:element(QWI))
) -> lustre@internals@vdom:element(QWI).
dfn(Attrs, Children) ->
    lustre@element:element(<<"dfn"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 386).
-spec em(
    list(lustre@internals@vdom:attribute(QWO)),
    list(lustre@internals@vdom:element(QWO))
) -> lustre@internals@vdom:element(QWO).
em(Attrs, Children) ->
    lustre@element:element(<<"em"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 394).
-spec i(
    list(lustre@internals@vdom:attribute(QWU)),
    list(lustre@internals@vdom:element(QWU))
) -> lustre@internals@vdom:element(QWU).
i(Attrs, Children) ->
    lustre@element:element(<<"i"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 402).
-spec kbd(
    list(lustre@internals@vdom:attribute(QXA)),
    list(lustre@internals@vdom:element(QXA))
) -> lustre@internals@vdom:element(QXA).
kbd(Attrs, Children) ->
    lustre@element:element(<<"kbd"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 410).
-spec mark(
    list(lustre@internals@vdom:attribute(QXG)),
    list(lustre@internals@vdom:element(QXG))
) -> lustre@internals@vdom:element(QXG).
mark(Attrs, Children) ->
    lustre@element:element(<<"mark"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 418).
-spec q(
    list(lustre@internals@vdom:attribute(QXM)),
    list(lustre@internals@vdom:element(QXM))
) -> lustre@internals@vdom:element(QXM).
q(Attrs, Children) ->
    lustre@element:element(<<"q"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 426).
-spec rp(
    list(lustre@internals@vdom:attribute(QXS)),
    list(lustre@internals@vdom:element(QXS))
) -> lustre@internals@vdom:element(QXS).
rp(Attrs, Children) ->
    lustre@element:element(<<"rp"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 434).
-spec rt(
    list(lustre@internals@vdom:attribute(QXY)),
    list(lustre@internals@vdom:element(QXY))
) -> lustre@internals@vdom:element(QXY).
rt(Attrs, Children) ->
    lustre@element:element(<<"rt"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 442).
-spec ruby(
    list(lustre@internals@vdom:attribute(QYE)),
    list(lustre@internals@vdom:element(QYE))
) -> lustre@internals@vdom:element(QYE).
ruby(Attrs, Children) ->
    lustre@element:element(<<"ruby"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 450).
-spec s(
    list(lustre@internals@vdom:attribute(QYK)),
    list(lustre@internals@vdom:element(QYK))
) -> lustre@internals@vdom:element(QYK).
s(Attrs, Children) ->
    lustre@element:element(<<"s"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 458).
-spec samp(
    list(lustre@internals@vdom:attribute(QYQ)),
    list(lustre@internals@vdom:element(QYQ))
) -> lustre@internals@vdom:element(QYQ).
samp(Attrs, Children) ->
    lustre@element:element(<<"samp"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 466).
-spec small(
    list(lustre@internals@vdom:attribute(QYW)),
    list(lustre@internals@vdom:element(QYW))
) -> lustre@internals@vdom:element(QYW).
small(Attrs, Children) ->
    lustre@element:element(<<"small"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 474).
-spec span(
    list(lustre@internals@vdom:attribute(QZC)),
    list(lustre@internals@vdom:element(QZC))
) -> lustre@internals@vdom:element(QZC).
span(Attrs, Children) ->
    lustre@element:element(<<"span"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 482).
-spec strong(
    list(lustre@internals@vdom:attribute(QZI)),
    list(lustre@internals@vdom:element(QZI))
) -> lustre@internals@vdom:element(QZI).
strong(Attrs, Children) ->
    lustre@element:element(<<"strong"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 490).
-spec sub(
    list(lustre@internals@vdom:attribute(QZO)),
    list(lustre@internals@vdom:element(QZO))
) -> lustre@internals@vdom:element(QZO).
sub(Attrs, Children) ->
    lustre@element:element(<<"sub"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 498).
-spec sup(
    list(lustre@internals@vdom:attribute(QZU)),
    list(lustre@internals@vdom:element(QZU))
) -> lustre@internals@vdom:element(QZU).
sup(Attrs, Children) ->
    lustre@element:element(<<"sup"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 506).
-spec time(
    list(lustre@internals@vdom:attribute(RAA)),
    list(lustre@internals@vdom:element(RAA))
) -> lustre@internals@vdom:element(RAA).
time(Attrs, Children) ->
    lustre@element:element(<<"time"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 514).
-spec u(
    list(lustre@internals@vdom:attribute(RAG)),
    list(lustre@internals@vdom:element(RAG))
) -> lustre@internals@vdom:element(RAG).
u(Attrs, Children) ->
    lustre@element:element(<<"u"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 522).
-spec var(
    list(lustre@internals@vdom:attribute(RAM)),
    list(lustre@internals@vdom:element(RAM))
) -> lustre@internals@vdom:element(RAM).
var(Attrs, Children) ->
    lustre@element:element(<<"var"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 530).
-spec wbr(list(lustre@internals@vdom:attribute(RAS))) -> lustre@internals@vdom:element(RAS).
wbr(Attrs) ->
    lustre@element:element(<<"wbr"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 537).
-spec area(list(lustre@internals@vdom:attribute(RAW))) -> lustre@internals@vdom:element(RAW).
area(Attrs) ->
    lustre@element:element(<<"area"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 542).
-spec audio(
    list(lustre@internals@vdom:attribute(RBA)),
    list(lustre@internals@vdom:element(RBA))
) -> lustre@internals@vdom:element(RBA).
audio(Attrs, Children) ->
    lustre@element:element(<<"audio"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 550).
-spec img(list(lustre@internals@vdom:attribute(RBG))) -> lustre@internals@vdom:element(RBG).
img(Attrs) ->
    lustre@element:element(<<"img"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 556).
-spec map(
    list(lustre@internals@vdom:attribute(RBK)),
    list(lustre@internals@vdom:element(RBK))
) -> lustre@internals@vdom:element(RBK).
map(Attrs, Children) ->
    lustre@element:element(<<"map"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 564).
-spec track(list(lustre@internals@vdom:attribute(RBQ))) -> lustre@internals@vdom:element(RBQ).
track(Attrs) ->
    lustre@element:element(<<"track"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 569).
-spec video(
    list(lustre@internals@vdom:attribute(RBU)),
    list(lustre@internals@vdom:element(RBU))
) -> lustre@internals@vdom:element(RBU).
video(Attrs, Children) ->
    lustre@element:element(<<"video"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 579).
-spec embed(list(lustre@internals@vdom:attribute(RCA))) -> lustre@internals@vdom:element(RCA).
embed(Attrs) ->
    lustre@element:element(<<"embed"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 584).
-spec iframe(list(lustre@internals@vdom:attribute(RCE))) -> lustre@internals@vdom:element(RCE).
iframe(Attrs) ->
    lustre@element:element(<<"iframe"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 589).
-spec object(list(lustre@internals@vdom:attribute(RCI))) -> lustre@internals@vdom:element(RCI).
object(Attrs) ->
    lustre@element:element(<<"object"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 594).
-spec picture(
    list(lustre@internals@vdom:attribute(RCM)),
    list(lustre@internals@vdom:element(RCM))
) -> lustre@internals@vdom:element(RCM).
picture(Attrs, Children) ->
    lustre@element:element(<<"picture"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 602).
-spec portal(list(lustre@internals@vdom:attribute(RCS))) -> lustre@internals@vdom:element(RCS).
portal(Attrs) ->
    lustre@element:element(<<"portal"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 607).
-spec source(list(lustre@internals@vdom:attribute(RCW))) -> lustre@internals@vdom:element(RCW).
source(Attrs) ->
    lustre@element:element(<<"source"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 614).
-spec svg(
    list(lustre@internals@vdom:attribute(RDA)),
    list(lustre@internals@vdom:element(RDA))
) -> lustre@internals@vdom:element(RDA).
svg(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"svg"/utf8>>,
        Attrs,
        Children
    ).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 622).
-spec math(
    list(lustre@internals@vdom:attribute(RDG)),
    list(lustre@internals@vdom:element(RDG))
) -> lustre@internals@vdom:element(RDG).
math(Attrs, Children) ->
    lustre@element:element(<<"math"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 632).
-spec canvas(list(lustre@internals@vdom:attribute(RDM))) -> lustre@internals@vdom:element(RDM).
canvas(Attrs) ->
    lustre@element:element(<<"canvas"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 637).
-spec noscript(
    list(lustre@internals@vdom:attribute(RDQ)),
    list(lustre@internals@vdom:element(RDQ))
) -> lustre@internals@vdom:element(RDQ).
noscript(Attrs, Children) ->
    lustre@element:element(<<"noscript"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 645).
-spec script(list(lustre@internals@vdom:attribute(RDW)), binary()) -> lustre@internals@vdom:element(RDW).
script(Attrs, Js) ->
    lustre@element:element(<<"script"/utf8>>, Attrs, [text(Js)]).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 652).
-spec del(
    list(lustre@internals@vdom:attribute(REA)),
    list(lustre@internals@vdom:element(REA))
) -> lustre@internals@vdom:element(REA).
del(Attrs, Children) ->
    lustre@element:element(<<"del"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 660).
-spec ins(
    list(lustre@internals@vdom:attribute(REG)),
    list(lustre@internals@vdom:element(REG))
) -> lustre@internals@vdom:element(REG).
ins(Attrs, Children) ->
    lustre@element:element(<<"ins"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 670).
-spec caption(
    list(lustre@internals@vdom:attribute(REM)),
    list(lustre@internals@vdom:element(REM))
) -> lustre@internals@vdom:element(REM).
caption(Attrs, Children) ->
    lustre@element:element(<<"caption"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 678).
-spec col(list(lustre@internals@vdom:attribute(RES))) -> lustre@internals@vdom:element(RES).
col(Attrs) ->
    lustre@element:element(<<"col"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 683).
-spec colgroup(
    list(lustre@internals@vdom:attribute(REW)),
    list(lustre@internals@vdom:element(REW))
) -> lustre@internals@vdom:element(REW).
colgroup(Attrs, Children) ->
    lustre@element:element(<<"colgroup"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 691).
-spec table(
    list(lustre@internals@vdom:attribute(RFC)),
    list(lustre@internals@vdom:element(RFC))
) -> lustre@internals@vdom:element(RFC).
table(Attrs, Children) ->
    lustre@element:element(<<"table"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 699).
-spec tbody(
    list(lustre@internals@vdom:attribute(RFI)),
    list(lustre@internals@vdom:element(RFI))
) -> lustre@internals@vdom:element(RFI).
tbody(Attrs, Children) ->
    lustre@element:element(<<"tbody"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 707).
-spec td(
    list(lustre@internals@vdom:attribute(RFO)),
    list(lustre@internals@vdom:element(RFO))
) -> lustre@internals@vdom:element(RFO).
td(Attrs, Children) ->
    lustre@element:element(<<"td"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 715).
-spec tfoot(
    list(lustre@internals@vdom:attribute(RFU)),
    list(lustre@internals@vdom:element(RFU))
) -> lustre@internals@vdom:element(RFU).
tfoot(Attrs, Children) ->
    lustre@element:element(<<"tfoot"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 723).
-spec th(
    list(lustre@internals@vdom:attribute(RGA)),
    list(lustre@internals@vdom:element(RGA))
) -> lustre@internals@vdom:element(RGA).
th(Attrs, Children) ->
    lustre@element:element(<<"th"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 731).
-spec thead(
    list(lustre@internals@vdom:attribute(RGG)),
    list(lustre@internals@vdom:element(RGG))
) -> lustre@internals@vdom:element(RGG).
thead(Attrs, Children) ->
    lustre@element:element(<<"thead"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 739).
-spec tr(
    list(lustre@internals@vdom:attribute(RGM)),
    list(lustre@internals@vdom:element(RGM))
) -> lustre@internals@vdom:element(RGM).
tr(Attrs, Children) ->
    lustre@element:element(<<"tr"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 749).
-spec button(
    list(lustre@internals@vdom:attribute(RGS)),
    list(lustre@internals@vdom:element(RGS))
) -> lustre@internals@vdom:element(RGS).
button(Attrs, Children) ->
    lustre@element:element(<<"button"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 757).
-spec datalist(
    list(lustre@internals@vdom:attribute(RGY)),
    list(lustre@internals@vdom:element(RGY))
) -> lustre@internals@vdom:element(RGY).
datalist(Attrs, Children) ->
    lustre@element:element(<<"datalist"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 765).
-spec fieldset(
    list(lustre@internals@vdom:attribute(RHE)),
    list(lustre@internals@vdom:element(RHE))
) -> lustre@internals@vdom:element(RHE).
fieldset(Attrs, Children) ->
    lustre@element:element(<<"fieldset"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 773).
-spec form(
    list(lustre@internals@vdom:attribute(RHK)),
    list(lustre@internals@vdom:element(RHK))
) -> lustre@internals@vdom:element(RHK).
form(Attrs, Children) ->
    lustre@element:element(<<"form"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 781).
-spec input(list(lustre@internals@vdom:attribute(RHQ))) -> lustre@internals@vdom:element(RHQ).
input(Attrs) ->
    lustre@element:element(<<"input"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 786).
-spec label(
    list(lustre@internals@vdom:attribute(RHU)),
    list(lustre@internals@vdom:element(RHU))
) -> lustre@internals@vdom:element(RHU).
label(Attrs, Children) ->
    lustre@element:element(<<"label"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 794).
-spec legend(
    list(lustre@internals@vdom:attribute(RIA)),
    list(lustre@internals@vdom:element(RIA))
) -> lustre@internals@vdom:element(RIA).
legend(Attrs, Children) ->
    lustre@element:element(<<"legend"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 802).
-spec meter(
    list(lustre@internals@vdom:attribute(RIG)),
    list(lustre@internals@vdom:element(RIG))
) -> lustre@internals@vdom:element(RIG).
meter(Attrs, Children) ->
    lustre@element:element(<<"meter"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 810).
-spec optgroup(
    list(lustre@internals@vdom:attribute(RIM)),
    list(lustre@internals@vdom:element(RIM))
) -> lustre@internals@vdom:element(RIM).
optgroup(Attrs, Children) ->
    lustre@element:element(<<"optgroup"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 818).
-spec option(list(lustre@internals@vdom:attribute(RIS)), binary()) -> lustre@internals@vdom:element(RIS).
option(Attrs, Label) ->
    lustre@element:element(
        <<"option"/utf8>>,
        Attrs,
        [lustre@element:text(Label)]
    ).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 823).
-spec output(
    list(lustre@internals@vdom:attribute(RIW)),
    list(lustre@internals@vdom:element(RIW))
) -> lustre@internals@vdom:element(RIW).
output(Attrs, Children) ->
    lustre@element:element(<<"output"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 831).
-spec progress(
    list(lustre@internals@vdom:attribute(RJC)),
    list(lustre@internals@vdom:element(RJC))
) -> lustre@internals@vdom:element(RJC).
progress(Attrs, Children) ->
    lustre@element:element(<<"progress"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 839).
-spec select(
    list(lustre@internals@vdom:attribute(RJI)),
    list(lustre@internals@vdom:element(RJI))
) -> lustre@internals@vdom:element(RJI).
select(Attrs, Children) ->
    lustre@element:element(<<"select"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 847).
-spec textarea(list(lustre@internals@vdom:attribute(RJO)), binary()) -> lustre@internals@vdom:element(RJO).
textarea(Attrs, Content) ->
    lustre@element:element(
        <<"textarea"/utf8>>,
        Attrs,
        [lustre@element:text(Content)]
    ).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 854).
-spec details(
    list(lustre@internals@vdom:attribute(RJS)),
    list(lustre@internals@vdom:element(RJS))
) -> lustre@internals@vdom:element(RJS).
details(Attrs, Children) ->
    lustre@element:element(<<"details"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 862).
-spec dialog(
    list(lustre@internals@vdom:attribute(RJY)),
    list(lustre@internals@vdom:element(RJY))
) -> lustre@internals@vdom:element(RJY).
dialog(Attrs, Children) ->
    lustre@element:element(<<"dialog"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 870).
-spec summary(
    list(lustre@internals@vdom:attribute(RKE)),
    list(lustre@internals@vdom:element(RKE))
) -> lustre@internals@vdom:element(RKE).
summary(Attrs, Children) ->
    lustre@element:element(<<"summary"/utf8>>, Attrs, Children).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 880).
-spec slot(list(lustre@internals@vdom:attribute(RKK))) -> lustre@internals@vdom:element(RKK).
slot(Attrs) ->
    lustre@element:element(<<"slot"/utf8>>, Attrs, []).

-file("/home/runner/work/lustre/lustre/src/lustre/element/html.gleam", 885).
-spec template(
    list(lustre@internals@vdom:attribute(RKO)),
    list(lustre@internals@vdom:element(RKO))
) -> lustre@internals@vdom:element(RKO).
template(Attrs, Children) ->
    lustre@element:element(<<"template"/utf8>>, Attrs, Children).
