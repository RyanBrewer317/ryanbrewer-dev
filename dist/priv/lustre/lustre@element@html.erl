-module(lustre@element@html).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([html/2, text/1, base/1, head/2, link/1, meta/1, style/2, title/2, body/2, address/2, article/2, aside/2, footer/2, header/2, h1/2, h2/2, h3/2, h4/2, h5/2, h6/2, hgroup/2, main/2, nav/2, section/2, search/2, blockquote/2, dd/2, 'div'/2, dl/2, dt/2, figcaption/2, figure/2, hr/1, li/2, menu/2, ol/2, p/2, pre/2, ul/2, a/2, abbr/2, b/2, bdi/2, bdo/2, br/1, cite/2, code/2, data/2, dfn/2, em/2, i/2, kbd/2, mark/2, q/2, rp/2, rt/2, ruby/2, s/2, samp/2, small/2, span/2, strong/2, sub/2, sup/2, time/2, u/2, var/2, wbr/1, area/1, audio/2, img/1, map/2, track/1, video/2, embed/1, iframe/1, object/1, picture/2, portal/1, source/1, svg/2, math/2, canvas/1, noscript/2, script/2, del/2, ins/2, caption/2, col/1, colgroup/2, table/2, tbody/2, td/2, tfoot/2, th/2, thead/2, tr/2, button/2, datalist/2, fieldset/2, form/2, input/1, label/2, legend/2, meter/2, optgroup/2, option/2, output/2, progress/2, select/2, textarea/2, details/2, dialog/2, summary/2, slot/1, template/2]).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 9).
-spec html(
    list(lustre@internals@vdom:attribute(QMQ)),
    list(lustre@internals@vdom:element(QMQ))
) -> lustre@internals@vdom:element(QMQ).
html(Attrs, Children) ->
    lustre@element:element(<<"html"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 16).
-spec text(binary()) -> lustre@internals@vdom:element(any()).
text(Content) ->
    lustre@element:text(Content).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 23).
-spec base(list(lustre@internals@vdom:attribute(QMY))) -> lustre@internals@vdom:element(QMY).
base(Attrs) ->
    lustre@element:element(<<"base"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 28).
-spec head(
    list(lustre@internals@vdom:attribute(QNC)),
    list(lustre@internals@vdom:element(QNC))
) -> lustre@internals@vdom:element(QNC).
head(Attrs, Children) ->
    lustre@element:element(<<"head"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 36).
-spec link(list(lustre@internals@vdom:attribute(QNI))) -> lustre@internals@vdom:element(QNI).
link(Attrs) ->
    lustre@element:element(<<"link"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 41).
-spec meta(list(lustre@internals@vdom:attribute(QNM))) -> lustre@internals@vdom:element(QNM).
meta(Attrs) ->
    lustre@element:element(<<"meta"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 46).
-spec style(list(lustre@internals@vdom:attribute(QNQ)), binary()) -> lustre@internals@vdom:element(QNQ).
style(Attrs, Css) ->
    lustre@element:element(<<"style"/utf8>>, Attrs, [text(Css)]).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 51).
-spec title(list(lustre@internals@vdom:attribute(QNU)), binary()) -> lustre@internals@vdom:element(QNU).
title(Attrs, Content) ->
    lustre@element:element(<<"title"/utf8>>, Attrs, [text(Content)]).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 58).
-spec body(
    list(lustre@internals@vdom:attribute(QNY)),
    list(lustre@internals@vdom:element(QNY))
) -> lustre@internals@vdom:element(QNY).
body(Attrs, Children) ->
    lustre@element:element(<<"body"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 68).
-spec address(
    list(lustre@internals@vdom:attribute(QOE)),
    list(lustre@internals@vdom:element(QOE))
) -> lustre@internals@vdom:element(QOE).
address(Attrs, Children) ->
    lustre@element:element(<<"address"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 76).
