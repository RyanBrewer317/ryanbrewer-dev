-module(lustre@element@html).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).
-define(FILEPATH, "src/lustre/element/html.gleam").
-export([html/2, text/1, base/1, head/2, link/1, meta/1, style/2, title/2, body/2, address/2, article/2, aside/2, footer/2, header/2, h1/2, h2/2, h3/2, h4/2, h5/2, h6/2, hgroup/2, main/2, nav/2, section/2, search/2, blockquote/2, dd/2, 'div'/2, dl/2, dt/2, figcaption/2, figure/2, hr/1, li/2, menu/2, ol/2, p/2, pre/2, ul/2, a/2, abbr/2, b/2, bdi/2, bdo/2, br/1, cite/2, code/2, data/2, dfn/2, em/2, i/2, kbd/2, mark/2, q/2, rp/2, rt/2, ruby/2, s/2, samp/2, small/2, span/2, strong/2, sub/2, sup/2, time/2, u/2, var/2, wbr/1, area/1, audio/2, img/1, map/2, track/1, video/2, embed/1, iframe/1, object/1, picture/2, portal/1, source/1, svg/2, math/2, canvas/1, noscript/2, script/2, del/2, ins/2, caption/2, col/1, colgroup/2, table/2, tbody/2, td/2, tfoot/2, th/2, thead/2, tr/2, button/2, datalist/2, fieldset/2, form/2, input/1, label/2, legend/2, meter/2, optgroup/2, option/2, output/2, progress/2, select/2, textarea/2, details/2, dialog/2, summary/2, slot/2, template/2]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-file("src/lustre/element/html.gleam", 11).
?DOC("\n").
-spec html(
    list(lustre@vdom@vattr:attribute(OVW)),
    list(lustre@vdom@vnode:element(OVW))
) -> lustre@vdom@vnode:element(OVW).
html(Attrs, Children) ->
    lustre@element:element(<<"html"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 18).
-spec text(binary()) -> lustre@vdom@vnode:element(any()).
text(Content) ->
    lustre@element:text(Content).

-file("src/lustre/element/html.gleam", 25).
?DOC("\n").
-spec base(list(lustre@vdom@vattr:attribute(OWE))) -> lustre@vdom@vnode:element(OWE).
base(Attrs) ->
    lustre@element:element(<<"base"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 30).
?DOC("\n").
-spec head(
    list(lustre@vdom@vattr:attribute(OWI)),
    list(lustre@vdom@vnode:element(OWI))
) -> lustre@vdom@vnode:element(OWI).
head(Attrs, Children) ->
    lustre@element:element(<<"head"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 38).
?DOC("\n").
-spec link(list(lustre@vdom@vattr:attribute(OWO))) -> lustre@vdom@vnode:element(OWO).
link(Attrs) ->
    lustre@element:element(<<"link"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 43).
?DOC("\n").
-spec meta(list(lustre@vdom@vattr:attribute(OWS))) -> lustre@vdom@vnode:element(OWS).
meta(Attrs) ->
    lustre@element:element(<<"meta"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 48).
?DOC("\n").
-spec style(list(lustre@vdom@vattr:attribute(OWW)), binary()) -> lustre@vdom@vnode:element(OWW).
style(Attrs, Css) ->
    lustre@element:unsafe_raw_html(<<""/utf8>>, <<"style"/utf8>>, Attrs, Css).

-file("src/lustre/element/html.gleam", 53).
?DOC("\n").
-spec title(list(lustre@vdom@vattr:attribute(OXA)), binary()) -> lustre@vdom@vnode:element(OXA).
title(Attrs, Content) ->
    lustre@element:element(<<"title"/utf8>>, Attrs, [text(Content)]).

-file("src/lustre/element/html.gleam", 60).
?DOC("\n").
-spec body(
    list(lustre@vdom@vattr:attribute(OXE)),
    list(lustre@vdom@vnode:element(OXE))
) -> lustre@vdom@vnode:element(OXE).
body(Attrs, Children) ->
    lustre@element:element(<<"body"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 70).
?DOC("\n").
-spec address(
    list(lustre@vdom@vattr:attribute(OXK)),
    list(lustre@vdom@vnode:element(OXK))
) -> lustre@vdom@vnode:element(OXK).
address(Attrs, Children) ->
    lustre@element:element(<<"address"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 78).
?DOC("\n").
-spec article(
    list(lustre@vdom@vattr:attribute(OXQ)),
    list(lustre@vdom@vnode:element(OXQ))
) -> lustre@vdom@vnode:element(OXQ).
article(Attrs, Children) ->
    lustre@element:element(<<"article"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 86).
?DOC("\n").
-spec aside(
    list(lustre@vdom@vattr:attribute(OXW)),
    list(lustre@vdom@vnode:element(OXW))
) -> lustre@vdom@vnode:element(OXW).
aside(Attrs, Children) ->
    lustre@element:element(<<"aside"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 94).
?DOC("\n").
-spec footer(
    list(lustre@vdom@vattr:attribute(OYC)),
    list(lustre@vdom@vnode:element(OYC))
) -> lustre@vdom@vnode:element(OYC).
footer(Attrs, Children) ->
    lustre@element:element(<<"footer"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 102).
?DOC("\n").
-spec header(
    list(lustre@vdom@vattr:attribute(OYI)),
    list(lustre@vdom@vnode:element(OYI))
) -> lustre@vdom@vnode:element(OYI).
header(Attrs, Children) ->
    lustre@element:element(<<"header"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 110).
?DOC("\n").
-spec h1(
    list(lustre@vdom@vattr:attribute(OYO)),
    list(lustre@vdom@vnode:element(OYO))
) -> lustre@vdom@vnode:element(OYO).
h1(Attrs, Children) ->
    lustre@element:element(<<"h1"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 118).
?DOC("\n").
-spec h2(
    list(lustre@vdom@vattr:attribute(OYU)),
    list(lustre@vdom@vnode:element(OYU))
) -> lustre@vdom@vnode:element(OYU).
h2(Attrs, Children) ->
    lustre@element:element(<<"h2"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 126).
?DOC("\n").
-spec h3(
    list(lustre@vdom@vattr:attribute(OZA)),
    list(lustre@vdom@vnode:element(OZA))
) -> lustre@vdom@vnode:element(OZA).
h3(Attrs, Children) ->
    lustre@element:element(<<"h3"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 134).
?DOC("\n").
-spec h4(
    list(lustre@vdom@vattr:attribute(OZG)),
    list(lustre@vdom@vnode:element(OZG))
) -> lustre@vdom@vnode:element(OZG).
h4(Attrs, Children) ->
    lustre@element:element(<<"h4"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 142).
?DOC("\n").
-spec h5(
    list(lustre@vdom@vattr:attribute(OZM)),
    list(lustre@vdom@vnode:element(OZM))
) -> lustre@vdom@vnode:element(OZM).
h5(Attrs, Children) ->
    lustre@element:element(<<"h5"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 150).
?DOC("\n").
-spec h6(
    list(lustre@vdom@vattr:attribute(OZS)),
    list(lustre@vdom@vnode:element(OZS))
) -> lustre@vdom@vnode:element(OZS).
h6(Attrs, Children) ->
    lustre@element:element(<<"h6"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 158).
?DOC("\n").
-spec hgroup(
    list(lustre@vdom@vattr:attribute(OZY)),
    list(lustre@vdom@vnode:element(OZY))
) -> lustre@vdom@vnode:element(OZY).
hgroup(Attrs, Children) ->
    lustre@element:element(<<"hgroup"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 166).
?DOC("\n").
-spec main(
    list(lustre@vdom@vattr:attribute(PAE)),
    list(lustre@vdom@vnode:element(PAE))
) -> lustre@vdom@vnode:element(PAE).
main(Attrs, Children) ->
    lustre@element:element(<<"main"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 174).
?DOC("\n").
-spec nav(
    list(lustre@vdom@vattr:attribute(PAK)),
    list(lustre@vdom@vnode:element(PAK))
) -> lustre@vdom@vnode:element(PAK).
nav(Attrs, Children) ->
    lustre@element:element(<<"nav"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 182).
?DOC("\n").
-spec section(
    list(lustre@vdom@vattr:attribute(PAQ)),
    list(lustre@vdom@vnode:element(PAQ))
) -> lustre@vdom@vnode:element(PAQ).
section(Attrs, Children) ->
    lustre@element:element(<<"section"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 190).
?DOC("\n").
-spec search(
    list(lustre@vdom@vattr:attribute(PAW)),
    list(lustre@vdom@vnode:element(PAW))
) -> lustre@vdom@vnode:element(PAW).
search(Attrs, Children) ->
    lustre@element:element(<<"search"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 200).
?DOC("\n").
-spec blockquote(
    list(lustre@vdom@vattr:attribute(PBC)),
    list(lustre@vdom@vnode:element(PBC))
) -> lustre@vdom@vnode:element(PBC).
blockquote(Attrs, Children) ->
    lustre@element:element(<<"blockquote"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 208).
?DOC("\n").
-spec dd(
    list(lustre@vdom@vattr:attribute(PBI)),
    list(lustre@vdom@vnode:element(PBI))
) -> lustre@vdom@vnode:element(PBI).
dd(Attrs, Children) ->
    lustre@element:element(<<"dd"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 216).
?DOC("\n").
-spec 'div'(
    list(lustre@vdom@vattr:attribute(PBO)),
    list(lustre@vdom@vnode:element(PBO))
) -> lustre@vdom@vnode:element(PBO).
'div'(Attrs, Children) ->
    lustre@element:element(<<"div"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 224).
?DOC("\n").
-spec dl(
    list(lustre@vdom@vattr:attribute(PBU)),
    list(lustre@vdom@vnode:element(PBU))
) -> lustre@vdom@vnode:element(PBU).
dl(Attrs, Children) ->
    lustre@element:element(<<"dl"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 232).
?DOC("\n").
-spec dt(
    list(lustre@vdom@vattr:attribute(PCA)),
    list(lustre@vdom@vnode:element(PCA))
) -> lustre@vdom@vnode:element(PCA).
dt(Attrs, Children) ->
    lustre@element:element(<<"dt"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 240).
?DOC("\n").
-spec figcaption(
    list(lustre@vdom@vattr:attribute(PCG)),
    list(lustre@vdom@vnode:element(PCG))
) -> lustre@vdom@vnode:element(PCG).
figcaption(Attrs, Children) ->
    lustre@element:element(<<"figcaption"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 248).
?DOC("\n").
-spec figure(
    list(lustre@vdom@vattr:attribute(PCM)),
    list(lustre@vdom@vnode:element(PCM))
) -> lustre@vdom@vnode:element(PCM).
figure(Attrs, Children) ->
    lustre@element:element(<<"figure"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 256).
?DOC("\n").
-spec hr(list(lustre@vdom@vattr:attribute(PCS))) -> lustre@vdom@vnode:element(PCS).
hr(Attrs) ->
    lustre@element:element(<<"hr"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 261).
?DOC("\n").
-spec li(
    list(lustre@vdom@vattr:attribute(PCW)),
    list(lustre@vdom@vnode:element(PCW))
) -> lustre@vdom@vnode:element(PCW).
li(Attrs, Children) ->
    lustre@element:element(<<"li"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 269).
?DOC("\n").
-spec menu(
    list(lustre@vdom@vattr:attribute(PDC)),
    list(lustre@vdom@vnode:element(PDC))
) -> lustre@vdom@vnode:element(PDC).
menu(Attrs, Children) ->
    lustre@element:element(<<"menu"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 277).
?DOC("\n").
-spec ol(
    list(lustre@vdom@vattr:attribute(PDI)),
    list(lustre@vdom@vnode:element(PDI))
) -> lustre@vdom@vnode:element(PDI).
ol(Attrs, Children) ->
    lustre@element:element(<<"ol"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 285).
?DOC("\n").
-spec p(
    list(lustre@vdom@vattr:attribute(PDO)),
    list(lustre@vdom@vnode:element(PDO))
) -> lustre@vdom@vnode:element(PDO).
p(Attrs, Children) ->
    lustre@element:element(<<"p"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 293).
?DOC("\n").
-spec pre(
    list(lustre@vdom@vattr:attribute(PDU)),
    list(lustre@vdom@vnode:element(PDU))
) -> lustre@vdom@vnode:element(PDU).
pre(Attrs, Children) ->
    lustre@element:element(<<"pre"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 301).
?DOC("\n").
-spec ul(
    list(lustre@vdom@vattr:attribute(PEA)),
    list(lustre@vdom@vnode:element(PEA))
) -> lustre@vdom@vnode:element(PEA).
ul(Attrs, Children) ->
    lustre@element:element(<<"ul"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 311).
?DOC("\n").
-spec a(
    list(lustre@vdom@vattr:attribute(PEG)),
    list(lustre@vdom@vnode:element(PEG))
) -> lustre@vdom@vnode:element(PEG).
a(Attrs, Children) ->
    lustre@element:element(<<"a"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 319).
?DOC("\n").
-spec abbr(
    list(lustre@vdom@vattr:attribute(PEM)),
    list(lustre@vdom@vnode:element(PEM))
) -> lustre@vdom@vnode:element(PEM).
abbr(Attrs, Children) ->
    lustre@element:element(<<"abbr"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 327).
?DOC("\n").
-spec b(
    list(lustre@vdom@vattr:attribute(PES)),
    list(lustre@vdom@vnode:element(PES))
) -> lustre@vdom@vnode:element(PES).
b(Attrs, Children) ->
    lustre@element:element(<<"b"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 335).
?DOC("\n").
-spec bdi(
    list(lustre@vdom@vattr:attribute(PEY)),
    list(lustre@vdom@vnode:element(PEY))
) -> lustre@vdom@vnode:element(PEY).
bdi(Attrs, Children) ->
    lustre@element:element(<<"bdi"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 343).
?DOC("\n").
-spec bdo(
    list(lustre@vdom@vattr:attribute(PFE)),
    list(lustre@vdom@vnode:element(PFE))
) -> lustre@vdom@vnode:element(PFE).
bdo(Attrs, Children) ->
    lustre@element:element(<<"bdo"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 351).
?DOC("\n").
-spec br(list(lustre@vdom@vattr:attribute(PFK))) -> lustre@vdom@vnode:element(PFK).
br(Attrs) ->
    lustre@element:element(<<"br"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 356).
?DOC("\n").
-spec cite(
    list(lustre@vdom@vattr:attribute(PFO)),
    list(lustre@vdom@vnode:element(PFO))
) -> lustre@vdom@vnode:element(PFO).
cite(Attrs, Children) ->
    lustre@element:element(<<"cite"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 364).
?DOC("\n").
-spec code(
    list(lustre@vdom@vattr:attribute(PFU)),
    list(lustre@vdom@vnode:element(PFU))
) -> lustre@vdom@vnode:element(PFU).
code(Attrs, Children) ->
    lustre@element:element(<<"code"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 372).
?DOC("\n").
-spec data(
    list(lustre@vdom@vattr:attribute(PGA)),
    list(lustre@vdom@vnode:element(PGA))
) -> lustre@vdom@vnode:element(PGA).
data(Attrs, Children) ->
    lustre@element:element(<<"data"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 380).
?DOC("\n").
-spec dfn(
    list(lustre@vdom@vattr:attribute(PGG)),
    list(lustre@vdom@vnode:element(PGG))
) -> lustre@vdom@vnode:element(PGG).
dfn(Attrs, Children) ->
    lustre@element:element(<<"dfn"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 388).
?DOC("\n").
-spec em(
    list(lustre@vdom@vattr:attribute(PGM)),
    list(lustre@vdom@vnode:element(PGM))
) -> lustre@vdom@vnode:element(PGM).
em(Attrs, Children) ->
    lustre@element:element(<<"em"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 396).
?DOC("\n").
-spec i(
    list(lustre@vdom@vattr:attribute(PGS)),
    list(lustre@vdom@vnode:element(PGS))
) -> lustre@vdom@vnode:element(PGS).
i(Attrs, Children) ->
    lustre@element:element(<<"i"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 404).
?DOC("\n").
-spec kbd(
    list(lustre@vdom@vattr:attribute(PGY)),
    list(lustre@vdom@vnode:element(PGY))
) -> lustre@vdom@vnode:element(PGY).
kbd(Attrs, Children) ->
    lustre@element:element(<<"kbd"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 412).
?DOC("\n").
-spec mark(
    list(lustre@vdom@vattr:attribute(PHE)),
    list(lustre@vdom@vnode:element(PHE))
) -> lustre@vdom@vnode:element(PHE).
mark(Attrs, Children) ->
    lustre@element:element(<<"mark"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 420).
?DOC("\n").
-spec q(
    list(lustre@vdom@vattr:attribute(PHK)),
    list(lustre@vdom@vnode:element(PHK))
) -> lustre@vdom@vnode:element(PHK).
q(Attrs, Children) ->
    lustre@element:element(<<"q"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 428).
?DOC("\n").
-spec rp(
    list(lustre@vdom@vattr:attribute(PHQ)),
    list(lustre@vdom@vnode:element(PHQ))
) -> lustre@vdom@vnode:element(PHQ).
rp(Attrs, Children) ->
    lustre@element:element(<<"rp"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 436).
?DOC("\n").
-spec rt(
    list(lustre@vdom@vattr:attribute(PHW)),
    list(lustre@vdom@vnode:element(PHW))
) -> lustre@vdom@vnode:element(PHW).
rt(Attrs, Children) ->
    lustre@element:element(<<"rt"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 444).
?DOC("\n").
-spec ruby(
    list(lustre@vdom@vattr:attribute(PIC)),
    list(lustre@vdom@vnode:element(PIC))
) -> lustre@vdom@vnode:element(PIC).
ruby(Attrs, Children) ->
    lustre@element:element(<<"ruby"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 452).
?DOC("\n").
-spec s(
    list(lustre@vdom@vattr:attribute(PII)),
    list(lustre@vdom@vnode:element(PII))
) -> lustre@vdom@vnode:element(PII).
s(Attrs, Children) ->
    lustre@element:element(<<"s"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 460).
?DOC("\n").
-spec samp(
    list(lustre@vdom@vattr:attribute(PIO)),
    list(lustre@vdom@vnode:element(PIO))
) -> lustre@vdom@vnode:element(PIO).
samp(Attrs, Children) ->
    lustre@element:element(<<"samp"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 468).
?DOC("\n").
-spec small(
    list(lustre@vdom@vattr:attribute(PIU)),
    list(lustre@vdom@vnode:element(PIU))
) -> lustre@vdom@vnode:element(PIU).
small(Attrs, Children) ->
    lustre@element:element(<<"small"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 476).
?DOC("\n").
-spec span(
    list(lustre@vdom@vattr:attribute(PJA)),
    list(lustre@vdom@vnode:element(PJA))
) -> lustre@vdom@vnode:element(PJA).
span(Attrs, Children) ->
    lustre@element:element(<<"span"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 484).
?DOC("\n").
-spec strong(
    list(lustre@vdom@vattr:attribute(PJG)),
    list(lustre@vdom@vnode:element(PJG))
) -> lustre@vdom@vnode:element(PJG).
strong(Attrs, Children) ->
    lustre@element:element(<<"strong"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 492).
?DOC("\n").
-spec sub(
    list(lustre@vdom@vattr:attribute(PJM)),
    list(lustre@vdom@vnode:element(PJM))
) -> lustre@vdom@vnode:element(PJM).
sub(Attrs, Children) ->
    lustre@element:element(<<"sub"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 500).
?DOC("\n").
-spec sup(
    list(lustre@vdom@vattr:attribute(PJS)),
    list(lustre@vdom@vnode:element(PJS))
) -> lustre@vdom@vnode:element(PJS).
sup(Attrs, Children) ->
    lustre@element:element(<<"sup"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 508).
?DOC("\n").
-spec time(
    list(lustre@vdom@vattr:attribute(PJY)),
    list(lustre@vdom@vnode:element(PJY))
) -> lustre@vdom@vnode:element(PJY).
time(Attrs, Children) ->
    lustre@element:element(<<"time"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 516).
?DOC("\n").
-spec u(
    list(lustre@vdom@vattr:attribute(PKE)),
    list(lustre@vdom@vnode:element(PKE))
) -> lustre@vdom@vnode:element(PKE).
u(Attrs, Children) ->
    lustre@element:element(<<"u"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 524).
?DOC("\n").
-spec var(
    list(lustre@vdom@vattr:attribute(PKK)),
    list(lustre@vdom@vnode:element(PKK))
) -> lustre@vdom@vnode:element(PKK).
var(Attrs, Children) ->
    lustre@element:element(<<"var"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 532).
?DOC("\n").
-spec wbr(list(lustre@vdom@vattr:attribute(PKQ))) -> lustre@vdom@vnode:element(PKQ).
wbr(Attrs) ->
    lustre@element:element(<<"wbr"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 539).
?DOC("\n").
-spec area(list(lustre@vdom@vattr:attribute(PKU))) -> lustre@vdom@vnode:element(PKU).
area(Attrs) ->
    lustre@element:element(<<"area"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 544).
?DOC("\n").
-spec audio(
    list(lustre@vdom@vattr:attribute(PKY)),
    list(lustre@vdom@vnode:element(PKY))
) -> lustre@vdom@vnode:element(PKY).
audio(Attrs, Children) ->
    lustre@element:element(<<"audio"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 552).
?DOC("\n").
-spec img(list(lustre@vdom@vattr:attribute(PLE))) -> lustre@vdom@vnode:element(PLE).
img(Attrs) ->
    lustre@element:element(<<"img"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 558).
?DOC(" Used with <area> elements to define an image map (a clickable link area).\n").
-spec map(
    list(lustre@vdom@vattr:attribute(PLI)),
    list(lustre@vdom@vnode:element(PLI))
) -> lustre@vdom@vnode:element(PLI).
map(Attrs, Children) ->
    lustre@element:element(<<"map"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 566).
?DOC("\n").
-spec track(list(lustre@vdom@vattr:attribute(PLO))) -> lustre@vdom@vnode:element(PLO).
track(Attrs) ->
    lustre@element:element(<<"track"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 571).
?DOC("\n").
-spec video(
    list(lustre@vdom@vattr:attribute(PLS)),
    list(lustre@vdom@vnode:element(PLS))
) -> lustre@vdom@vnode:element(PLS).
video(Attrs, Children) ->
    lustre@element:element(<<"video"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 581).
?DOC("\n").
-spec embed(list(lustre@vdom@vattr:attribute(PLY))) -> lustre@vdom@vnode:element(PLY).
embed(Attrs) ->
    lustre@element:element(<<"embed"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 586).
?DOC("\n").
-spec iframe(list(lustre@vdom@vattr:attribute(PMC))) -> lustre@vdom@vnode:element(PMC).
iframe(Attrs) ->
    lustre@element:element(<<"iframe"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 591).
?DOC("\n").
-spec object(list(lustre@vdom@vattr:attribute(PMG))) -> lustre@vdom@vnode:element(PMG).
object(Attrs) ->
    lustre@element:element(<<"object"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 596).
?DOC("\n").
-spec picture(
    list(lustre@vdom@vattr:attribute(PMK)),
    list(lustre@vdom@vnode:element(PMK))
) -> lustre@vdom@vnode:element(PMK).
picture(Attrs, Children) ->
    lustre@element:element(<<"picture"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 604).
?DOC("\n").
-spec portal(list(lustre@vdom@vattr:attribute(PMQ))) -> lustre@vdom@vnode:element(PMQ).
portal(Attrs) ->
    lustre@element:element(<<"portal"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 609).
?DOC("\n").
-spec source(list(lustre@vdom@vattr:attribute(PMU))) -> lustre@vdom@vnode:element(PMU).
source(Attrs) ->
    lustre@element:element(<<"source"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 616).
?DOC("\n").
-spec svg(
    list(lustre@vdom@vattr:attribute(PMY)),
    list(lustre@vdom@vnode:element(PMY))
) -> lustre@vdom@vnode:element(PMY).
svg(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"svg"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/html.gleam", 624).
?DOC("\n").
-spec math(
    list(lustre@vdom@vattr:attribute(PNE)),
    list(lustre@vdom@vnode:element(PNE))
) -> lustre@vdom@vnode:element(PNE).
math(Attrs, Children) ->
    lustre@element:element(<<"math"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 634).
?DOC("\n").
-spec canvas(list(lustre@vdom@vattr:attribute(PNK))) -> lustre@vdom@vnode:element(PNK).
canvas(Attrs) ->
    lustre@element:element(<<"canvas"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 639).
?DOC("\n").
-spec noscript(
    list(lustre@vdom@vattr:attribute(PNO)),
    list(lustre@vdom@vnode:element(PNO))
) -> lustre@vdom@vnode:element(PNO).
noscript(Attrs, Children) ->
    lustre@element:element(<<"noscript"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 647).
?DOC("\n").
-spec script(list(lustre@vdom@vattr:attribute(PNU)), binary()) -> lustre@vdom@vnode:element(PNU).
script(Attrs, Js) ->
    lustre@element:unsafe_raw_html(<<""/utf8>>, <<"script"/utf8>>, Attrs, Js).

-file("src/lustre/element/html.gleam", 654).
?DOC("\n").
-spec del(
    list(lustre@vdom@vattr:attribute(PNY)),
    list(lustre@vdom@vnode:element(PNY))
) -> lustre@vdom@vnode:element(PNY).
del(Attrs, Children) ->
    lustre@element:element(<<"del"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 662).
?DOC("\n").
-spec ins(
    list(lustre@vdom@vattr:attribute(POE)),
    list(lustre@vdom@vnode:element(POE))
) -> lustre@vdom@vnode:element(POE).
ins(Attrs, Children) ->
    lustre@element:element(<<"ins"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 672).
?DOC("\n").
-spec caption(
    list(lustre@vdom@vattr:attribute(POK)),
    list(lustre@vdom@vnode:element(POK))
) -> lustre@vdom@vnode:element(POK).
caption(Attrs, Children) ->
    lustre@element:element(<<"caption"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 680).
?DOC("\n").
-spec col(list(lustre@vdom@vattr:attribute(POQ))) -> lustre@vdom@vnode:element(POQ).
col(Attrs) ->
    lustre@element:element(<<"col"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 685).
?DOC("\n").
-spec colgroup(
    list(lustre@vdom@vattr:attribute(POU)),
    list(lustre@vdom@vnode:element(POU))
) -> lustre@vdom@vnode:element(POU).
colgroup(Attrs, Children) ->
    lustre@element:element(<<"colgroup"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 693).
?DOC("\n").
-spec table(
    list(lustre@vdom@vattr:attribute(PPA)),
    list(lustre@vdom@vnode:element(PPA))
) -> lustre@vdom@vnode:element(PPA).
table(Attrs, Children) ->
    lustre@element:element(<<"table"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 701).
?DOC("\n").
-spec tbody(
    list(lustre@vdom@vattr:attribute(PPG)),
    list(lustre@vdom@vnode:element(PPG))
) -> lustre@vdom@vnode:element(PPG).
tbody(Attrs, Children) ->
    lustre@element:element(<<"tbody"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 709).
?DOC("\n").
-spec td(
    list(lustre@vdom@vattr:attribute(PPM)),
    list(lustre@vdom@vnode:element(PPM))
) -> lustre@vdom@vnode:element(PPM).
td(Attrs, Children) ->
    lustre@element:element(<<"td"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 717).
?DOC("\n").
-spec tfoot(
    list(lustre@vdom@vattr:attribute(PPS)),
    list(lustre@vdom@vnode:element(PPS))
) -> lustre@vdom@vnode:element(PPS).
tfoot(Attrs, Children) ->
    lustre@element:element(<<"tfoot"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 725).
?DOC("\n").
-spec th(
    list(lustre@vdom@vattr:attribute(PPY)),
    list(lustre@vdom@vnode:element(PPY))
) -> lustre@vdom@vnode:element(PPY).
th(Attrs, Children) ->
    lustre@element:element(<<"th"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 733).
?DOC("\n").
-spec thead(
    list(lustre@vdom@vattr:attribute(PQE)),
    list(lustre@vdom@vnode:element(PQE))
) -> lustre@vdom@vnode:element(PQE).
thead(Attrs, Children) ->
    lustre@element:element(<<"thead"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 741).
?DOC("\n").
-spec tr(
    list(lustre@vdom@vattr:attribute(PQK)),
    list(lustre@vdom@vnode:element(PQK))
) -> lustre@vdom@vnode:element(PQK).
tr(Attrs, Children) ->
    lustre@element:element(<<"tr"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 751).
?DOC("\n").
-spec button(
    list(lustre@vdom@vattr:attribute(PQQ)),
    list(lustre@vdom@vnode:element(PQQ))
) -> lustre@vdom@vnode:element(PQQ).
button(Attrs, Children) ->
    lustre@element:element(<<"button"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 759).
?DOC("\n").
-spec datalist(
    list(lustre@vdom@vattr:attribute(PQW)),
    list(lustre@vdom@vnode:element(PQW))
) -> lustre@vdom@vnode:element(PQW).
datalist(Attrs, Children) ->
    lustre@element:element(<<"datalist"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 767).
?DOC("\n").
-spec fieldset(
    list(lustre@vdom@vattr:attribute(PRC)),
    list(lustre@vdom@vnode:element(PRC))
) -> lustre@vdom@vnode:element(PRC).
fieldset(Attrs, Children) ->
    lustre@element:element(<<"fieldset"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 775).
?DOC("\n").
-spec form(
    list(lustre@vdom@vattr:attribute(PRI)),
    list(lustre@vdom@vnode:element(PRI))
) -> lustre@vdom@vnode:element(PRI).
form(Attrs, Children) ->
    lustre@element:element(<<"form"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 783).
?DOC("\n").
-spec input(list(lustre@vdom@vattr:attribute(PRO))) -> lustre@vdom@vnode:element(PRO).
input(Attrs) ->
    lustre@element:element(<<"input"/utf8>>, Attrs, []).

-file("src/lustre/element/html.gleam", 788).
?DOC("\n").
-spec label(
    list(lustre@vdom@vattr:attribute(PRS)),
    list(lustre@vdom@vnode:element(PRS))
) -> lustre@vdom@vnode:element(PRS).
label(Attrs, Children) ->
    lustre@element:element(<<"label"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 796).
?DOC("\n").
-spec legend(
    list(lustre@vdom@vattr:attribute(PRY)),
    list(lustre@vdom@vnode:element(PRY))
) -> lustre@vdom@vnode:element(PRY).
legend(Attrs, Children) ->
    lustre@element:element(<<"legend"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 804).
?DOC("\n").
-spec meter(
    list(lustre@vdom@vattr:attribute(PSE)),
    list(lustre@vdom@vnode:element(PSE))
) -> lustre@vdom@vnode:element(PSE).
meter(Attrs, Children) ->
    lustre@element:element(<<"meter"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 812).
?DOC("\n").
-spec optgroup(
    list(lustre@vdom@vattr:attribute(PSK)),
    list(lustre@vdom@vnode:element(PSK))
) -> lustre@vdom@vnode:element(PSK).
optgroup(Attrs, Children) ->
    lustre@element:element(<<"optgroup"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 820).
?DOC("\n").
-spec option(list(lustre@vdom@vattr:attribute(PSQ)), binary()) -> lustre@vdom@vnode:element(PSQ).
option(Attrs, Label) ->
    lustre@element:element(
        <<"option"/utf8>>,
        Attrs,
        [lustre@element:text(Label)]
    ).

-file("src/lustre/element/html.gleam", 825).
?DOC("\n").
-spec output(
    list(lustre@vdom@vattr:attribute(PSU)),
    list(lustre@vdom@vnode:element(PSU))
) -> lustre@vdom@vnode:element(PSU).
output(Attrs, Children) ->
    lustre@element:element(<<"output"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 833).
?DOC("\n").
-spec progress(
    list(lustre@vdom@vattr:attribute(PTA)),
    list(lustre@vdom@vnode:element(PTA))
) -> lustre@vdom@vnode:element(PTA).
progress(Attrs, Children) ->
    lustre@element:element(<<"progress"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 841).
?DOC("\n").
-spec select(
    list(lustre@vdom@vattr:attribute(PTG)),
    list(lustre@vdom@vnode:element(PTG))
) -> lustre@vdom@vnode:element(PTG).
select(Attrs, Children) ->
    lustre@element:element(<<"select"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 849).
?DOC("\n").
-spec textarea(list(lustre@vdom@vattr:attribute(PTM)), binary()) -> lustre@vdom@vnode:element(PTM).
textarea(Attrs, Content) ->
    lustre@element:element(
        <<"textarea"/utf8>>,
        [lustre@attribute:property(<<"value"/utf8>>, gleam@json:string(Content)) |
            Attrs],
        [lustre@element:text(Content)]
    ).

-file("src/lustre/element/html.gleam", 860).
?DOC("\n").
-spec details(
    list(lustre@vdom@vattr:attribute(PTQ)),
    list(lustre@vdom@vnode:element(PTQ))
) -> lustre@vdom@vnode:element(PTQ).
details(Attrs, Children) ->
    lustre@element:element(<<"details"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 868).
?DOC("\n").
-spec dialog(
    list(lustre@vdom@vattr:attribute(PTW)),
    list(lustre@vdom@vnode:element(PTW))
) -> lustre@vdom@vnode:element(PTW).
dialog(Attrs, Children) ->
    lustre@element:element(<<"dialog"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 876).
?DOC("\n").
-spec summary(
    list(lustre@vdom@vattr:attribute(PUC)),
    list(lustre@vdom@vnode:element(PUC))
) -> lustre@vdom@vnode:element(PUC).
summary(Attrs, Children) ->
    lustre@element:element(<<"summary"/utf8>>, Attrs, Children).

-file("src/lustre/element/html.gleam", 886).
?DOC("\n").
-spec slot(
    list(lustre@vdom@vattr:attribute(PUI)),
    list(lustre@vdom@vnode:element(PUI))
) -> lustre@vdom@vnode:element(PUI).
slot(Attrs, Fallback) ->
    lustre@element:element(<<"slot"/utf8>>, Attrs, Fallback).

-file("src/lustre/element/html.gleam", 894).
?DOC("\n").
-spec template(
    list(lustre@vdom@vattr:attribute(PUO)),
    list(lustre@vdom@vnode:element(PUO))
) -> lustre@vdom@vnode:element(PUO).
template(Attrs, Children) ->
    lustre@element:element(<<"template"/utf8>>, Attrs, Children).
