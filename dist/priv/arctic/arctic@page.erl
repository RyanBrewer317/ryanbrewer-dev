-module(arctic@page).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([new/1, with_body/2, with_metadata/3, replace_metadata/2, with_title/2, with_blerb/2, with_tags/2, with_date/2]).

-spec new(binary()) -> arctic:page().
new(Id) ->
    {page, Id, [], gleam@dict:new(), <<""/utf8>>, <<""/utf8>>, [], none}.

-spec with_body(arctic:page(), list(lustre@internals@vdom:element(nil))) -> arctic:page().
with_body(P, Body) ->
    {page,
        erlang:element(2, P),
        Body,
        erlang:element(4, P),
        erlang:element(5, P),
        erlang:element(6, P),
        erlang:element(7, P),
        erlang:element(8, P)}.

-spec with_metadata(arctic:page(), binary(), binary()) -> arctic:page().
with_metadata(P, Key, Val) ->
    {page,
        erlang:element(2, P),
        erlang:element(3, P),
        gleam@dict:insert(erlang:element(4, P), Key, Val),
        erlang:element(5, P),
        erlang:element(6, P),
        erlang:element(7, P),
        erlang:element(8, P)}.

-spec replace_metadata(arctic:page(), gleam@dict:dict(binary(), binary())) -> arctic:page().
replace_metadata(P, Metadata) ->
    {page,
        erlang:element(2, P),
        erlang:element(3, P),
        Metadata,
        erlang:element(5, P),
        erlang:element(6, P),
        erlang:element(7, P),
        erlang:element(8, P)}.

-spec with_title(arctic:page(), binary()) -> arctic:page().
with_title(P, Title) ->
    {page,
        erlang:element(2, P),
        erlang:element(3, P),
        erlang:element(4, P),
        Title,
        erlang:element(6, P),
        erlang:element(7, P),
        erlang:element(8, P)}.

-spec with_blerb(arctic:page(), binary()) -> arctic:page().
with_blerb(P, Blerb) ->
    {page,
        erlang:element(2, P),
        erlang:element(3, P),
        erlang:element(4, P),
        erlang:element(5, P),
        Blerb,
        erlang:element(7, P),
        erlang:element(8, P)}.

-spec with_tags(arctic:page(), list(binary())) -> arctic:page().
with_tags(P, Tags) ->
    {page,
        erlang:element(2, P),
        erlang:element(3, P),
        erlang:element(4, P),
        erlang:element(5, P),
        erlang:element(6, P),
        Tags,
        erlang:element(8, P)}.

-spec with_date(arctic:page(), birl:time()) -> arctic:page().
with_date(P, Date) ->
    {page,
        erlang:element(2, P),
        erlang:element(3, P),
        erlang:element(4, P),
        erlang:element(5, P),
        erlang:element(6, P),
        erlang:element(7, P),
        {some, Date}}.
