-module(arctic@page).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).
-define(FILEPATH, "src/arctic/page.gleam").
-export([new/1, with_body/2, with_metadata/3, replace_metadata/2, with_title/2, with_blerb/2, with_tags/2, with_date/2]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-file("src/arctic/page.gleam", 8).
?DOC(" Construct a new page, with the given ID and default-everything.\n").
-spec new(binary()) -> arctic:page().
new(Id) ->
    {page, Id, [], maps:new(), <<""/utf8>>, <<""/utf8>>, [], none}.

-file("src/arctic/page.gleam", 22).
?DOC(
    " Add a \"body\" to a page. \n"
    " A body is the list of elements that will appear when the page is loaded.\n"
).
-spec with_body(arctic:page(), list(lustre@vdom@vnode:element(nil))) -> arctic:page().
with_body(P, Body) ->
    _record = P,
    {page,
        erlang:element(2, _record),
        Body,
        erlang:element(4, _record),
        erlang:element(5, _record),
        erlang:element(6, _record),
        erlang:element(7, _record),
        erlang:element(8, _record)}.

-file("src/arctic/page.gleam", 33).
?DOC(
    " Add some metadata to a page.\n"
    " This is any string key and value, that you can look up during parsing later.\n"
    " Sorry for the lack of type safety! \n"
    " Processing mismatches are handled with `snag` results,\n"
    " which is like compile-time errors since the run-time is at build-time.\n"
    " Also, note that some metadata gets privileged fields store in a different way, \n"
    " like `.date`. This adds type safety and convenience, and is opt-in.\n"
).
-spec with_metadata(arctic:page(), binary(), binary()) -> arctic:page().
with_metadata(P, Key, Val) ->
    _record = P,
    {page,
        erlang:element(2, _record),
        erlang:element(3, _record),
        gleam@dict:insert(erlang:element(4, P), Key, Val),
        erlang:element(5, _record),
        erlang:element(6, _record),
        erlang:element(7, _record),
        erlang:element(8, _record)}.

-file("src/arctic/page.gleam", 40).
?DOC(
    " Swap out the entirety of the metadata for a page with a new dictionary,\n"
    " except for the privileged metadata like `.title` and `.date`.\n"
    " This is useful for if you're building a metadata dictionary programmatically.\n"
).
-spec replace_metadata(arctic:page(), gleam@dict:dict(binary(), binary())) -> arctic:page().
replace_metadata(P, Metadata) ->
    _record = P,
    {page,
        erlang:element(2, _record),
        erlang:element(3, _record),
        Metadata,
        erlang:element(5, _record),
        erlang:element(6, _record),
        erlang:element(7, _record),
        erlang:element(8, _record)}.

-file("src/arctic/page.gleam", 45).
?DOC(" Add a title to a page.\n").
-spec with_title(arctic:page(), binary()) -> arctic:page().
with_title(P, Title) ->
    _record = P,
    {page,
        erlang:element(2, _record),
        erlang:element(3, _record),
        erlang:element(4, _record),
        Title,
        erlang:element(6, _record),
        erlang:element(7, _record),
        erlang:element(8, _record)}.

-file("src/arctic/page.gleam", 51).
?DOC(
    " Add a blerb (description, whatever) to a page.\n"
    " This is useful for nice thumbnails.\n"
).
-spec with_blerb(arctic:page(), binary()) -> arctic:page().
with_blerb(P, Blerb) ->
    _record = P,
    {page,
        erlang:element(2, _record),
        erlang:element(3, _record),
        erlang:element(4, _record),
        erlang:element(5, _record),
        Blerb,
        erlang:element(7, _record),
        erlang:element(8, _record)}.

-file("src/arctic/page.gleam", 57).
?DOC(
    " Add tags to a page.\n"
    " This is useful for implementing a helpful search.\n"
).
-spec with_tags(arctic:page(), list(binary())) -> arctic:page().
with_tags(P, Tags) ->
    _record = P,
    {page,
        erlang:element(2, _record),
        erlang:element(3, _record),
        erlang:element(4, _record),
        erlang:element(5, _record),
        erlang:element(6, _record),
        Tags,
        erlang:element(8, _record)}.

-file("src/arctic/page.gleam", 64).
?DOC(
    " Add a date to a page.\n"
    " This is useful for sorting pages by date in a list,\n"
    " like in a blog.\n"
).
-spec with_date(arctic:page(), gleam@time@timestamp:timestamp()) -> arctic:page().
with_date(P, Date) ->
    _record = P,
    {page,
        erlang:element(2, _record),
        erlang:element(3, _record),
        erlang:element(4, _record),
        erlang:element(5, _record),
        erlang:element(6, _record),
        erlang:element(7, _record),
        {some, Date}}.
