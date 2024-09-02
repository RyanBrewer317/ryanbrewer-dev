-module(lustre@ssg@atom).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([feed/2, entry/2, id/2, title/2, updated/2, published/2, author/2, contributor/2, source/2, link/1, name/2, email/2, uri/2, category/1, generator/2, icon/2, logo/2, rights/2, subtitle/2, summary/2, content/2]).

-spec feed(
    list(lustre@internals@vdom:attribute(PWW)),
    list(lustre@internals@vdom:element(PWW))
) -> lustre@internals@vdom:element(PWW).
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
    list(lustre@internals@vdom:attribute(PXC)),
    list(lustre@internals@vdom:element(PXC))
) -> lustre@internals@vdom:element(PXC).
entry(Attrs, Children) ->
    lustre@element:element(<<"entry"/utf8>>, Attrs, Children).

-spec id(list(lustre@internals@vdom:attribute(PXI)), binary()) -> lustre@internals@vdom:element(PXI).
id(Attrs, Uri) ->
    lustre@element:element(<<"id"/utf8>>, Attrs, [lustre@element:text(Uri)]).

-spec title(list(lustre@internals@vdom:attribute(PXM)), binary()) -> lustre@internals@vdom:element(PXM).
title(Attrs, Title) ->
    lustre@element:element(
        <<"title"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Title)]
    ).

-spec updated(list(lustre@internals@vdom:attribute(PXQ)), binary()) -> lustre@internals@vdom:element(PXQ).
updated(Attrs, Iso_timestamp) ->
    lustre@element:element(
        <<"updated"/utf8>>,
        Attrs,
        [lustre@element:text(Iso_timestamp)]
    ).

-spec published(list(lustre@internals@vdom:attribute(PXU)), binary()) -> lustre@internals@vdom:element(PXU).
published(Attrs, Iso_timestamp) ->
    lustre@element:element(
        <<"published"/utf8>>,
        Attrs,
        [lustre@element:text(Iso_timestamp)]
    ).

-spec author(
    list(lustre@internals@vdom:attribute(PXY)),
    list(lustre@internals@vdom:element(PXY))
) -> lustre@internals@vdom:element(PXY).
author(Attrs, Children) ->
    lustre@element:element(<<"author"/utf8>>, Attrs, Children).

-spec contributor(
    list(lustre@internals@vdom:attribute(PYE)),
    list(lustre@internals@vdom:element(PYE))
) -> lustre@internals@vdom:element(PYE).
contributor(Attrs, Children) ->
    lustre@element:element(<<"contributor"/utf8>>, Attrs, Children).

-spec source(
    list(lustre@internals@vdom:attribute(PYK)),
    list(lustre@internals@vdom:element(PYK))
) -> lustre@internals@vdom:element(PYK).
source(Attrs, Children) ->
    lustre@element:element(<<"source"/utf8>>, Attrs, Children).

-spec link(list(lustre@internals@vdom:attribute(PYQ))) -> lustre@internals@vdom:element(PYQ).
link(Attrs) ->
    lustre@element:advanced(
        <<""/utf8>>,
        <<"link"/utf8>>,
        Attrs,
        [],
        true,
        false
    ).

-spec name(list(lustre@internals@vdom:attribute(PYU)), binary()) -> lustre@internals@vdom:element(PYU).
name(Attrs, Name) ->
    lustre@element:element(<<"name"/utf8>>, Attrs, [lustre@element:text(Name)]).

-spec email(list(lustre@internals@vdom:attribute(PYY)), binary()) -> lustre@internals@vdom:element(PYY).
email(Attrs, Email) ->
    lustre@element:element(
        <<"email"/utf8>>,
        Attrs,
        [lustre@element:text(Email)]
    ).

-spec uri(list(lustre@internals@vdom:attribute(PZC)), binary()) -> lustre@internals@vdom:element(PZC).
uri(Attrs, Uri) ->
    lustre@element:element(<<"uri"/utf8>>, Attrs, [lustre@element:text(Uri)]).

-spec category(list(lustre@internals@vdom:attribute(PZG))) -> lustre@internals@vdom:element(PZG).
category(Attrs) ->
    lustre@element:advanced(
        <<""/utf8>>,
        <<"category"/utf8>>,
        Attrs,
        [],
        true,
        false
    ).

-spec generator(list(lustre@internals@vdom:attribute(PZK)), binary()) -> lustre@internals@vdom:element(PZK).
generator(Attrs, Name) ->
    lustre@element:element(
        <<"generator"/utf8>>,
        Attrs,
        [lustre@element:text(Name)]
    ).

-spec icon(list(lustre@internals@vdom:attribute(PZO)), binary()) -> lustre@internals@vdom:element(PZO).
icon(Attrs, Path) ->
    lustre@element:element(<<"icon"/utf8>>, Attrs, [lustre@element:text(Path)]).

-spec logo(list(lustre@internals@vdom:attribute(PZS)), binary()) -> lustre@internals@vdom:element(PZS).
logo(Attrs, Path) ->
    lustre@element:element(<<"logo"/utf8>>, Attrs, [lustre@element:text(Path)]).

-spec rights(list(lustre@internals@vdom:attribute(PZW)), binary()) -> lustre@internals@vdom:element(PZW).
rights(Attrs, Rights) ->
    lustre@element:element(
        <<"rights"/utf8>>,
        Attrs,
        [lustre@element:text(Rights)]
    ).

-spec subtitle(list(lustre@internals@vdom:attribute(QAA)), binary()) -> lustre@internals@vdom:element(QAA).
subtitle(Attrs, Subtitle) ->
    lustre@element:element(
        <<"subtitle"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Subtitle)]
    ).

-spec summary(list(lustre@internals@vdom:attribute(QAE)), binary()) -> lustre@internals@vdom:element(QAE).
summary(Attrs, Summary) ->
    lustre@element:element(
        <<"summary"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Summary)]
    ).

-spec content(list(lustre@internals@vdom:attribute(QAI)), binary()) -> lustre@internals@vdom:element(QAI).
content(Attrs, Content) ->
    lustre@element:element(
        <<"content"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Content)]
    ).
