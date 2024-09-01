-module(lustre@ssg@atom).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([feed/2, entry/2, id/2, title/2, updated/2, published/2, author/2, contributor/2, source/2, link/1, name/2, email/2, uri/2, category/1, generator/2, icon/2, logo/2, rights/2, subtitle/2, summary/2, content/2]).

-spec feed(
    list(lustre@internals@vdom:attribute(PSR)),
    list(lustre@internals@vdom:element(PSR))
) -> lustre@internals@vdom:element(PSR).
feed(Attrs, Children) ->
    lustre@element:element(
        <<"feed"/utf8>>,
        [lustre@attribute:attribute(
                <<"xmlns"/utf8>>,
                <<"http://www.w3.org/2005/Atom"/utf8>>
            ) |
            Attrs],
        Children
    ).

-spec entry(
    list(lustre@internals@vdom:attribute(PSX)),
    list(lustre@internals@vdom:element(PSX))
) -> lustre@internals@vdom:element(PSX).
entry(Attrs, Children) ->
    lustre@element:element(<<"entry"/utf8>>, Attrs, Children).

-spec id(list(lustre@internals@vdom:attribute(PTD)), binary()) -> lustre@internals@vdom:element(PTD).
id(Attrs, Uri) ->
    lustre@element:element(<<"id"/utf8>>, Attrs, [lustre@element:text(Uri)]).

-spec title(list(lustre@internals@vdom:attribute(PTH)), binary()) -> lustre@internals@vdom:element(PTH).
title(Attrs, Title) ->
    lustre@element:element(
        <<"title"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Title)]
    ).

-spec updated(list(lustre@internals@vdom:attribute(PTL)), binary()) -> lustre@internals@vdom:element(PTL).
updated(Attrs, Iso_timestamp) ->
    lustre@element:element(
        <<"updated"/utf8>>,
        Attrs,
        [lustre@element:text(Iso_timestamp)]
    ).

-spec published(list(lustre@internals@vdom:attribute(PTP)), binary()) -> lustre@internals@vdom:element(PTP).
published(Attrs, Iso_timestamp) ->
    lustre@element:element(
        <<"published"/utf8>>,
        Attrs,
        [lustre@element:text(Iso_timestamp)]
    ).

-spec author(
    list(lustre@internals@vdom:attribute(PTT)),
    list(lustre@internals@vdom:element(PTT))
) -> lustre@internals@vdom:element(PTT).
author(Attrs, Children) ->
    lustre@element:element(<<"author"/utf8>>, Attrs, Children).

-spec contributor(
    list(lustre@internals@vdom:attribute(PTZ)),
    list(lustre@internals@vdom:element(PTZ))
) -> lustre@internals@vdom:element(PTZ).
contributor(Attrs, Children) ->
    lustre@element:element(<<"contributor"/utf8>>, Attrs, Children).

-spec source(
    list(lustre@internals@vdom:attribute(PUF)),
    list(lustre@internals@vdom:element(PUF))
) -> lustre@internals@vdom:element(PUF).
source(Attrs, Children) ->
    lustre@element:element(<<"source"/utf8>>, Attrs, Children).

-spec link(list(lustre@internals@vdom:attribute(PUL))) -> lustre@internals@vdom:element(PUL).
link(Attrs) ->
    lustre@element:advanced(
        <<""/utf8>>,
        <<"link"/utf8>>,
        Attrs,
        [],
        true,
        false
    ).

-spec name(list(lustre@internals@vdom:attribute(PUP)), binary()) -> lustre@internals@vdom:element(PUP).
name(Attrs, Name) ->
    lustre@element:element(<<"name"/utf8>>, Attrs, [lustre@element:text(Name)]).

-spec email(list(lustre@internals@vdom:attribute(PUT)), binary()) -> lustre@internals@vdom:element(PUT).
email(Attrs, Email) ->
    lustre@element:element(
        <<"email"/utf8>>,
        Attrs,
        [lustre@element:text(Email)]
    ).

-spec uri(list(lustre@internals@vdom:attribute(PUX)), binary()) -> lustre@internals@vdom:element(PUX).
uri(Attrs, Uri) ->
    lustre@element:element(<<"uri"/utf8>>, Attrs, [lustre@element:text(Uri)]).

-spec category(list(lustre@internals@vdom:attribute(PVB))) -> lustre@internals@vdom:element(PVB).
category(Attrs) ->
    lustre@element:advanced(
        <<""/utf8>>,
        <<"category"/utf8>>,
        Attrs,
        [],
        true,
        false
    ).

-spec generator(list(lustre@internals@vdom:attribute(PVF)), binary()) -> lustre@internals@vdom:element(PVF).
generator(Attrs, Name) ->
    lustre@element:element(
        <<"generator"/utf8>>,
        Attrs,
        [lustre@element:text(Name)]
    ).

-spec icon(list(lustre@internals@vdom:attribute(PVJ)), binary()) -> lustre@internals@vdom:element(PVJ).
icon(Attrs, Path) ->
    lustre@element:element(<<"icon"/utf8>>, Attrs, [lustre@element:text(Path)]).

-spec logo(list(lustre@internals@vdom:attribute(PVN)), binary()) -> lustre@internals@vdom:element(PVN).
logo(Attrs, Path) ->
    lustre@element:element(<<"logo"/utf8>>, Attrs, [lustre@element:text(Path)]).

-spec rights(list(lustre@internals@vdom:attribute(PVR)), binary()) -> lustre@internals@vdom:element(PVR).
rights(Attrs, Rights) ->
    lustre@element:element(
        <<"rights"/utf8>>,
        Attrs,
        [lustre@element:text(Rights)]
    ).

-spec subtitle(list(lustre@internals@vdom:attribute(PVV)), binary()) -> lustre@internals@vdom:element(PVV).
subtitle(Attrs, Subtitle) ->
    lustre@element:element(
        <<"subtitle"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Subtitle)]
    ).

-spec summary(list(lustre@internals@vdom:attribute(PVZ)), binary()) -> lustre@internals@vdom:element(PVZ).
summary(Attrs, Summary) ->
    lustre@element:element(
        <<"summary"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Summary)]
    ).

-spec content(list(lustre@internals@vdom:attribute(PWD)), binary()) -> lustre@internals@vdom:element(PWD).
content(Attrs, Content) ->
    lustre@element:element(
        <<"content"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Content)]
    ).
