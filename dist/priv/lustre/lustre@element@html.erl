-module(lustre@element@html).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([html/2, text/1, base/1, head/2, link/1, meta/1, style/2, title/2, body/2, address/2, article/2, aside/2, footer/2, header/2, h1/2, h2/2, h3/2, h4/2, h5/2, h6/2, hgroup/2, main/2, nav/2, section/2, search/2, blockquote/2, dd/2, 'div'/2, dl/2, dt/2, figcaption/2, figure/2, hr/1, li/2, menu/2, ol/2, p/2, pre/2, ul/2, a/2, abbr/2, b/2, bdi/2, bdo/2, br/1, cite/2, code/2, data/2, dfn/2, em/2, i/2, kbd/2, mark/2, q/2, rp/2, rt/2, ruby/2, s/2, samp/2, small/2, span/2, strong/2, sub/2, sup/2, time/2, u/2, var/2, wbr/1, area/1, audio/2, img/1, map/2, track/1, video/2, embed/1, iframe/1, object/1, picture/2, portal/1, source/1, svg/2, math/2, canvas/1, noscript/2, script/2, del/2, ins/2, caption/2, col/1, colgroup/2, table/2, tbody/2, td/2, tfoot/2, th/2, thead/2, tr/2, button/2, datalist/2, fieldset/2, form/2, input/1, label/2, legend/2, meter/2, optgroup/2, option/2, output/2, progress/2, select/2, textarea/2, details/2, dialog/2, summary/2, slot/1, template/2]).

-spec html(
    list(lustre@internals@vdom:attribute(QLM)),
    list(lustre@internals@vdom:element(QLM))
) -> lustre@internals@vdom:element(QLM).
html(Attrs, Children) ->
    lustre@element:element(<<"html"/utf8>>, Attrs, Children).

-spec text(binary()) -> lustre@internals@vdom:element(any()).
text(Content) ->
    lustre@element:text(Content).

-spec base(list(lustre@internals@vdom:attribute(QLU))) -> lustre@internals@vdom:element(QLU).
base(Attrs) ->
    lustre@element:element(<<"base"/utf8>>, Attrs, []).

-spec head(
    list(lustre@internals@vdom:attribute(QLY)),
    list(lustre@internals@vdom:element(QLY))
) -> lustre@internals@vdom:element(QLY).
head(Attrs, Children) ->
    lustre@element:element(<<"head"/utf8>>, Attrs, Children).

-spec link(list(lustre@internals@vdom:attribute(QME))) -> lustre@internals@vdom:element(QME).
link(Attrs) ->
    lustre@element:element(<<"link"/utf8>>, Attrs, []).

-spec meta(list(lustre@internals@vdom:attribute(QMI))) -> lustre@internals@vdom:element(QMI).
meta(Attrs) ->
    lustre@element:element(<<"meta"/utf8>>, Attrs, []).

-spec style(list(lustre@internals@vdom:attribute(QMM)), binary()) -> lustre@internals@vdom:element(QMM).
style(Attrs, Css) ->
    lustre@element:element(<<"style"/utf8>>, Attrs, [text(Css)]).

-spec title(list(lustre@internals@vdom:attribute(QMQ)), binary()) -> lustre@internals@vdom:element(QMQ).
title(Attrs, Content) ->
    lustre@element:element(<<"title"/utf8>>, Attrs, [text(Content)]).

-spec body(
    list(lustre@internals@vdom:attribute(QMU)),
    list(lustre@internals@vdom:element(QMU))
) -> lustre@internals@vdom:element(QMU).
body(Attrs, Children) ->
    lustre@element:element(<<"body"/utf8>>, Attrs, Children).

-spec address(
    list(lustre@internals@vdom:attribute(QNA)),
    list(lustre@internals@vdom:element(QNA))
) -> lustre@internals@vdom:element(QNA).
address(Attrs, Children) ->
    lustre@element:element(<<"address"/utf8>>, Attrs, Children).

-spec article(
    list(lustre@internals@vdom:attribute(QNG)),
    list(lustre@internals@vdom:element(QNG))
) -> lustre@internals@vdom:element(QNG).
article(Attrs, Children) ->
    lustre@element:element(<<"article"/utf8>>, Attrs, Children).