-spec article(
    list(lustre@internals@vdom:attribute(QOK)),
    list(lustre@internals@vdom:element(QOK))
) -> lustre@internals@vdom:element(QOK).
article(Attrs, Children) ->
    lustre@element:element(<<"article"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 84).
-spec aside(
    list(lustre@internals@vdom:attribute(QOQ)),
    list(lustre@internals@vdom:element(QOQ))
) -> lustre@internals@vdom:element(QOQ).
aside(Attrs, Children) ->
    lustre@element:element(<<"aside"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 92).
-spec footer(
    list(lustre@internals@vdom:attribute(QOW)),
    list(lustre@internals@vdom:element(QOW))
) -> lustre@internals@vdom:element(QOW).
footer(Attrs, Children) ->
    lustre@element:element(<<"footer"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 100).
-spec header(
    list(lustre@internals@vdom:attribute(QPC)),
    list(lustre@internals@vdom:element(QPC))
) -> lustre@internals@vdom:element(QPC).
header(Attrs, Children) ->
    lustre@element:element(<<"header"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 108).
-spec h1(
    list(lustre@internals@vdom:attribute(QPI)),
    list(lustre@internals@vdom:element(QPI))
) -> lustre@internals@vdom:element(QPI).
h1(Attrs, Children) ->
    lustre@element:element(<<"h1"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 116).
-spec h2(
    list(lustre@internals@vdom:attribute(QPO)),
    list(lustre@internals@vdom:element(QPO))
) -> lustre@internals@vdom:element(QPO).
h2(Attrs, Children) ->
    lustre@element:element(<<"h2"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 124).
-spec h3(
    list(lustre@internals@vdom:attribute(QPU)),
    list(lustre@internals@vdom:element(QPU))
) -> lustre@internals@vdom:element(QPU).
h3(Attrs, Children) ->
    lustre@element:element(<<"h3"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 132).
-spec h4(
    list(lustre@internals@vdom:attribute(QQA)),
    list(lustre@internals@vdom:element(QQA))
) -> lustre@internals@vdom:element(QQA).
h4(Attrs, Children) ->
    lustre@element:element(<<"h4"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 140).
-spec h5(
    list(lustre@internals@vdom:attribute(QQG)),
    list(lustre@internals@vdom:element(QQG))
) -> lustre@internals@vdom:element(QQG).
h5(Attrs, Children) ->
    lustre@element:element(<<"h5"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 148).
-spec h6(
    list(lustre@internals@vdom:attribute(QQM)),
    list(lustre@internals@vdom:element(QQM))
) -> lustre@internals@vdom:element(QQM).
h6(Attrs, Children) ->
    lustre@element:element(<<"h6"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 156).
-spec hgroup(
    list(lustre@internals@vdom:attribute(QQS)),
    list(lustre@internals@vdom:element(QQS))
) -> lustre@internals@vdom:element(QQS).
hgroup(Attrs, Children) ->
    lustre@element:element(<<"hgroup"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 164).
-spec main(
    list(lustre@internals@vdom:attribute(QQY)),
    list(lustre@internals@vdom:element(QQY))
) -> lustre@internals@vdom:element(QQY).
main(Attrs, Children) ->
    lustre@element:element(<<"main"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 172).
-spec nav(
    list(lustre@internals@vdom:attribute(QRE)),
    list(lustre@internals@vdom:element(QRE))
) -> lustre@internals@vdom:element(QRE).
nav(Attrs, Children) ->
    lustre@element:element(<<"nav"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 180).
-spec section(
    list(lustre@internals@vdom:attribute(QRK)),
    list(lustre@internals@vdom:element(QRK))
) -> lustre@internals@vdom:element(QRK).
section(Attrs, Children) ->
    lustre@element:element(<<"section"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 188).
-spec search(
    list(lustre@internals@vdom:attribute(QRQ)),
    list(lustre@internals@vdom:element(QRQ))
) -> lustre@internals@vdom:element(QRQ).
search(Attrs, Children) ->
    lustre@element:element(<<"search"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 198).
