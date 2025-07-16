-module(lustre@ssg@opengraph).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([title/1, website/0, url/1, description/1, site_name/1, image/1, image_type/1, image_width/1, image_height/1, image_alt/1]).

-file("src/lustre/ssg/opengraph.gleam", 10).
-spec title(binary()) -> lustre@vdom@vnode:element(any()).
title(Text) ->
    lustre@element@html:meta(
        [lustre@attribute:attribute(<<"property"/utf8>>, <<"og:title"/utf8>>),
            lustre@attribute:content(Text)]
    ).

-file("src/lustre/ssg/opengraph.gleam", 14).
-spec website() -> lustre@vdom@vnode:element(any()).
website() ->
    lustre@element@html:meta(
        [lustre@attribute:attribute(<<"property"/utf8>>, <<"og:type"/utf8>>),
            lustre@attribute:content(<<"website"/utf8>>)]
    ).

-file("src/lustre/ssg/opengraph.gleam", 18).
-spec url(gleam@uri:uri()) -> lustre@vdom@vnode:element(any()).
url(Content) ->
    lustre@element@html:meta(
        [lustre@attribute:attribute(<<"property"/utf8>>, <<"og:url"/utf8>>),
            lustre@attribute:content(gleam@uri:to_string(Content))]
    ).

-file("src/lustre/ssg/opengraph.gleam", 25).
-spec description(binary()) -> lustre@vdom@vnode:element(any()).
description(Content) ->
    lustre@element@html:meta(
        [lustre@attribute:attribute(
                <<"property"/utf8>>,
                <<"og:description"/utf8>>
            ),
            lustre@attribute:content(Content)]
    ).

-file("src/lustre/ssg/opengraph.gleam", 32).
-spec site_name(binary()) -> lustre@vdom@vnode:element(any()).
site_name(Content) ->
    lustre@element@html:meta(
        [lustre@attribute:attribute(
                <<"property"/utf8>>,
                <<"og:site_name"/utf8>>
            ),
            lustre@attribute:content(Content)]
    ).

-file("src/lustre/ssg/opengraph.gleam", 36).
-spec image(gleam@uri:uri()) -> lustre@vdom@vnode:element(any()).
image(Content) ->
    lustre@element@html:meta(
        [lustre@attribute:attribute(<<"property"/utf8>>, <<"og:image"/utf8>>),
            lustre@attribute:content(gleam@uri:to_string(Content))]
    ).

-file("src/lustre/ssg/opengraph.gleam", 43).
-spec image_type(binary()) -> lustre@vdom@vnode:element(any()).
image_type(Content) ->
    lustre@element@html:meta(
        [lustre@attribute:attribute(
                <<"property"/utf8>>,
                <<"og:image:type"/utf8>>
            ),
            lustre@attribute:content(Content)]
    ).

-file("src/lustre/ssg/opengraph.gleam", 47).
-spec image_width(integer()) -> lustre@vdom@vnode:element(any()).
image_width(Content) ->
    lustre@element@html:meta(
        [lustre@attribute:attribute(
                <<"property"/utf8>>,
                <<"og:image:width"/utf8>>
            ),
            lustre@attribute:content(erlang:integer_to_binary(Content))]
    ).

-file("src/lustre/ssg/opengraph.gleam", 54).
-spec image_height(integer()) -> lustre@vdom@vnode:element(any()).
image_height(Content) ->
    lustre@element@html:meta(
        [lustre@attribute:attribute(
                <<"property"/utf8>>,
                <<"og:image:height"/utf8>>
            ),
            lustre@attribute:content(erlang:integer_to_binary(Content))]
    ).

-file("src/lustre/ssg/opengraph.gleam", 61).
-spec image_alt(binary()) -> lustre@vdom@vnode:element(any()).
image_alt(Content) ->
    lustre@element@html:meta(
        [lustre@attribute:attribute(
                <<"property"/utf8>>,
                <<"og:image:alt"/utf8>>
            ),
            lustre@attribute:content(Content)]
    ).