-spec aside(
    list(lustre@internals@vdom:attribute(QNM)),
    list(lustre@internals@vdom:element(QNM))
) -> lustre@internals@vdom:element(QNM).
aside(Attrs, Children) ->
    lustre@element:element(<<"aside"/utf8>>, Attrs, Children).

-spec footer(
    list(lustre@internals@vdom:attribute(QNS)),
    list(lustre@internals@vdom:element(QNS))
) -> lustre@internals@vdom:element(QNS).
footer(Attrs, Children) ->
    lustre@element:element(<<"footer"/utf8>>, Attrs, Children).

-spec header(
    list(lustre@internals@vdom:attribute(QNY)),
    list(lustre@internals@vdom:element(QNY))
) -> lustre@internals@vdom:element(QNY).
header(Attrs, Children) ->
    lustre@element:element(<<"header"/utf8>>, Attrs, Children).

-spec h1(
    list(lustre@internals@vdom:attribute(QOE)),
    list(lustre@internals@vdom:element(QOE))
) -> lustre@internals@vdom:element(QOE).
h1(Attrs, Children) ->
    lustre@element:element(<<"h1"/utf8>>, Attrs, Children).

-spec h2(
    list(lustre@internals@vdom:attribute(QOK)),
    list(lustre@internals@vdom:element(QOK))
) -> lustre@internals@vdom:element(QOK).
h2(Attrs, Children) ->
    lustre@element:element(<<"h2"/utf8>>, Attrs, Children).

-spec h3(
    list(lustre@internals@vdom:attribute(QOQ)),
    list(lustre@internals@vdom:element(QOQ))
) -> lustre@internals@vdom:element(QOQ).
h3(Attrs, Children) ->
    lustre@element:element(<<"h3"/utf8>>, Attrs, Children).

-spec h4(
    list(lustre@internals@vdom:attribute(QOW)),
    list(lustre@internals@vdom:element(QOW))
) -> lustre@internals@vdom:element(QOW).
h4(Attrs, Children) ->
    lustre@element:element(<<"h4"/utf8>>, Attrs, Children).

-spec h5(
    list(lustre@internals@vdom:attribute(QPC)),
    list(lustre@internals@vdom:element(QPC))
) -> lustre@internals@vdom:element(QPC).
h5(Attrs, Children) ->
    lustre@element:element(<<"h5"/utf8>>, Attrs, Children).

-spec h6(
    list(lustre@internals@vdom:attribute(QPI)),
    list(lustre@internals@vdom:element(QPI))
) -> lustre@internals@vdom:element(QPI).
h6(Attrs, Children) ->
    lustre@element:element(<<"h6"/utf8>>, Attrs, Children).

-spec hgroup(
    list(lustre@internals@vdom:attribute(QPO)),
    list(lustre@internals@vdom:element(QPO))
) -> lustre@internals@vdom:element(QPO).
hgroup(Attrs, Children) ->
    lustre@element:element(<<"hgroup"/utf8>>, Attrs, Children).

-spec main(
    list(lustre@internals@vdom:attribute(QPU)),
    list(lustre@internals@vdom:element(QPU))
) -> lustre@internals@vdom:element(QPU).
main(Attrs, Children) ->
    lustre@element:element(<<"main"/utf8>>, Attrs, Children).

-spec nav(
    list(lustre@internals@vdom:attribute(QQA)),
    list(lustre@internals@vdom:element(QQA))
) -> lustre@internals@vdom:element(QQA).
nav(Attrs, Children) ->
    lustre@element:element(<<"nav"/utf8>>, Attrs, Children).

-spec section(
    list(lustre@internals@vdom:attribute(QQG)),
    list(lustre@internals@vdom:element(QQG))
) -> lustre@internals@vdom:element(QQG).
section(Attrs, Children) ->
    lustre@element:element(<<"section"/utf8>>, Attrs, Children).

-spec search(
    list(lustre@internals@vdom:attribute(QQM)),
    list(lustre@internals@vdom:element(QQM))
) -> lustre@internals@vdom:element(QQM).
search(Attrs, Children) ->
    lustre@element:element(<<"search"/utf8>>, Attrs, Children).

-spec blockquote(
    list(lustre@internals@vdom:attribute(QQS)),
    list(lustre@internals@vdom:element(QQS))
) -> lustre@internals@vdom:element(QQS).
blockquote(Attrs, Children) ->
    lustre@element:element(<<"blockquote"/utf8>>, Attrs, Children).