-spec blockquote(
    list(lustre@internals@vdom:attribute(QRW)),
    list(lustre@internals@vdom:element(QRW))
) -> lustre@internals@vdom:element(QRW).
blockquote(Attrs, Children) ->
    lustre@element:element(<<"blockquote"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 206).
-spec dd(
    list(lustre@internals@vdom:attribute(QSC)),
    list(lustre@internals@vdom:element(QSC))
) -> lustre@internals@vdom:element(QSC).
dd(Attrs, Children) ->
    lustre@element:element(<<"dd"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 214).
-spec 'div'(
    list(lustre@internals@vdom:attribute(QSI)),
    list(lustre@internals@vdom:element(QSI))
) -> lustre@internals@vdom:element(QSI).
'div'(Attrs, Children) ->
    lustre@element:element(<<"div"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 222).
-spec dl(
    list(lustre@internals@vdom:attribute(QSO)),
    list(lustre@internals@vdom:element(QSO))
) -> lustre@internals@vdom:element(QSO).
dl(Attrs, Children) ->
    lustre@element:element(<<"dl"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 230).
-spec dt(
    list(lustre@internals@vdom:attribute(QSU)),
    list(lustre@internals@vdom:element(QSU))
) -> lustre@internals@vdom:element(QSU).
dt(Attrs, Children) ->
    lustre@element:element(<<"dt"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 238).
-spec figcaption(
    list(lustre@internals@vdom:attribute(QTA)),
    list(lustre@internals@vdom:element(QTA))
) -> lustre@internals@vdom:element(QTA).
figcaption(Attrs, Children) ->
    lustre@element:element(<<"figcaption"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 246).
-spec figure(
    list(lustre@internals@vdom:attribute(QTG)),
    list(lustre@internals@vdom:element(QTG))
) -> lustre@internals@vdom:element(QTG).
figure(Attrs, Children) ->
    lustre@element:element(<<"figure"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 254).
-spec hr(list(lustre@internals@vdom:attribute(QTM))) -> lustre@internals@vdom:element(QTM).
hr(Attrs) ->
    lustre@element:element(<<"hr"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 259).
-spec li(
    list(lustre@internals@vdom:attribute(QTQ)),
    list(lustre@internals@vdom:element(QTQ))
) -> lustre@internals@vdom:element(QTQ).
li(Attrs, Children) ->
    lustre@element:element(<<"li"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 267).
-spec menu(
    list(lustre@internals@vdom:attribute(QTW)),
    list(lustre@internals@vdom:element(QTW))
) -> lustre@internals@vdom:element(QTW).
menu(Attrs, Children) ->
    lustre@element:element(<<"menu"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 275).
-spec ol(
    list(lustre@internals@vdom:attribute(QUC)),
    list(lustre@internals@vdom:element(QUC))
) -> lustre@internals@vdom:element(QUC).
ol(Attrs, Children) ->
    lustre@element:element(<<"ol"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 283).
-spec p(
    list(lustre@internals@vdom:attribute(QUI)),
    list(lustre@internals@vdom:element(QUI))
) -> lustre@internals@vdom:element(QUI).
p(Attrs, Children) ->
    lustre@element:element(<<"p"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 291).
-spec pre(
    list(lustre@internals@vdom:attribute(QUO)),
    list(lustre@internals@vdom:element(QUO))
) -> lustre@internals@vdom:element(QUO).
pre(Attrs, Children) ->
    lustre@element:element(<<"pre"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 299).
-spec ul(
    list(lustre@internals@vdom:attribute(QUU)),
    list(lustre@internals@vdom:element(QUU))
) -> lustre@internals@vdom:element(QUU).
ul(Attrs, Children) ->
    lustre@element:element(<<"ul"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 309).
-spec a(
    list(lustre@internals@vdom:attribute(QVA)),
    list(lustre@internals@vdom:element(QVA))
) -> lustre@internals@vdom:element(QVA).
a(Attrs, Children) ->
    lustre@element:element(<<"a"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 317).
