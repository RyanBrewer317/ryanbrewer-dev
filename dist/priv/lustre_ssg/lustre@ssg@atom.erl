-module(lustre@ssg@atom).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([feed/2, entry/2, id/2, title/2, updated/2, published/2, author/2, contributor/2, source/2, link/1, name/2, email/2, uri/2, category/1, generator/2, icon/2, logo/2, rights/2, subtitle/2, summary/2, content/2]).

-file("src/lustre/ssg/atom.gleam", 8).
-spec feed(
    list(lustre@internals@vdom:attribute(QRM)),
    list(lustre@internals@vdom:element(QRM))
) -> lustre@internals@vdom:element(QRM).
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

-file("src/lustre/ssg/atom.gleam", 16).
-spec entry(
    list(lustre@internals@vdom:attribute(QRS)),
    list(lustre@internals@vdom:element(QRS))
) -> lustre@internals@vdom:element(QRS).
entry(Attrs, Children) ->
    lustre@element:element(<<"entry"/utf8>>, Attrs, Children).

-file("src/lustre/ssg/atom.gleam", 20).
-spec id(list(lustre@internals@vdom:attribute(QRY)), binary()) -> lustre@internals@vdom:element(QRY).
id(Attrs, Uri) ->
    lustre@element:element(<<"id"/utf8>>, Attrs, [lustre@element:text(Uri)]).

-file("src/lustre/ssg/atom.gleam", 24).
-spec title(list(lustre@internals@vdom:attribute(QSC)), binary()) -> lustre@internals@vdom:element(QSC).
title(Attrs, Title) ->
    lustre@element:element(
        <<"title"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Title)]
    ).

-file("src/lustre/ssg/atom.gleam", 28).
-spec updated(list(lustre@internals@vdom:attribute(QSG)), binary()) -> lustre@internals@vdom:element(QSG).
updated(Attrs, Iso_timestamp) ->
    lustre@element:element(
        <<"updated"/utf8>>,
        Attrs,
        [lustre@element:text(Iso_timestamp)]
    ).

-file("src/lustre/ssg/atom.gleam", 32).
-spec published(list(lustre@internals@vdom:attribute(QSK)), binary()) -> lustre@internals@vdom:element(QSK).
published(Attrs, Iso_timestamp) ->
    lustre@element:element(
        <<"published"/utf8>>,
        Attrs,
        [lustre@element:text(Iso_timestamp)]
    ).

-file("src/lustre/ssg/atom.gleam", 36).
-spec author(
    list(lustre@internals@vdom:attribute(QSO)),
    list(lustre@internals@vdom:element(QSO))
) -> lustre@internals@vdom:element(QSO).
author(Attrs, Children) ->
    lustre@element:element(<<"author"/utf8>>, Attrs, Children).

-file("src/lustre/ssg/atom.gleam", 40).
-spec contributor(
    list(lustre@internals@vdom:attribute(QSU)),
    list(lustre@internals@vdom:element(QSU))
) -> lustre@internals@vdom:element(QSU).
contributor(Attrs, Children) ->
    lustre@element:element(<<"contributor"/utf8>>, Attrs, Children).

-file("src/lustre/ssg/atom.gleam", 44).
-spec source(
    list(lustre@internals@vdom:attribute(QTA)),
    list(lustre@internals@vdom:element(QTA))
) -> lustre@internals@vdom:element(QTA).
source(Attrs, Children) ->
    lustre@element:element(<<"source"/utf8>>, Attrs, Children).

-file("src/lustre/ssg/atom.gleam", 48).
-spec link(list(lustre@internals@vdom:attribute(QTG))) -> lustre@internals@vdom:element(QTG).
link(Attrs) ->
    lustre@element:advanced(
        <<""/utf8>>,
        <<"link"/utf8>>,
        Attrs,
        [],
        true,
        false
    ).

-file("src/lustre/ssg/atom.gleam", 52).
-spec name(list(lustre@internals@vdom:attribute(QTK)), binary()) -> lustre@internals@vdom:element(QTK).
name(Attrs, Name) ->
    lustre@element:element(<<"name"/utf8>>, Attrs, [lustre@element:text(Name)]).

-file("src/lustre/ssg/atom.gleam", 56).
-spec email(list(lustre@internals@vdom:attribute(QTO)), binary()) -> lustre@internals@vdom:element(QTO).
email(Attrs, Email) ->
    lustre@element:element(
        <<"email"/utf8>>,
        Attrs,
        [lustre@element:text(Email)]
    ).

-file("src/lustre/ssg/atom.gleam", 60).
-spec uri(list(lustre@internals@vdom:attribute(QTS)), binary()) -> lustre@internals@vdom:element(QTS).
uri(Attrs, Uri) ->
    lustre@element:element(<<"uri"/utf8>>, Attrs, [lustre@element:text(Uri)]).

-file("src/lustre/ssg/atom.gleam", 64).
-spec category(list(lustre@internals@vdom:attribute(QTW))) -> lustre@internals@vdom:element(QTW).
category(Attrs) ->
    lustre@element:advanced(
        <<""/utf8>>,
        <<"category"/utf8>>,
        Attrs,
        [],
        true,
        false
    ).

-file("src/lustre/ssg/atom.gleam", 68).
-spec generator(list(lustre@internals@vdom:attribute(QUA)), binary()) -> lustre@internals@vdom:element(QUA).
generator(Attrs, Name) ->
    lustre@element:element(
        <<"generator"/utf8>>,
        Attrs,
        [lustre@element:text(Name)]
    ).

-file("src/lustre/ssg/atom.gleam", 72).
-spec icon(list(lustre@internals@vdom:attribute(QUE)), binary()) -> lustre@internals@vdom:element(QUE).
icon(Attrs, Path) ->
    lustre@element:element(<<"icon"/utf8>>, Attrs, [lustre@element:text(Path)]).

-file("src/lustre/ssg/atom.gleam", 76).
-spec logo(list(lustre@internals@vdom:attribute(QUI)), binary()) -> lustre@internals@vdom:element(QUI).
logo(Attrs, Path) ->
    lustre@element:element(<<"logo"/utf8>>, Attrs, [lustre@element:text(Path)]).

-file("src/lustre/ssg/atom.gleam", 80).
-spec rights(list(lustre@internals@vdom:attribute(QUM)), binary()) -> lustre@internals@vdom:element(QUM).
rights(Attrs, Rights) ->
    lustre@element:element(
        <<"rights"/utf8>>,
        Attrs,
        [lustre@element:text(Rights)]
    ).

-file("src/lustre/ssg/atom.gleam", 84).
-spec subtitle(list(lustre@internals@vdom:attribute(QUQ)), binary()) -> lustre@internals@vdom:element(QUQ).
subtitle(Attrs, Subtitle) ->
    lustre@element:element(
        <<"subtitle"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Subtitle)]
    ).

-file("src/lustre/ssg/atom.gleam", 90).
-spec summary(list(lustre@internals@vdom:attribute(QUU)), binary()) -> lustre@internals@vdom:element(QUU).
summary(Attrs, Summary) ->
    lustre@element:element(
        <<"summary"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Summary)]
    ).

-file("src/lustre/ssg/atom.gleam", 96).
-spec content(list(lustre@internals@vdom:attribute(QUY)), binary()) -> lustre@internals@vdom:element(QUY).
content(Attrs, Content) ->
    lustre@element:element(
        <<"content"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Content)]
    ).