-spec dd(
    list(lustre@internals@vdom:attribute(QQY)),
    list(lustre@internals@vdom:element(QQY))
) -> lustre@internals@vdom:element(QQY).
dd(Attrs, Children) ->
    lustre@element:element(<<"dd"/utf8>>, Attrs, Children).

-spec 'div'(
    list(lustre@internals@vdom:attribute(QRE)),
    list(lustre@internals@vdom:element(QRE))
) -> lustre@internals@vdom:element(QRE).
'div'(Attrs, Children) ->
    lustre@element:element(<<"div"/utf8>>, Attrs, Children).

-spec dl(
    list(lustre@internals@vdom:attribute(QRK)),
    list(lustre@internals@vdom:element(QRK))
) -> lustre@internals@vdom:element(QRK).
dl(Attrs, Children) ->
    lustre@element:element(<<"dl"/utf8>>, Attrs, Children).

-spec dt(
    list(lustre@internals@vdom:attribute(QRQ)),
    list(lustre@internals@vdom:element(QRQ))
) -> lustre@internals@vdom:element(QRQ).
dt(Attrs, Children) ->
    lustre@element:element(<<"dt"/utf8>>, Attrs, Children).

-spec figcaption(
    list(lustre@internals@vdom:attribute(QRW)),
    list(lustre@internals@vdom:element(QRW))
) -> lustre@internals@vdom:element(QRW).
figcaption(Attrs, Children) ->
    lustre@element:element(<<"figcaption"/utf8>>, Attrs, Children).

-spec figure(
    list(lustre@internals@vdom:attribute(QSC)),
    list(lustre@internals@vdom:element(QSC))
) -> lustre@internals@vdom:element(QSC).
figure(Attrs, Children) ->
    lustre@element:element(<<"figure"/utf8>>, Attrs, Children).

-spec hr(list(lustre@internals@vdom:attribute(QSI))) -> lustre@internals@vdom:element(QSI).
hr(Attrs) ->
    lustre@element:element(<<"hr"/utf8>>, Attrs, []).

-spec li(
    list(lustre@internals@vdom:attribute(QSM)),
    list(lustre@internals@vdom:element(QSM))
) -> lustre@internals@vdom:element(QSM).
li(Attrs, Children) ->
    lustre@element:element(<<"li"/utf8>>, Attrs, Children).

-spec menu(
    list(lustre@internals@vdom:attribute(QSS)),
    list(lustre@internals@vdom:element(QSS))
) -> lustre@internals@vdom:element(QSS).
menu(Attrs, Children) ->
    lustre@element:element(<<"menu"/utf8>>, Attrs, Children).

-spec ol(
    list(lustre@internals@vdom:attribute(QSY)),
    list(lustre@internals@vdom:element(QSY))
) -> lustre@internals@vdom:element(QSY).
ol(Attrs, Children) ->
    lustre@element:element(<<"ol"/utf8>>, Attrs, Children).

-spec p(
    list(lustre@internals@vdom:attribute(QTE)),
    list(lustre@internals@vdom:element(QTE))
) -> lustre@internals@vdom:element(QTE).
p(Attrs, Children) ->
    lustre@element:element(<<"p"/utf8>>, Attrs, Children).

-spec pre(
    list(lustre@internals@vdom:attribute(QTK)),
    list(lustre@internals@vdom:element(QTK))
) -> lustre@internals@vdom:element(QTK).
pre(Attrs, Children) ->
    lustre@element:element(<<"pre"/utf8>>, Attrs, Children).

-spec ul(
    list(lustre@internals@vdom:attribute(QTQ)),
    list(lustre@internals@vdom:element(QTQ))
) -> lustre@internals@vdom:element(QTQ).
ul(Attrs, Children) ->
    lustre@element:element(<<"ul"/utf8>>, Attrs, Children).

-spec a(
    list(lustre@internals@vdom:attribute(QTW)),
    list(lustre@internals@vdom:element(QTW))
) -> lustre@internals@vdom:element(QTW).
a(Attrs, Children) ->
    lustre@element:element(<<"a"/utf8>>, Attrs, Children).

