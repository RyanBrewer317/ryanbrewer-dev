-module(arctic@page).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([new/1, with_body/2, with_metadata/3, replace_metadata/2, with_title/2, with_blerb/2, with_tags/2, with_date/2]).

-spec new(binary()) -> arctic:page().
new(Id) ->
    {page, Id, [], gleam@dict:new(), <<""/utf8>>, <<""/utf8>>, [], none}.

-spec with_body(arctic:page(), list(lustre@internals@vdom:element(nil))) -> arctic:page().
with_body(P, Body) ->
    erlang:setelement(3, P, Body).

-spec with_metadata(arctic:page(), binary(), binary()) -> arctic:page().
with_metadata(P, Key, Val) ->
    erlang:setelement(4, P, gleam@dict:insert(erlang:element(4, P), Key, Val)).

-spec replace_metadata(arctic:page(), gleam@dict:dict(binary(), binary())) -> arctic:page().
replace_metadata(P, Metadata) ->
    erlang:setelement(4, P, Metadata).

-spec with_title(arctic:page(), binary()) -> arctic:page().
with_title(P, Title) ->
    erlang:setelement(5, P, Title).

-spec with_blerb(arctic:page(), binary()) -> arctic:page().
with_blerb(P, Blerb) ->
    erlang:setelement(6, P, Blerb).

-spec with_tags(arctic:page(), list(binary())) -> arctic:page().
with_tags(P, Tags) ->
    erlang:setelement(7, P, Tags).

-spec with_date(arctic:page(), birl:time()) -> arctic:page().
with_date(P, Date) ->
    erlang:setelement(8, P, {some, Date}).