-spec abbr(
    list(lustre@internals@vdom:attribute(QVG)),
    list(lustre@internals@vdom:element(QVG))
) -> lustre@internals@vdom:element(QVG).
abbr(Attrs, Children) ->
    lustre@element:element(<<"abbr"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 325).
-spec b(
    list(lustre@internals@vdom:attribute(QVM)),
    list(lustre@internals@vdom:element(QVM))
) -> lustre@internals@vdom:element(QVM).
b(Attrs, Children) ->
    lustre@element:element(<<"b"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 333).
-spec bdi(
    list(lustre@internals@vdom:attribute(QVS)),
    list(lustre@internals@vdom:element(QVS))
) -> lustre@internals@vdom:element(QVS).
bdi(Attrs, Children) ->
    lustre@element:element(<<"bdi"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 341).
-spec bdo(
    list(lustre@internals@vdom:attribute(QVY)),
    list(lustre@internals@vdom:element(QVY))
) -> lustre@internals@vdom:element(QVY).
bdo(Attrs, Children) ->
    lustre@element:element(<<"bdo"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 349).
-spec br(list(lustre@internals@vdom:attribute(QWE))) -> lustre@internals@vdom:element(QWE).
br(Attrs) ->
    lustre@element:element(<<"br"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 354).
-spec cite(
    list(lustre@internals@vdom:attribute(QWI)),
    list(lustre@internals@vdom:element(QWI))
) -> lustre@internals@vdom:element(QWI).
cite(Attrs, Children) ->
    lustre@element:element(<<"cite"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 362).
-spec code(
    list(lustre@internals@vdom:attribute(QWO)),
    list(lustre@internals@vdom:element(QWO))
) -> lustre@internals@vdom:element(QWO).
code(Attrs, Children) ->
    lustre@element:element(<<"code"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 370).
-spec data(
    list(lustre@internals@vdom:attribute(QWU)),
    list(lustre@internals@vdom:element(QWU))
) -> lustre@internals@vdom:element(QWU).
data(Attrs, Children) ->
    lustre@element:element(<<"data"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 378).
-spec dfn(
    list(lustre@internals@vdom:attribute(QXA)),
    list(lustre@internals@vdom:element(QXA))
) -> lustre@internals@vdom:element(QXA).
dfn(Attrs, Children) ->
    lustre@element:element(<<"dfn"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 386).
-spec em(
    list(lustre@internals@vdom:attribute(QXG)),
    list(lustre@internals@vdom:element(QXG))
) -> lustre@internals@vdom:element(QXG).
em(Attrs, Children) ->
    lustre@element:element(<<"em"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 394).
-spec i(
    list(lustre@internals@vdom:attribute(QXM)),
    list(lustre@internals@vdom:element(QXM))
) -> lustre@internals@vdom:element(QXM).
i(Attrs, Children) ->
    lustre@element:element(<<"i"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 402).
-spec kbd(
    list(lustre@internals@vdom:attribute(QXS)),
    list(lustre@internals@vdom:element(QXS))
) -> lustre@internals@vdom:element(QXS).
kbd(Attrs, Children) ->
    lustre@element:element(<<"kbd"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 410).
-spec mark(
    list(lustre@internals@vdom:attribute(QXY)),
    list(lustre@internals@vdom:element(QXY))
) -> lustre@internals@vdom:element(QXY).
mark(Attrs, Children) ->
    lustre@element:element(<<"mark"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 418).
-spec q(
    list(lustre@internals@vdom:attribute(QYE)),
    list(lustre@internals@vdom:element(QYE))
) -> lustre@internals@vdom:element(QYE).
q(Attrs, Children) ->
    lustre@element:element(<<"q"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 426).