-spec abbr(
    list(lustre@internals@vdom:attribute(QUC)),
    list(lustre@internals@vdom:element(QUC))
) -> lustre@internals@vdom:element(QUC).
abbr(Attrs, Children) ->
    lustre@element:element(<<"abbr"/utf8>>, Attrs, Children).

-spec b(
    list(lustre@internals@vdom:attribute(QUI)),
    list(lustre@internals@vdom:element(QUI))
) -> lustre@internals@vdom:element(QUI).
b(Attrs, Children) ->
    lustre@element:element(<<"b"/utf8>>, Attrs, Children).

-spec bdi(
    list(lustre@internals@vdom:attribute(QUO)),
    list(lustre@internals@vdom:element(QUO))
) -> lustre@internals@vdom:element(QUO).
bdi(Attrs, Children) ->
    lustre@element:element(<<"bdi"/utf8>>, Attrs, Children).

-spec bdo(
    list(lustre@internals@vdom:attribute(QUU)),
    list(lustre@internals@vdom:element(QUU))
) -> lustre@internals@vdom:element(QUU).
bdo(Attrs, Children) ->
    lustre@element:element(<<"bdo"/utf8>>, Attrs, Children).

-spec br(list(lustre@internals@vdom:attribute(QVA))) -> lustre@internals@vdom:element(QVA).
br(Attrs) ->
    lustre@element:element(<<"br"/utf8>>, Attrs, []).

-spec cite(
    list(lustre@internals@vdom:attribute(QVE)),
    list(lustre@internals@vdom:element(QVE))
) -> lustre@internals@vdom:element(QVE).
cite(Attrs, Children) ->
    lustre@element:element(<<"cite"/utf8>>, Attrs, Children).

-spec code(
    list(lustre@internals@vdom:attribute(QVK)),
    list(lustre@internals@vdom:element(QVK))
) -> lustre@internals@vdom:element(QVK).
code(Attrs, Children) ->
    lustre@element:element(<<"code"/utf8>>, Attrs, Children).

-spec data(
    list(lustre@internals@vdom:attribute(QVQ)),
    list(lustre@internals@vdom:element(QVQ))
) -> lustre@internals@vdom:element(QVQ).
data(Attrs, Children) ->
    lustre@element:element(<<"data"/utf8>>, Attrs, Children).

-spec dfn(
    list(lustre@internals@vdom:attribute(QVW)),
    list(lustre@internals@vdom:element(QVW))
) -> lustre@internals@vdom:element(QVW).
dfn(Attrs, Children) ->
    lustre@element:element(<<"dfn"/utf8>>, Attrs, Children).

-spec em(
    list(lustre@internals@vdom:attribute(QWC)),
    list(lustre@internals@vdom:element(QWC))
) -> lustre@internals@vdom:element(QWC).
em(Attrs, Children) ->
    lustre@element:element(<<"em"/utf8>>, Attrs, Children).

-spec i(
    list(lustre@internals@vdom:attribute(QWI)),
    list(lustre@internals@vdom:element(QWI))
) -> lustre@internals@vdom:element(QWI).
i(Attrs, Children) ->
    lustre@element:element(<<"i"/utf8>>, Attrs, Children).

-spec kbd(
    list(lustre@internals@vdom:attribute(QWO)),
    list(lustre@internals@vdom:element(QWO))
) -> lustre@internals@vdom:element(QWO).
kbd(Attrs, Children) ->
    lustre@element:element(<<"kbd"/utf8>>, Attrs, Children).

-spec mark(
    list(lustre@internals@vdom:attribute(QWU)),
    list(lustre@internals@vdom:element(QWU))
) -> lustre@internals@vdom:element(QWU).
mark(Attrs, Children) ->
    lustre@element:element(<<"mark"/utf8>>, Attrs, Children).

-spec q(
    list(lustre@internals@vdom:attribute(QXA)),
    list(lustre@internals@vdom:element(QXA))
) -> lustre@internals@vdom:element(QXA).
q(Attrs, Children) ->
    lustre@element:element(<<"q"/utf8>>, Attrs, Children).

-spec rp(
    list(lustre@internals@vdom:attribute(QXG)),
    list(lustre@internals@vdom:element(QXG))
) -> lustre@internals@vdom:element(QXG).
rp(Attrs, Children) ->
    lustre@element:element(<<"rp"/utf8>>, Attrs, Children).

