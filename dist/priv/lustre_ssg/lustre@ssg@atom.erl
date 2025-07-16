-module(lustre@ssg@atom).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([feed/2, entry/2, id/2, title/2, updated/2, published/2, author/2, contributor/2, source/2, link/1, name/2, email/2, uri/2, category/1, generator/2, icon/2, logo/2, rights/2, subtitle/2, summary/2, content/2]).

-file("src/lustre/ssg/atom.gleam", 8).
-spec feed(
    list(lustre@vdom@vattr:attribute(SGT)),
    list(lustre@vdom@vnode:element(SGT))
) -> lustre@vdom@vnode:element(SGT).
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
    list(lustre@vdom@vattr:attribute(SGZ)),
    list(lustre@vdom@vnode:element(SGZ))
) -> lustre@vdom@vnode:element(SGZ).
entry(Attrs, Children) ->
    lustre@element:element(<<"entry"/utf8>>, Attrs, Children).

-file("src/lustre/ssg/atom.gleam", 20).
-spec id(list(lustre@vdom@vattr:attribute(SHF)), binary()) -> lustre@vdom@vnode:element(SHF).
id(Attrs, Uri) ->
    lustre@element:element(<<"id"/utf8>>, Attrs, [lustre@element:text(Uri)]).

-file("src/lustre/ssg/atom.gleam", 24).
-spec title(list(lustre@vdom@vattr:attribute(SHJ)), binary()) -> lustre@vdom@vnode:element(SHJ).
title(Attrs, Title) ->
    lustre@element:element(
        <<"title"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Title)]
    ).

-file("src/lustre/ssg/atom.gleam", 28).
-spec updated(list(lustre@vdom@vattr:attribute(SHN)), binary()) -> lustre@vdom@vnode:element(SHN).
updated(Attrs, Iso_timestamp) ->
    lustre@element:element(
        <<"updated"/utf8>>,
        Attrs,
        [lustre@element:text(Iso_timestamp)]
    ).

-file("src/lustre/ssg/atom.gleam", 32).
-spec published(list(lustre@vdom@vattr:attribute(SHR)), binary()) -> lustre@vdom@vnode:element(SHR).
published(Attrs, Iso_timestamp) ->
    lustre@element:element(
        <<"published"/utf8>>,
        Attrs,
        [lustre@element:text(Iso_timestamp)]
    ).

-file("src/lustre/ssg/atom.gleam", 36).
-spec author(
    list(lustre@vdom@vattr:attribute(SHV)),
    list(lustre@vdom@vnode:element(SHV))
) -> lustre@vdom@vnode:element(SHV).
author(Attrs, Children) ->
    lustre@element:element(<<"author"/utf8>>, Attrs, Children).

-file("src/lustre/ssg/atom.gleam", 40).
-spec contributor(
    list(lustre@vdom@vattr:attribute(SIB)),
    list(lustre@vdom@vnode:element(SIB))
) -> lustre@vdom@vnode:element(SIB).
contributor(Attrs, Children) ->
    lustre@element:element(<<"contributor"/utf8>>, Attrs, Children).

-file("src/lustre/ssg/atom.gleam", 44).
-spec source(
    list(lustre@vdom@vattr:attribute(SIH)),
    list(lustre@vdom@vnode:element(SIH))
) -> lustre@vdom@vnode:element(SIH).
source(Attrs, Children) ->
    lustre@element:element(<<"source"/utf8>>, Attrs, Children).

-file("src/lustre/ssg/atom.gleam", 48).
-spec link(list(lustre@vdom@vattr:attribute(SIN))) -> lustre@vdom@vnode:element(SIN).
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
-spec name(list(lustre@vdom@vattr:attribute(SIR)), binary()) -> lustre@vdom@vnode:element(SIR).
name(Attrs, Name) ->
    lustre@element:element(<<"name"/utf8>>, Attrs, [lustre@element:text(Name)]).

-file("src/lustre/ssg/atom.gleam", 56).
-spec email(list(lustre@vdom@vattr:attribute(SIV)), binary()) -> lustre@vdom@vnode:element(SIV).
email(Attrs, Email) ->
    lustre@element:element(
        <<"email"/utf8>>,
        Attrs,
        [lustre@element:text(Email)]
    ).

-file("src/lustre/ssg/atom.gleam", 60).
-spec uri(list(lustre@vdom@vattr:attribute(SIZ)), binary()) -> lustre@vdom@vnode:element(SIZ).
uri(Attrs, Uri) ->
    lustre@element:element(<<"uri"/utf8>>, Attrs, [lustre@element:text(Uri)]).

-file("src/lustre/ssg/atom.gleam", 64).
-spec category(list(lustre@vdom@vattr:attribute(SJD))) -> lustre@vdom@vnode:element(SJD).
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
-spec generator(list(lustre@vdom@vattr:attribute(SJH)), binary()) -> lustre@vdom@vnode:element(SJH).
generator(Attrs, Name) ->
    lustre@element:element(
        <<"generator"/utf8>>,
        Attrs,
        [lustre@element:text(Name)]
    ).

-file("src/lustre/ssg/atom.gleam", 72).
-spec icon(list(lustre@vdom@vattr:attribute(SJL)), binary()) -> lustre@vdom@vnode:element(SJL).
icon(Attrs, Path) ->
    lustre@element:element(<<"icon"/utf8>>, Attrs, [lustre@element:text(Path)]).

-file("src/lustre/ssg/atom.gleam", 76).
-spec logo(list(lustre@vdom@vattr:attribute(SJP)), binary()) -> lustre@vdom@vnode:element(SJP).
logo(Attrs, Path) ->
    lustre@element:element(<<"logo"/utf8>>, Attrs, [lustre@element:text(Path)]).

-file("src/lustre/ssg/atom.gleam", 80).
-spec rights(list(lustre@vdom@vattr:attribute(SJT)), binary()) -> lustre@vdom@vnode:element(SJT).
rights(Attrs, Rights) ->
    lustre@element:element(
        <<"rights"/utf8>>,
        Attrs,
        [lustre@element:text(Rights)]
    ).

-file("src/lustre/ssg/atom.gleam", 84).
-spec subtitle(list(lustre@vdom@vattr:attribute(SJX)), binary()) -> lustre@vdom@vnode:element(SJX).
subtitle(Attrs, Subtitle) ->
    lustre@element:element(
        <<"subtitle"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Subtitle)]
    ).

-file("src/lustre/ssg/atom.gleam", 90).
-spec summary(list(lustre@vdom@vattr:attribute(SKB)), binary()) -> lustre@vdom@vnode:element(SKB).
summary(Attrs, Summary) ->
    lustre@element:element(
        <<"summary"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Summary)]
    ).

-file("src/lustre/ssg/atom.gleam", 96).
-spec content(list(lustre@vdom@vattr:attribute(SKF)), binary()) -> lustre@vdom@vnode:element(SKF).
content(Attrs, Content) ->
    lustre@element:element(
        <<"content"/utf8>>,
        [lustre@attribute:attribute(<<"type"/utf8>>, <<"html"/utf8>>) | Attrs],
        [lustre@element:text(Content)]
    ).