-spec rp(
    list(lustre@internals@vdom:attribute(QYK)),
    list(lustre@internals@vdom:element(QYK))
) -> lustre@internals@vdom:element(QYK).
rp(Attrs, Children) ->
    lustre@element:element(<<"rp"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 434).
-spec rt(
    list(lustre@internals@vdom:attribute(QYQ)),
    list(lustre@internals@vdom:element(QYQ))
) -> lustre@internals@vdom:element(QYQ).
rt(Attrs, Children) ->
    lustre@element:element(<<"rt"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 442).
-spec ruby(
    list(lustre@internals@vdom:attribute(QYW)),
    list(lustre@internals@vdom:element(QYW))
) -> lustre@internals@vdom:element(QYW).
ruby(Attrs, Children) ->
    lustre@element:element(<<"ruby"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 450).
-spec s(
    list(lustre@internals@vdom:attribute(QZC)),
    list(lustre@internals@vdom:element(QZC))
) -> lustre@internals@vdom:element(QZC).
s(Attrs, Children) ->
    lustre@element:element(<<"s"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 458).
-spec samp(
    list(lustre@internals@vdom:attribute(QZI)),
    list(lustre@internals@vdom:element(QZI))
) -> lustre@internals@vdom:element(QZI).
samp(Attrs, Children) ->
    lustre@element:element(<<"samp"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 466).
-spec small(
    list(lustre@internals@vdom:attribute(QZO)),
    list(lustre@internals@vdom:element(QZO))
) -> lustre@internals@vdom:element(QZO).
small(Attrs, Children) ->
    lustre@element:element(<<"small"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 474).
-spec span(
    list(lustre@internals@vdom:attribute(QZU)),
    list(lustre@internals@vdom:element(QZU))
) -> lustre@internals@vdom:element(QZU).
span(Attrs, Children) ->
    lustre@element:element(<<"span"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 482).
-spec strong(
    list(lustre@internals@vdom:attribute(RAA)),
    list(lustre@internals@vdom:element(RAA))
) -> lustre@internals@vdom:element(RAA).
strong(Attrs, Children) ->
    lustre@element:element(<<"strong"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 490).
-spec sub(
    list(lustre@internals@vdom:attribute(RAG)),
    list(lustre@internals@vdom:element(RAG))
) -> lustre@internals@vdom:element(RAG).
sub(Attrs, Children) ->
    lustre@element:element(<<"sub"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 498).
-spec sup(
    list(lustre@internals@vdom:attribute(RAM)),
    list(lustre@internals@vdom:element(RAM))
) -> lustre@internals@vdom:element(RAM).
sup(Attrs, Children) ->
    lustre@element:element(<<"sup"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 506).
-spec time(
    list(lustre@internals@vdom:attribute(RAS)),
    list(lustre@internals@vdom:element(RAS))
) -> lustre@internals@vdom:element(RAS).
time(Attrs, Children) ->
    lustre@element:element(<<"time"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 514).
-spec u(
    list(lustre@internals@vdom:attribute(RAY)),
    list(lustre@internals@vdom:element(RAY))
) -> lustre@internals@vdom:element(RAY).
u(Attrs, Children) ->
    lustre@element:element(<<"u"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 522).
-spec var(
    list(lustre@internals@vdom:attribute(RBE)),
    list(lustre@internals@vdom:element(RBE))
) -> lustre@internals@vdom:element(RBE).
var(Attrs, Children) ->
    lustre@element:element(<<"var"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 530).
-spec wbr(list(lustre@internals@vdom:attribute(RBK))) -> lustre@internals@vdom:element(RBK).
wbr(Attrs) ->
    lustre@element:element(<<"wbr"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 537).
-spec area(list(lustre@internals@vdom:attribute(RBO))) -> lustre@internals@vdom:element(RBO).
area(Attrs) ->
    lustre@element:element(<<"area"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 542).
-spec audio(
    list(lustre@internals@vdom:attribute(RBS)),
    list(lustre@internals@vdom:element(RBS))
) -> lustre@internals@vdom:element(RBS).
audio(Attrs, Children) ->
    lustre@element:element(<<"audio"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 550).