-spec rt(
    list(lustre@internals@vdom:attribute(QXM)),
    list(lustre@internals@vdom:element(QXM))
) -> lustre@internals@vdom:element(QXM).
rt(Attrs, Children) ->
    lustre@element:element(<<"rt"/utf8>>, Attrs, Children).

-spec ruby(
    list(lustre@internals@vdom:attribute(QXS)),
    list(lustre@internals@vdom:element(QXS))
) -> lustre@internals@vdom:element(QXS).
ruby(Attrs, Children) ->
    lustre@element:element(<<"ruby"/utf8>>, Attrs, Children).

-spec s(
    list(lustre@internals@vdom:attribute(QXY)),
    list(lustre@internals@vdom:element(QXY))
) -> lustre@internals@vdom:element(QXY).
s(Attrs, Children) ->
    lustre@element:element(<<"s"/utf8>>, Attrs, Children).

-spec samp(
    list(lustre@internals@vdom:attribute(QYE)),
    list(lustre@internals@vdom:element(QYE))
) -> lustre@internals@vdom:element(QYE).
samp(Attrs, Children) ->
    lustre@element:element(<<"samp"/utf8>>, Attrs, Children).

-spec small(
    list(lustre@internals@vdom:attribute(QYK)),
    list(lustre@internals@vdom:element(QYK))
) -> lustre@internals@vdom:element(QYK).
small(Attrs, Children) ->
    lustre@element:element(<<"small"/utf8>>, Attrs, Children).

-spec span(
    list(lustre@internals@vdom:attribute(QYQ)),
    list(lustre@internals@vdom:element(QYQ))
) -> lustre@internals@vdom:element(QYQ).
span(Attrs, Children) ->
    lustre@element:element(<<"span"/utf8>>, Attrs, Children).

-spec strong(
    list(lustre@internals@vdom:attribute(QYW)),
    list(lustre@internals@vdom:element(QYW))
) -> lustre@internals@vdom:element(QYW).
strong(Attrs, Children) ->
    lustre@element:element(<<"strong"/utf8>>, Attrs, Children).

-spec sub(
    list(lustre@internals@vdom:attribute(QZC)),
    list(lustre@internals@vdom:element(QZC))
) -> lustre@internals@vdom:element(QZC).
sub(Attrs, Children) ->
    lustre@element:element(<<"sub"/utf8>>, Attrs, Children).

-spec sup(
    list(lustre@internals@vdom:attribute(QZI)),
    list(lustre@internals@vdom:element(QZI))
) -> lustre@internals@vdom:element(QZI).
sup(Attrs, Children) ->
    lustre@element:element(<<"sup"/utf8>>, Attrs, Children).

-spec time(
    list(lustre@internals@vdom:attribute(QZO)),
    list(lustre@internals@vdom:element(QZO))
) -> lustre@internals@vdom:element(QZO).
time(Attrs, Children) ->
    lustre@element:element(<<"time"/utf8>>, Attrs, Children).

-spec u(
    list(lustre@internals@vdom:attribute(QZU)),
    list(lustre@internals@vdom:element(QZU))
) -> lustre@internals@vdom:element(QZU).
u(Attrs, Children) ->
    lustre@element:element(<<"u"/utf8>>, Attrs, Children).

-spec var(
    list(lustre@internals@vdom:attribute(RAA)),
    list(lustre@internals@vdom:element(RAA))
) -> lustre@internals@vdom:element(RAA).
var(Attrs, Children) ->
    lustre@element:element(<<"var"/utf8>>, Attrs, Children).

-spec wbr(list(lustre@internals@vdom:attribute(RAG))) -> lustre@internals@vdom:element(RAG).
wbr(Attrs) ->
    lustre@element:element(<<"wbr"/utf8>>, Attrs, []).

-spec area(list(lustre@internals@vdom:attribute(RAK))) -> lustre@internals@vdom:element(RAK).
area(Attrs) ->
    lustre@element:element(<<"area"/utf8>>, Attrs, []).

-spec audio(
    list(lustre@internals@vdom:attribute(RAO)),
    list(lustre@internals@vdom:element(RAO))
) -> lustre@internals@vdom:element(RAO).
audio(Attrs, Children) ->
    lustre@element:element(<<"audio"/utf8>>, Attrs, Children).

