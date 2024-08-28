-module(lustre@ssg@atom).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([feed/2, entry/2, id/2, title/2, updated/2, published/2, author/2, contributor/2, source/2, link/1, name/2, email/2, uri/2, category/1, generator/2, icon/2, logo/2, rights/2, subtitle/2, summary/2, content/2]).

-spec feed(
    list(lustre@internals@vdom:attribute(PMQ)),
    list(lustre@internals@vdom:element(PMQ))
) -> lustre@internals@vdom:element(PMQ).
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
    list(lustre@internals@vdom:attribute(PMW)),
    list(lustre@internals@vdom:element(PMW))
) -> lustre@internals@vdom:element(PMW).
entry(Attrs, Children) ->
    lustre@element:element(<<"entry"/utf8>>, Attrs, Children).

-spec id(list(lustre@internals@vdom:attribute(PNC)), binary()) -> lustre@internals@vdom:element(PNC).
id(Attrs, Uri) ->
    lustre@element:element(<<"id"/utf8>>, Attrs, [lustre@element:text(Uri)]).

-spec title(list(lustre@internals@vdom:attribute(PNG)), binary()) -> lustre@internals@vdom:element(PNG).
title(Attrs, Title) ->
    lustre@element:element(
        <<"title"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Title)]
    ).

-spec updated(list(lustre@internals@vdom:attribute(PNK)), binary()) -> lustre@internals@vdom:element(PNK).
updated(Attrs, Iso_timestamp) ->
    lustre@element:element(
        <<"updated"/utf8>>,
        Attrs,
        [lustre@element:text(Iso_timestamp)]
    ).

-spec published(list(lustre@internals@vdom:attribute(PNO)), binary()) -> lustre@internals@vdom:element(PNO).
published(Attrs, Iso_timestamp) ->
    lustre@element:element(
        <<"published"/utf8>>,
        Attrs,
        [lustre@element:text(Iso_timestamp)]
    ).

-spec author(
    list(lustre@internals@vdom:attribute(PNS)),
    list(lustre@internals@vdom:element(PNS))
) -> lustre@internals@vdom:element(PNS).
author(Attrs, Children) ->
    lustre@element:element(<<"author"/utf8>>, Attrs, Children).

-spec contributor(
    list(lustre@internals@vdom:attribute(PNY)),
    list(lustre@internals@vdom:element(PNY))
) -> lustre@internals@vdom:element(PNY).
contributor(Attrs, Children) ->
    lustre@element:element(<<"contributor"/utf8>>, Attrs, Children).

-spec source(
    list(lustre@internals@vdom:attribute(POE)),
    list(lustre@internals@vdom:element(POE))
) -> lustre@internals@vdom:element(POE).
source(Attrs, Children) ->
    lustre@element:element(<<"source"/utf8>>, Attrs, Children).

-spec link(list(lustre@internals@vdom:attribute(POK))) -> lustre@internals@vdom:element(POK).
link(Attrs) ->
    lustre@element:advanced(
        <<""/utf8>>,
        <<"link"/utf8>>,
        Attrs,
        [],
        true,
        false
    ).

-spec name(list(lustre@internals@vdom:attribute(POO)), binary()) -> lustre@internals@vdom:element(POO).
name(Attrs, Name) ->
    lustre@element:element(<<"name"/utf8>>, Attrs, [lustre@element:text(Name)]).

-spec email(list(lustre@internals@vdom:attribute(POS)), binary()) -> lustre@internals@vdom:element(POS).
email(Attrs, Email) ->
    lustre@element:element(
        <<"email"/utf8>>,
        Attrs,
        [lustre@element:text(Email)]
    ).

-spec uri(list(lustre@internals@vdom:attribute(POW)), binary()) -> lustre@internals@vdom:element(POW).
uri(Attrs, Uri) ->
    lustre@element:element(<<"uri"/utf8>>, Attrs, [lustre@element:text(Uri)]).

-spec category(list(lustre@internals@vdom:attribute(PPA))) -> lustre@internals@vdom:element(PPA).
category(Attrs) ->
    lustre@element:advanced(
        <<""/utf8>>,
        <<"category"/utf8>>,
        Attrs,
        [],
        true,
        false
    ).

-spec generator(list(lustre@internals@vdom:attribute(PPE)), binary()) -> lustre@internals@vdom:element(PPE).
generator(Attrs, Name) ->
    lustre@element:element(
        <<"generator"/utf8>>,
        Attrs,
        [lustre@element:text(Name)]
    ).

-spec icon(list(lustre@internals@vdom:attribute(PPI)), binary()) -> lustre@internals@vdom:element(PPI).
icon(Attrs, Path) ->
    lustre@element:element(<<"icon"/utf8>>, Attrs, [lustre@element:text(Path)]).

-spec logo(list(lustre@internals@vdom:attribute(PPM)), binary()) -> lustre@internals@vdom:element(PPM).
logo(Attrs, Path) ->
    lustre@element:element(<<"logo"/utf8>>, Attrs, [lustre@element:text(Path)]).

-spec rights(list(lustre@internals@vdom:attribute(PPQ)), binary()) -> lustre@internals@vdom:element(PPQ).
rights(Attrs, Rights) ->
    lustre@element:element(
        <<"rights"/utf8>>,
        Attrs,
        [lustre@element:text(Rights)]
    ).

-spec subtitle(list(lustre@internals@vdom:attribute(PPU)), binary()) -> lustre@internals@vdom:element(PPU).
subtitle(Attrs, Subtitle) ->
    lustre@element:element(
        <<"subtitle"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Subtitle)]
    ).

-spec summary(list(lustre@internals@vdom:attribute(PPY)), binary()) -> lustre@internals@vdom:element(PPY).
summary(Attrs, Summary) ->
    lustre@element:element(
        <<"summary"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Summary)]
    ).

-spec content(list(lustre@internals@vdom:attribute(PQC)), binary()) -> lustre@internals@vdom:element(PQC).
content(Attrs, Content) ->
    lustre@element:element(
        <<"content"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Content)]
    ).