-spec img(list(lustre@internals@vdom:attribute(RBY))) -> lustre@internals@vdom:element(RBY).
img(Attrs) ->
    lustre@element:element(<<"img"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 556).
-spec map(
    list(lustre@internals@vdom:attribute(RCC)),
    list(lustre@internals@vdom:element(RCC))
) -> lustre@internals@vdom:element(RCC).
map(Attrs, Children) ->
    lustre@element:element(<<"map"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 564).
-spec track(list(lustre@internals@vdom:attribute(RCI))) -> lustre@internals@vdom:element(RCI).
track(Attrs) ->
    lustre@element:element(<<"track"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 569).
-spec video(
    list(lustre@internals@vdom:attribute(RCM)),
    list(lustre@internals@vdom:element(RCM))
) -> lustre@internals@vdom:element(RCM).
video(Attrs, Children) ->
    lustre@element:element(<<"video"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 579).
-spec embed(list(lustre@internals@vdom:attribute(RCS))) -> lustre@internals@vdom:element(RCS).
embed(Attrs) ->
    lustre@element:element(<<"embed"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 584).
-spec iframe(list(lustre@internals@vdom:attribute(RCW))) -> lustre@internals@vdom:element(RCW).
iframe(Attrs) ->
    lustre@element:element(<<"iframe"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 589).
-spec object(list(lustre@internals@vdom:attribute(RDA))) -> lustre@internals@vdom:element(RDA).
object(Attrs) ->
    lustre@element:element(<<"object"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 594).
-spec picture(
    list(lustre@internals@vdom:attribute(RDE)),
    list(lustre@internals@vdom:element(RDE))
) -> lustre@internals@vdom:element(RDE).
picture(Attrs, Children) ->
    lustre@element:element(<<"picture"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 602).
-spec portal(list(lustre@internals@vdom:attribute(RDK))) -> lustre@internals@vdom:element(RDK).
portal(Attrs) ->
    lustre@element:element(<<"portal"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 607).
-spec source(list(lustre@internals@vdom:attribute(RDO))) -> lustre@internals@vdom:element(RDO).
source(Attrs) ->
    lustre@element:element(<<"source"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 614).
-spec svg(
    list(lustre@internals@vdom:attribute(RDS)),
    list(lustre@internals@vdom:element(RDS))
) -> lustre@internals@vdom:element(RDS).
svg(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"svg"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 622).
-spec math(
    list(lustre@internals@vdom:attribute(RDY)),
    list(lustre@internals@vdom:element(RDY))
) -> lustre@internals@vdom:element(RDY).
math(Attrs, Children) ->
    lustre@element:element(<<"math"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 632).
-spec canvas(list(lustre@internals@vdom:attribute(REE))) -> lustre@internals@vdom:element(REE).
canvas(Attrs) ->
    lustre@element:element(<<"canvas"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 637).
-spec noscript(
    list(lustre@internals@vdom:attribute(REI)),
    list(lustre@internals@vdom:element(REI))
) -> lustre@internals@vdom:element(REI).
noscript(Attrs, Children) ->
    lustre@element:element(<<"noscript"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 645).
-spec script(list(lustre@internals@vdom:attribute(REO)), binary()) -> lustre@internals@vdom:element(REO).
script(Attrs, Js) ->
    lustre@element:element(<<"script"/utf8>>, Attrs, [text(Js)]).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 652).
-spec del(
    list(lustre@internals@vdom:attribute(RES)),
    list(lustre@internals@vdom:element(RES))
) -> lustre@internals@vdom:element(RES).
del(Attrs, Children) ->
    lustre@element:element(<<"del"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 660).
-spec ins(
    list(lustre@internals@vdom:attribute(REY)),
    list(lustre@internals@vdom:element(REY))
) -> lustre@internals@vdom:element(REY).
ins(Attrs, Children) ->
    lustre@element:element(<<"ins"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 670).