-spec img(list(lustre@internals@vdom:attribute(RAU))) -> lustre@internals@vdom:element(RAU).
img(Attrs) ->
    lustre@element:element(<<"img"/utf8>>, Attrs, []).

-spec map(
    list(lustre@internals@vdom:attribute(RAY)),
    list(lustre@internals@vdom:element(RAY))
) -> lustre@internals@vdom:element(RAY).
map(Attrs, Children) ->
    lustre@element:element(<<"map"/utf8>>, Attrs, Children).

-spec track(list(lustre@internals@vdom:attribute(RBE))) -> lustre@internals@vdom:element(RBE).
track(Attrs) ->
    lustre@element:element(<<"track"/utf8>>, Attrs, []).

-spec video(
    list(lustre@internals@vdom:attribute(RBI)),
    list(lustre@internals@vdom:element(RBI))
) -> lustre@internals@vdom:element(RBI).
video(Attrs, Children) ->
    lustre@element:element(<<"video"/utf8>>, Attrs, Children).

-spec embed(list(lustre@internals@vdom:attribute(RBO))) -> lustre@internals@vdom:element(RBO).
embed(Attrs) ->
    lustre@element:element(<<"embed"/utf8>>, Attrs, []).

-spec iframe(list(lustre@internals@vdom:attribute(RBS))) -> lustre@internals@vdom:element(RBS).
iframe(Attrs) ->
    lustre@element:element(<<"iframe"/utf8>>, Attrs, []).

-spec object(list(lustre@internals@vdom:attribute(RBW))) -> lustre@internals@vdom:element(RBW).
object(Attrs) ->
    lustre@element:element(<<"object"/utf8>>, Attrs, []).

-spec picture(
    list(lustre@internals@vdom:attribute(RCA)),
    list(lustre@internals@vdom:element(RCA))
) -> lustre@internals@vdom:element(RCA).
picture(Attrs, Children) ->
    lustre@element:element(<<"picture"/utf8>>, Attrs, Children).

-spec portal(list(lustre@internals@vdom:attribute(RCG))) -> lustre@internals@vdom:element(RCG).
portal(Attrs) ->
    lustre@element:element(<<"portal"/utf8>>, Attrs, []).

-spec source(list(lustre@internals@vdom:attribute(RCK))) -> lustre@internals@vdom:element(RCK).
source(Attrs) ->
    lustre@element:element(<<"source"/utf8>>, Attrs, []).

-spec svg(
    list(lustre@internals@vdom:attribute(RCO)),
    list(lustre@internals@vdom:element(RCO))
) -> lustre@internals@vdom:element(RCO).
svg(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"svg"/utf8>>,
        Attrs,
        Children
    ).

-spec math(
    list(lustre@internals@vdom:attribute(RCU)),
    list(lustre@internals@vdom:element(RCU))
) -> lustre@internals@vdom:element(RCU).
math(Attrs, Children) ->
    lustre@element:element(<<"math"/utf8>>, Attrs, Children).

-spec canvas(list(lustre@internals@vdom:attribute(RDA))) -> lustre@internals@vdom:element(RDA).
canvas(Attrs) ->
    lustre@element:element(<<"canvas"/utf8>>, Attrs, []).

-spec noscript(
    list(lustre@internals@vdom:attribute(RDE)),
    list(lustre@internals@vdom:element(RDE))
) -> lustre@internals@vdom:element(RDE).
noscript(Attrs, Children) ->
    lustre@element:element(<<"noscript"/utf8>>, Attrs, Children).

-spec script(list(lustre@internals@vdom:attribute(RDK)), binary()) -> lustre@internals@vdom:element(RDK).
script(Attrs, Js) ->
    lustre@element:element(<<"script"/utf8>>, Attrs, [text(Js)]).

-spec del(
    list(lustre@internals@vdom:attribute(RDO)),
    list(lustre@internals@vdom:element(RDO))
) -> lustre@internals@vdom:element(RDO).
del(Attrs, Children) ->
    lustre@element:element(<<"del"/utf8>>, Attrs, Children).

-spec ins(
    list(lustre@internals@vdom:attribute(RDU)),
    list(lustre@internals@vdom:element(RDU))
) -> lustre@internals@vdom:element(RDU).
ins(Attrs, Children) ->
    lustre@element:element(<<"ins"/utf8>>, Attrs, Children).

-spec caption(
    list(lustre@internals@vdom:attribute(REA)),
    list(lustre@internals@vdom:element(REA))
) -> lustre@internals@vdom:element(REA).
caption(Attrs, Children) ->
    lustre@element:element(<<"caption"/utf8>>, Attrs, Children).

-spec col(list(lustre@internals@vdom:attribute(REG))) -> lustre@internals@vdom:element(REG).
col(Attrs) ->
    lustre@element:element(<<"col"/utf8>>, Attrs, []).

-spec colgroup(
    list(lustre@internals@vdom:attribute(REK)),
    list(lustre@internals@vdom:element(REK))
) -> lustre@internals@vdom:element(REK).
colgroup(Attrs, Children) ->
    lustre@element:element(<<"colgroup"/utf8>>, Attrs, Children).

-spec table(
    list(lustre@internals@vdom:attribute(REQ)),
    list(lustre@internals@vdom:element(REQ))
) -> lustre@internals@vdom:element(REQ).
table(Attrs, Children) ->
    lustre@element:element(<<"table"/utf8>>, Attrs, Children).

-spec tbody(
    list(lustre@internals@vdom:attribute(REW)),
    list(lustre@internals@vdom:element(REW))
) -> lustre@internals@vdom:element(REW).
tbody(Attrs, Children) ->
    lustre@element:element(<<"tbody"/utf8>>, Attrs, Children).

-spec td(
    list(lustre@internals@vdom:attribute(RFC)),
    list(lustre@internals@vdom:element(RFC))
) -> lustre@internals@vdom:element(RFC).
td(Attrs, Children) ->
    lustre@element:element(<<"td"/utf8>>, Attrs, Children).

-spec tfoot(
    list(lustre@internals@vdom:attribute(RFI)),
    list(lustre@internals@vdom:element(RFI))
) -> lustre@internals@vdom:element(RFI).
tfoot(Attrs, Children) ->
    lustre@element:element(<<"tfoot"/utf8>>, Attrs, Children).

-spec th(
    list(lustre@internals@vdom:attribute(RFO)),
    list(lustre@internals@vdom:element(RFO))
) -> lustre@internals@vdom:element(RFO).
th(Attrs, Children) ->
    lustre@element:element(<<"th"/utf8>>, Attrs, Children).

-spec thead(
    list(lustre@internals@vdom:attribute(RFU)),
    list(lustre@internals@vdom:element(RFU))
) -> lustre@internals@vdom:element(RFU).
thead(Attrs, Children) ->
    lustre@element:element(<<"thead"/utf8>>, Attrs, Children).

-spec tr(
    list(lustre@internals@vdom:attribute(RGA)),
    list(lustre@internals@vdom:element(RGA))
) -> lustre@internals@vdom:element(RGA).
tr(Attrs, Children) ->
    lustre@element:element(<<"tr"/utf8>>, Attrs, Children).

-spec button(
    list(lustre@internals@vdom:attribute(RGG)),
    list(lustre@internals@vdom:element(RGG))
) -> lustre@internals@vdom:element(RGG).
button(Attrs, Children) ->
    lustre@element:element(<<"button"/utf8>>, Attrs, Children).

-spec datalist(
    list(lustre@internals@vdom:attribute(RGM)),
    list(lustre@internals@vdom:element(RGM))
) -> lustre@internals@vdom:element(RGM).
datalist(Attrs, Children) ->
    lustre@element:element(<<"datalist"/utf8>>, Attrs, Children).

-spec fieldset(
    list(lustre@internals@vdom:attribute(RGS)),
    list(lustre@internals@vdom:element(RGS))
) -> lustre@internals@vdom:element(RGS).
fieldset(Attrs, Children) ->
    lustre@element:element(<<"fieldset"/utf8>>, Attrs, Children).

-spec form(
    list(lustre@internals@vdom:attribute(RGY)),
    list(lustre@internals@vdom:element(RGY))
) -> lustre@internals@vdom:element(RGY).
form(Attrs, Children) ->
    lustre@element:element(<<"form"/utf8>>, Attrs, Children).