-spec caption(
    list(lustre@internals@vdom:attribute(RFE)),
    list(lustre@internals@vdom:element(RFE))
) -> lustre@internals@vdom:element(RFE).
caption(Attrs, Children) ->
    lustre@element:element(<<"caption"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 678).
-spec col(list(lustre@internals@vdom:attribute(RFK))) -> lustre@internals@vdom:element(RFK).
col(Attrs) ->
    lustre@element:element(<<"col"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 683).
-spec colgroup(
    list(lustre@internals@vdom:attribute(RFO)),
    list(lustre@internals@vdom:element(RFO))
) -> lustre@internals@vdom:element(RFO).
colgroup(Attrs, Children) ->
    lustre@element:element(<<"colgroup"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 691).
-spec table(
    list(lustre@internals@vdom:attribute(RFU)),
    list(lustre@internals@vdom:element(RFU))
) -> lustre@internals@vdom:element(RFU).
table(Attrs, Children) ->
    lustre@element:element(<<"table"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 699).
-spec tbody(
    list(lustre@internals@vdom:attribute(RGA)),
    list(lustre@internals@vdom:element(RGA))
) -> lustre@internals@vdom:element(RGA).
tbody(Attrs, Children) ->
    lustre@element:element(<<"tbody"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 707).
-spec td(
    list(lustre@internals@vdom:attribute(RGG)),
    list(lustre@internals@vdom:element(RGG))
) -> lustre@internals@vdom:element(RGG).
td(Attrs, Children) ->
    lustre@element:element(<<"td"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 715).
-spec tfoot(
    list(lustre@internals@vdom:attribute(RGM)),
    list(lustre@internals@vdom:element(RGM))
) -> lustre@internals@vdom:element(RGM).
tfoot(Attrs, Children) ->
    lustre@element:element(<<"tfoot"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 723).
-spec th(
    list(lustre@internals@vdom:attribute(RGS)),
    list(lustre@internals@vdom:element(RGS))
) -> lustre@internals@vdom:element(RGS).
th(Attrs, Children) ->
    lustre@element:element(<<"th"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 731).
-spec thead(
    list(lustre@internals@vdom:attribute(RGY)),
    list(lustre@internals@vdom:element(RGY))
) -> lustre@internals@vdom:element(RGY).
thead(Attrs, Children) ->
    lustre@element:element(<<"thead"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 739).
-spec tr(
    list(lustre@internals@vdom:attribute(RHE)),
    list(lustre@internals@vdom:element(RHE))
) -> lustre@internals@vdom:element(RHE).
tr(Attrs, Children) ->
    lustre@element:element(<<"tr"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 749).
-spec button(
    list(lustre@internals@vdom:attribute(RHK)),
    list(lustre@internals@vdom:element(RHK))
) -> lustre@internals@vdom:element(RHK).
button(Attrs, Children) ->
    lustre@element:element(<<"button"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 757).
-spec datalist(
    list(lustre@internals@vdom:attribute(RHQ)),
    list(lustre@internals@vdom:element(RHQ))
) -> lustre@internals@vdom:element(RHQ).
datalist(Attrs, Children) ->
    lustre@element:element(<<"datalist"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 765).
-spec fieldset(
    list(lustre@internals@vdom:attribute(RHW)),
    list(lustre@internals@vdom:element(RHW))
) -> lustre@internals@vdom:element(RHW).
fieldset(Attrs, Children) ->
    lustre@element:element(<<"fieldset"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 773).
-spec form(
    list(lustre@internals@vdom:attribute(RIC)),
    list(lustre@internals@vdom:element(RIC))
) -> lustre@internals@vdom:element(RIC).
form(Attrs, Children) ->
    lustre@element:element(<<"form"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 781).
-spec input(list(lustre@internals@vdom:attribute(RII))) -> lustre@internals@vdom:element(RII).
input(Attrs) ->
    lustre@element:element(<<"input"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 786).