-spec input(list(lustre@internals@vdom:attribute(RHE))) -> lustre@internals@vdom:element(RHE).
input(Attrs) ->
    lustre@element:element(<<"input"/utf8>>, Attrs, []).

-spec label(
    list(lustre@internals@vdom:attribute(RHI)),
    list(lustre@internals@vdom:element(RHI))
) -> lustre@internals@vdom:element(RHI).
label(Attrs, Children) ->
    lustre@element:element(<<"label"/utf8>>, Attrs, Children).

-spec legend(
    list(lustre@internals@vdom:attribute(RHO)),
    list(lustre@internals@vdom:element(RHO))
) -> lustre@internals@vdom:element(RHO).
legend(Attrs, Children) ->
    lustre@element:element(<<"legend"/utf8>>, Attrs, Children).

-spec meter(
    list(lustre@internals@vdom:attribute(RHU)),
    list(lustre@internals@vdom:element(RHU))
) -> lustre@internals@vdom:element(RHU).
meter(Attrs, Children) ->
    lustre@element:element(<<"meter"/utf8>>, Attrs, Children).

-spec optgroup(
    list(lustre@internals@vdom:attribute(RIA)),
    list(lustre@internals@vdom:element(RIA))
) -> lustre@internals@vdom:element(RIA).
optgroup(Attrs, Children) ->
    lustre@element:element(<<"optgroup"/utf8>>, Attrs, Children).

-spec option(list(lustre@internals@vdom:attribute(RIG)), binary()) -> lustre@internals@vdom:element(RIG).
option(Attrs, Label) ->
    lustre@element:element(
        <<"option"/utf8>>,
        Attrs,
        [lustre@element:text(Label)]
    ).

-spec output(
    list(lustre@internals@vdom:attribute(RIK)),
    list(lustre@internals@vdom:element(RIK))
) -> lustre@internals@vdom:element(RIK).
output(Attrs, Children) ->
    lustre@element:element(<<"output"/utf8>>, Attrs, Children).

-spec progress(
    list(lustre@internals@vdom:attribute(RIQ)),
    list(lustre@internals@vdom:element(RIQ))
) -> lustre@internals@vdom:element(RIQ).
progress(Attrs, Children) ->
    lustre@element:element(<<"progress"/utf8>>, Attrs, Children).

-spec select(
    list(lustre@internals@vdom:attribute(RIW)),
    list(lustre@internals@vdom:element(RIW))
) -> lustre@internals@vdom:element(RIW).
select(Attrs, Children) ->
    lustre@element:element(<<"select"/utf8>>, Attrs, Children).

-spec textarea(list(lustre@internals@vdom:attribute(RJC)), binary()) -> lustre@internals@vdom:element(RJC).
textarea(Attrs, Content) ->
    lustre@element:element(
        <<"textarea"/utf8>>,
        Attrs,
        [lustre@element:text(Content)]
    ).

-spec details(
    list(lustre@internals@vdom:attribute(RJG)),
    list(lustre@internals@vdom:element(RJG))
) -> lustre@internals@vdom:element(RJG).
details(Attrs, Children) ->
    lustre@element:element(<<"details"/utf8>>, Attrs, Children).

-spec dialog(
    list(lustre@internals@vdom:attribute(RJM)),
    list(lustre@internals@vdom:element(RJM))
) -> lustre@internals@vdom:element(RJM).
dialog(Attrs, Children) ->
    lustre@element:element(<<"dialog"/utf8>>, Attrs, Children).

-spec summary(
    list(lustre@internals@vdom:attribute(RJS)),
    list(lustre@internals@vdom:element(RJS))
) -> lustre@internals@vdom:element(RJS).
summary(Attrs, Children) ->
    lustre@element:element(<<"summary"/utf8>>, Attrs, Children).

-spec slot(list(lustre@internals@vdom:attribute(RJY))) -> lustre@internals@vdom:element(RJY).
slot(Attrs) ->
    lustre@element:element(<<"slot"/utf8>>, Attrs, []).

-spec template(
    list(lustre@internals@vdom:attribute(RKC)),
    list(lustre@internals@vdom:element(RKC))
) -> lustre@internals@vdom:element(RKC).
template(Attrs, Children) ->
    lustre@element:element(<<"template"/utf8>>, Attrs, Children).