-spec label(
    list(lustre@internals@vdom:attribute(RIM)),
    list(lustre@internals@vdom:element(RIM))
) -> lustre@internals@vdom:element(RIM).
label(Attrs, Children) ->
    lustre@element:element(<<"label"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 794).
-spec legend(
    list(lustre@internals@vdom:attribute(RIS)),
    list(lustre@internals@vdom:element(RIS))
) -> lustre@internals@vdom:element(RIS).
legend(Attrs, Children) ->
    lustre@element:element(<<"legend"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 802).
-spec meter(
    list(lustre@internals@vdom:attribute(RIY)),
    list(lustre@internals@vdom:element(RIY))
) -> lustre@internals@vdom:element(RIY).
meter(Attrs, Children) ->
    lustre@element:element(<<"meter"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 810).
-spec optgroup(
    list(lustre@internals@vdom:attribute(RJE)),
    list(lustre@internals@vdom:element(RJE))
) -> lustre@internals@vdom:element(RJE).
optgroup(Attrs, Children) ->
    lustre@element:element(<<"optgroup"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 818).
-spec option(list(lustre@internals@vdom:attribute(RJK)), binary()) -> lustre@internals@vdom:element(RJK).
option(Attrs, Label) ->
    lustre@element:element(
        <<"option"/utf8>>,
        Attrs,
        [lustre@element:text(Label)]
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 823).
-spec output(
    list(lustre@internals@vdom:attribute(RJO)),
    list(lustre@internals@vdom:element(RJO))
) -> lustre@internals@vdom:element(RJO).
output(Attrs, Children) ->
    lustre@element:element(<<"output"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 831).
-spec progress(
    list(lustre@internals@vdom:attribute(RJU)),
    list(lustre@internals@vdom:element(RJU))
) -> lustre@internals@vdom:element(RJU).
progress(Attrs, Children) ->
    lustre@element:element(<<"progress"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 839).
-spec select(
    list(lustre@internals@vdom:attribute(RKA)),
    list(lustre@internals@vdom:element(RKA))
) -> lustre@internals@vdom:element(RKA).
select(Attrs, Children) ->
    lustre@element:element(<<"select"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 847).
-spec textarea(list(lustre@internals@vdom:attribute(RKG)), binary()) -> lustre@internals@vdom:element(RKG).
textarea(Attrs, Content) ->
    lustre@element:element(
        <<"textarea"/utf8>>,
        Attrs,
        [lustre@element:text(Content)]
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 854).
-spec details(
    list(lustre@internals@vdom:attribute(RKK)),
    list(lustre@internals@vdom:element(RKK))
) -> lustre@internals@vdom:element(RKK).
details(Attrs, Children) ->
    lustre@element:element(<<"details"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 862).
-spec dialog(
    list(lustre@internals@vdom:attribute(RKQ)),
    list(lustre@internals@vdom:element(RKQ))
) -> lustre@internals@vdom:element(RKQ).
dialog(Attrs, Children) ->
    lustre@element:element(<<"dialog"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 870).
-spec summary(
    list(lustre@internals@vdom:attribute(RKW)),
    list(lustre@internals@vdom:element(RKW))
) -> lustre@internals@vdom:element(RKW).
summary(Attrs, Children) ->
    lustre@element:element(<<"summary"/utf8>>, Attrs, Children).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 880).
-spec slot(list(lustre@internals@vdom:attribute(RLC))) -> lustre@internals@vdom:element(RLC).
slot(Attrs) ->
    lustre@element:element(<<"slot"/utf8>>, Attrs, []).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/html.gleam", 885).
-spec template(
    list(lustre@internals@vdom:attribute(RLG)),
    list(lustre@internals@vdom:element(RLG))
) -> lustre@internals@vdom:element(RLG).
template(Attrs, Children) ->
    lustre@element:element(<<"template"/utf8>>, Attrs, Children).
